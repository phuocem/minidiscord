import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart'; // package animation
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../controllers/profile_controller.dart';
import 'EditProfileDialog.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nameController = TextEditingController();
    final avatarController = TextEditingController();
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Nền gradient nhẹ nhàng
          Container(
            height: screenHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFDDFAF6), // Xanh nhạt
                  Color(0xFFF1DDF4), // Tím nhạt
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          SafeArea(
            child: Obx(() {
              final profile = controller.profile.value;

              if (profile == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF26A69A),
                    strokeWidth: 4,
                  ),
                ).animate().fadeIn();
              }

              final name = profile.username ?? '';
              final email = profile.email ?? '';
              final avatar = profile.avatarUrl ?? '';

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Nút logout dưới cùng
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Card với animation gradient màu nhạt
                        AnimatedContainer(
                          duration: const Duration(seconds: 5),
                          curve: Curves.easeInOut,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFF9E9393),
                                Color(0xFFDDFAF6),
                              ],
                              stops: [0.1, 1.0], // Màu đầu 30%, màu sau 70%

                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Avatar ở góc trái
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.teal.shade50,
                                  backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
                                  child: avatar.isEmpty
                                      ? Text(
                                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                                    style: theme.textTheme.displayMedium?.copyWith(
                                      color: const Color(0xFF26A69A),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40,
                                    ),
                                  )
                                      : null,
                                ).animate().scale(duration: const Duration(milliseconds: 600)),

                                const SizedBox(width: 20),

                                // Tên và email ở góc phải của avatar
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // Tên với icon cây bút (edit) kế bên
                                      Row(
                                        children: [
                                          Text(
                                            name,
                                            style: theme.textTheme.headlineMedium?.copyWith(
                                              color: const Color(0xFF00695C),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24,
                                            ),
                                          ).animate().slideX(duration: const Duration(milliseconds: 600)),
                                          const SizedBox(width: 8),
                                          GestureDetector(
                                            onTap: () {
                                              nameController.text = name;
                                              avatarController.text = avatar;
                                              Get.dialog(
                                                EditProfileDialog(
                                                  nameController: nameController,
                                                  avatarController: avatarController,
                                                  onConfirm: () {
                                                    controller.updateProfile(
                                                      username: nameController.text.trim(),
                                                      avatarUrl: avatarController.text.trim(),
                                                    );
                                                    Get.back();
                                                  },
                                                ),
                                              );
                                            },
                                            child: const Icon(
                                              Icons.edit,
                                              size: 20,
                                              color: Color(0xFF26A69A),
                                            ).animate().fadeIn(duration: const Duration(milliseconds: 800)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      // Email dưới tên
                                      Text(
                                        email,
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: Colors.grey.shade700,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 16,
                                        ),
                                      ).animate().fadeIn(duration: const Duration(milliseconds: 800)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Nút logout ở dưới cùng, thu nhỏ
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: SizedBox(
                      width: 200, // Thu nhỏ chiều rộng
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.logout, size: 18, color: Color(0xFFF06292)),
                        label: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10), // Thu nhỏ chiều cao
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF06292),
                            ),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFF06292), width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20), // Bo tròn nhẹ hơn
                          ),
                        ),
                        onPressed: controller.signOut,
                      ).animate().scale(duration: const Duration(milliseconds: 700)),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}