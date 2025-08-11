import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/ProfileModel.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;

  var profile = Rxn<ProfileModel>();

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  /// Load profile từ bảng profiles theo user hiện tại
  Future<void> loadProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      profile.value = null;
      return;
    }

    try {
      final data = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data != null) {
        profile.value = ProfileModel.fromMap(data);
      } else {
        // Tạo mới profile nếu chưa có
        final newProfile = ProfileModel(
          id: user.id,
          email: user.email,
          username: user.userMetadata?['username'] ?? '',
          avatarUrl: user.userMetadata?['avatar_url'] ?? '',
          createdAt: DateTime.now(),
        );
        await supabase.from('profiles').insert(newProfile.toMap());
        profile.value = newProfile;
      }
    } catch (e) {
      print('❌ Lỗi load profile: $e');
    }
  }

  /// Cập nhật profile username và avatarUrl
  Future<void> updateProfile({String? username, String? avatarUrl}) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final updates = <String, dynamic>{};
    if (username != null && username.isNotEmpty) {
      updates['username'] = username;
    }
    if (avatarUrl != null && avatarUrl.isNotEmpty) {
      updates['avatar_url'] = avatarUrl;
    }
    if (updates.isEmpty) return;

    try {
      print('Updating profile with: $updates');
      await supabase.from('profiles').update(updates).eq('id', user.id);

      final current = profile.value;
      if (current != null) {
        profile.value = ProfileModel(
          id: current.id,
          email: current.email,
          username: updates['username'] ?? current.username,
          avatarUrl: updates['avatar_url'] ?? current.avatarUrl,
          createdAt: current.createdAt,
        );
      }
    } catch (e) {
      print('❌ Lỗi update profile: $e');
    }
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    profile.value = null;
    Get.offAllNamed('/login');
  }
}
