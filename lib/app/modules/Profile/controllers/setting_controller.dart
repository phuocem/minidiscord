import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/ProfileModel.dart';

class SettingController extends GetxController with GetSingleTickerProviderStateMixin {
  final supabase = Supabase.instance.client;
  final profile = Rx<ProfileModel?>(null);
  var isButtonTapped = false.obs;
  var isAvatarTapped = false.obs;
  var isDialogOpen = false.obs;
  var isProfileLoaded = false.obs;

  // Animation controller for gradient
  late AnimationController gradientController;

  @override
  void onInit() {
    super.onInit();
    // Initialize animation controller
    gradientController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    loadUserProfile();
  }

  @override
  void onClose() {
    gradientController.dispose();
    super.onClose();
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
        final metadataUpdates = <String, dynamic>{};
        bool hasChanges = false;

        // Validate and update username
        if (newName != null && newName.isNotEmpty && newName != profile.value!.username) {
          if (newName.length > 20) {
            throw 'Tên người dùng không được vượt quá 20 ký tự';
          }
          if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(newName)) {
            throw 'Tên người dùng chỉ được chứa chữ cái, số và dấu gạch dưới';
          }
          updates['username'] = newName;
          metadataUpdates['name'] = newName;
          hasChanges = true;
        }

        // Validate and update avatar URL
        if (avatarUrl != null && avatarUrl != profile.value!.avatarUrl) {
          if (avatarUrl.isNotEmpty && !Uri.parse(avatarUrl).isAbsolute) {
            throw 'URL ảnh không hợp lệ';
          }
          updates['avatar_url'] = avatarUrl.isNotEmpty ? avatarUrl : null;
          metadataUpdates['avatar_url'] = avatarUrl.isNotEmpty ? avatarUrl : null;
          hasChanges = true;
        }

        if (!hasChanges) {
          Get.snackbar('Thông báo', 'Không có thay đổi để cập nhật',
              colorText: Colors.white, backgroundColor: Colors.blue);
          return;
        }

        // Update profiles table
        bool profileUpdated = false;
        if (updates.isNotEmpty) {
          print('Updating profiles with: $updates');
          await supabase.from('profiles').update(updates).eq('id', currentUser.id);
          profileUpdated = true;
        }

        // Update user_metadata in auth
        bool metadataUpdated = false;
        if (metadataUpdates.isNotEmpty) {
          print('Updating user_metadata with: $metadataUpdates');
          await supabase.auth.updateUser(UserAttributes(data: metadataUpdates));
          metadataUpdated = true;
        }

        // Update local profile
        profile.value = profile.value!.copyWith(
          username: newName != null && newName.isNotEmpty ? newName : profile.value!.username,
          avatarUrl: avatarUrl != null ? avatarUrl : profile.value!.avatarUrl,
        );

        // Provide detailed feedback
        String message = 'Đã cập nhật hồ sơ thành công';
        if (profileUpdated && !metadataUpdated) {
          message = 'Cập nhật hồ sơ thành công, nhưng cập nhật metadata thất bại';
        } else if (!profileUpdated && metadataUpdated) {
          message = 'Cập nhật metadata thành công, nhưng cập nhật hồ sơ thất bại';
        }
        Get.snackbar('Thành công', message, colorText: Colors.white, backgroundColor: Colors.green);
      } catch (e) {
        print('Error updating profile: $e');
        Get.snackbar('Lỗi', 'Không thể cập nhật hồ sơ: $e', colorText: Colors.white, backgroundColor: Colors.red);
      }
    }
  }

  void logout() async {
    try {
      await supabase.auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error signing out: $e');
      Get.snackbar('Lỗi', 'Không thể đăng xuất: $e', colorText: Colors.white, backgroundColor: Colors.red);
    }
  }

  void toggleDialogState(bool isOpen) {
    isDialogOpen.value = isOpen;
  }
}
