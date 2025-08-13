import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/ProfileModel.dart';

class SettingController extends GetxController {
  final supabase = Supabase.instance.client;
  final profile = Rx<ProfileModel?>(null);
  var isButtonTapped = false.obs;
  var isAvatarTapped = false.obs;
  var isDialogOpen = false.obs;
  var isProfileLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  Future<void> loadUserProfile() async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser != null) {
      try {
        final response = await supabase
            .from('profiles')
            .select()
            .eq('id', currentUser.id)
            .maybeSingle();

        if (response != null) {
          profile.value = ProfileModel.fromMap(response as Map<String, dynamic>);
        } else {
          final defaultProfile = ProfileModel(
            id: currentUser.id,
            email: currentUser.email,
            username: currentUser.userMetadata?['name'] ?? currentUser.email?.split('@')[0] ?? 'User_${currentUser.id.substring(0, 8)}',
            avatarUrl: currentUser.userMetadata?['avatar_url'],
            createdAt: DateTime.now(),
          );
          await supabase.from('profiles').upsert(defaultProfile.toMap());
          profile.value = defaultProfile;
        }
        isProfileLoaded.value = true;
        print('Loaded profile: ${profile.value?.toMap()}');
        print('User metadata: ${currentUser.userMetadata}');
      } catch (e) {
        print('Error loading profile: $e');
        profile.value = ProfileModel(
          id: currentUser.id,
          email: currentUser.email,
          username: 'Unknown',
          avatarUrl: null,
          createdAt: DateTime.now(),
        );
        isProfileLoaded.value = true;
      }
    }
  }

  Future<void> updateUserProfile({String? newName, String? avatarUrl}) async {
    final currentUser = supabase.auth.currentUser;
    if (currentUser != null && profile.value != null) {
      try {
        final updates = <String, dynamic>{};

        // Cập nhật tên nếu có và khác với hiện tại
        if (newName != null && newName.isNotEmpty && newName != profile.value!.username) {
          updates['username'] = newName;
        }

        // Cập nhật avatar_url nếu có và khác với hiện tại
        if (avatarUrl != null && avatarUrl != profile.value!.avatarUrl) {
          // Kiểm tra URL hợp lệ (cho phép trống để xóa avatar)
          if (avatarUrl.isNotEmpty && !Uri.parse(avatarUrl).isAbsolute) {
            throw 'URL ảnh không hợp lệ';
          }
          updates['avatar_url'] = avatarUrl.isNotEmpty ? avatarUrl : null;
        }

        // Cập nhật bảng profiles nếu có thay đổi
        if (updates.isNotEmpty) {
          print('Updating profiles with: $updates');
          await supabase
              .from('profiles')
              .update(updates)
              .eq('id', currentUser.id);
        }

        // Cập nhật user_metadata trong auth
        final metadataUpdates = <String, dynamic>{};
        if (newName != null && newName.isNotEmpty && newName != profile.value!.username) {
          metadataUpdates['name'] = newName;
        }
        if (avatarUrl != null && avatarUrl != profile.value!.avatarUrl) {
          metadataUpdates['avatar_url'] = avatarUrl.isNotEmpty ? avatarUrl : null;
        }
        if (metadataUpdates.isNotEmpty) {
          print('Updating user_metadata with: $metadataUpdates');
          await supabase.auth.updateUser(
            UserAttributes(data: metadataUpdates),
          );
        }

        // Cập nhật profile.value
        profile.value = profile.value!.copyWith(
          username: newName != null && newName.isNotEmpty ? newName : profile.value!.username,
          avatarUrl: avatarUrl != null ? avatarUrl : profile.value!.avatarUrl,
        );

        Get.snackbar('Thành công', 'Đã cập nhật hồ sơ', colorText: Colors.white, backgroundColor: Colors.green);
      } catch (e) {
        print('Error updating profile: $e');
        Get.snackbar('Lỗi', 'Không thể cập nhật hồ sơ: $e', colorText: Colors.white, backgroundColor: Colors.red);
      }
    }
  }

  void toggleDialogState(bool isOpen) {
    isDialogOpen.value = isOpen;
  }
}