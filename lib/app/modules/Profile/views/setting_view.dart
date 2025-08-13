import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../../../data/models/ProfileModel.dart';
import '../controllers/setting_controller.dart';
import 'EditProfileDialog.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a refined color palette
    const primaryColor = Color(0xFF6D28D9); // Softer deep purple
    const secondaryColor = Color(0xFF34D399); // Softer teal-green
    const backgroundColor = Color(0xFFF9FAFB); // Warmer light grey
    const darkBackgroundColor = Color(0xFF1F2937); // Softer dark grey
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? darkBackgroundColor : backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Cài đặt',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 26,
            fontFamily: 'Poppins',
            letterSpacing: 0.5,
            shadows: [
              Shadow(
                color: Colors.black12,
                offset: Offset(0, 1),
                blurRadius: 3,
              ),
            ],
          ),
        ).animate().fadeIn(duration: 400.ms).slideY(
          begin: -0.3,
          end: 0,
          duration: 400.ms,
          curve: Curves.easeOut,
        ),
        centerTitle: true,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded, size: 28),
            onPressed: () {
              Get.snackbar(
                'Cài đặt',
                'Đã nhấn vào biểu tượng cài đặt',
                backgroundColor: Colors.white.withOpacity(0.9),
                colorText: primaryColor,
                snackPosition: SnackPosition.BOTTOM,
                borderRadius: 10,
                margin: const EdgeInsets.all(10),
              );
            },
            tooltip: 'Cài đặt thêm',
          ).animate()
              .fadeIn(duration: 400.ms, delay: 100.ms)
              .scale(
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
            curve: Curves.easeOut,
          ),
        ],
      ),
      body: Column(
        children: [
          // Profile Header (with borderRadius)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.85),
                  secondaryColor.withOpacity(0.6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Obx(() {
              if (controller.profile.value == null) {
                return Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      const CircularProgressIndicator(
                        color: secondaryColor,
                        strokeWidth: 4,
                      ),
                    ],
                  ).animate().fadeIn(duration: 400.ms),
                );
              }
              final profile = controller.profile.value!;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar (with borderRadius)
                  GestureDetector(
                    onTap: () => Get.dialog(
                      EditProfileDialog(
                        profile: profile,
                        colorScheme: Theme.of(context).colorScheme,
                        onSave: (updatedProfile) {
                          controller.updateUserProfile(
                            newName: updatedProfile.username,
                            avatarUrl: updatedProfile.avatarUrl,
                          );
                        },
                      ),
                    ),
                    child: Obx(
                          () => Container(
                            padding: const EdgeInsets.all(2), // độ dày viền
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50), // bo góc 50px
                              gradient: LinearGradient(
                                colors: [
                                  Colors.red,
                                  Colors.orange,
                                  Colors.blue,
                                  Colors.black,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.2),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50), // Đảm bảo nội dung bo góc
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: profile.avatarUrl != null
                                ? NetworkImage(profile.avatarUrl!)
                                : const AssetImage('assets/default_avatar.png') as ImageProvider,
                          ),
                        ),
                      ).animate(
                        target: controller.isAvatarTapped.value ? 1 : 0,
                        effects: [
                          ScaleEffect(
                            begin: const Offset(1.0, 1.0),
                            end: const Offset(0.95, 0.95),
                            duration: 200.ms,
                            curve: Curves.easeInOut,
                          ),
                          ShakeEffect(
                            duration: 200.ms,
                            hz: 4,
                            offset: const Offset(2, 0),
                            curve: Curves.easeInOut,
                          ),
                        ],
                      ).animate(
                        effects: [
                          ScaleEffect(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1.0, 1.0),
                            duration: 500.ms,
                            curve: Curves.easeOut,
                          ),
                          FadeEffect(
                            begin: 0.0,
                            end: 1.0,
                            duration: 500.ms,
                            curve: Curves.easeOut,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Username + edit icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => Get.dialog(
                          EditProfileDialog(
                            profile: profile,
                            colorScheme: Theme.of(context).colorScheme,
                            onSave: (updatedProfile) {
                              controller.updateUserProfile(
                                newName: updatedProfile.username,
                                avatarUrl: updatedProfile.avatarUrl,
                              );
                            },
                          ),
                        ),
                        child: Obx(() => Text(
                          profile.username ?? 'Chưa cung cấp',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            letterSpacing: 0.4,
                          ),
                        ).animate(
                          target: controller.isProfileLoaded.value ? 1 : 0,
                          effects: [
                            FadeEffect(
                              begin: 0.0,
                              end: 1.0,
                              duration: 400.ms,
                              curve: Curves.easeOut,
                            ),
                            SlideEffect(
                              begin: const Offset(0, 0.3),
                              end: Offset.zero,
                              duration: 400.ms,
                              curve: Curves.easeOut,
                            ),
                          ],
                        )),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => Get.dialog(
                          EditProfileDialog(
                            profile: profile,
                            colorScheme: Theme.of(context).colorScheme,
                            onSave: (updatedProfile) {
                              controller.updateUserProfile(
                                newName: updatedProfile.username,
                                avatarUrl: updatedProfile.avatarUrl,
                              );
                            },
                          ),
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          size: 20,
                          color: Colors.white70,
                        ).animate()
                            .fadeIn(duration: 400.ms, delay: 100.ms)
                            .scale(
                          begin: const Offset(0.9, 0.9),
                          end: const Offset(1.0, 1.0),
                          curve: Curves.easeOut,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Email
                  Obx(() => Text(
                    profile.email ?? 'Chưa cung cấp',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                      fontFamily: 'Poppins',
                    ),
                  ).animate(
                    target: controller.isProfileLoaded.value ? 1 : 0,
                    effects: [
                      FadeEffect(
                        begin: 0.0,
                        end: 1.0,
                        duration: 400.ms,
                        curve: Curves.easeOut,
                        delay: 150.ms,
                      ),
                      SlideEffect(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                        duration: 400.ms,
                        curve: Curves.easeOut,
                        delay: 150.ms,
                      ),
                    ],
                  )),
                ],
              );
            }),
          ),
          // Settings list
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSettingCard(
                  primaryColor: primaryColor,
                  secondaryColor: secondaryColor,
                  isDarkMode: isDarkMode,
                  darkBackgroundColor: darkBackgroundColor,
                  icon: Icons.lock_rounded,
                  title: 'Bảo mật tài khoản',
                  onTap: () {
                    Get.snackbar(
                      'Bảo mật',
                      'Đã nhấn vào cài đặt bảo mật',
                      backgroundColor: Colors.white.withOpacity(0.9),
                      colorText: primaryColor,
                      snackPosition: SnackPosition.BOTTOM,
                      borderRadius: 8,
                      margin: const EdgeInsets.all(8),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildSettingCard(
                  primaryColor: primaryColor,
                  secondaryColor: secondaryColor,
                  isDarkMode: isDarkMode,
                  darkBackgroundColor: darkBackgroundColor,
                  icon: Icons.notifications_rounded,
                  title: 'Thông báo',
                  onTap: () {
                    Get.snackbar(
                      'Thông báo',
                      'Đã nhấn vào cài đặt thông báo',
                      backgroundColor: Colors.white.withOpacity(0.9),
                      colorText: primaryColor,
                      snackPosition: SnackPosition.BOTTOM,
                      borderRadius: 8,
                      margin: const EdgeInsets.all(8),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Obx(() => ElevatedButton.icon(
                  onPressed: () {
                    controller.isButtonTapped.value = true;
                    Future.delayed(200.ms, () {
                      controller.isButtonTapped.value = false;
                      Get.back();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      fontFamily: 'Poppins',
                    ),
                    elevation: 3,
                    shadowColor: Colors.red.withOpacity(0.2),
                  ),
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: const Text('Đăng xuất'),
                ).animate(
                  target: controller.isButtonTapped.value ? 1 : 0,
                  effects: [
                    ScaleEffect(
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(0.96, 0.96),
                      duration: 200.ms,
                      curve: Curves.easeInOut,
                    ),
                  ],
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required Color primaryColor,
    required Color secondaryColor,
    required bool isDarkMode,
    required Color darkBackgroundColor,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: primaryColor.withOpacity(0.05), width: 0.5),
      ),
      color: isDarkMode ? darkBackgroundColor.withOpacity(0.9) : Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: primaryColor.withOpacity(0.1),
                radius: 18,
                child: Icon(icon, color: primaryColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: secondaryColor.withOpacity(0.4),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    ).animate()
        .fadeIn(duration: 400.ms, delay: 100.ms)
        .scale(
      begin: const Offset(0.96, 0.96),
      end: const Offset(1.0, 1.0),
      curve: Curves.easeOut,
    );
  }
}