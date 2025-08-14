import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define a modern color palette
    const primaryColor = Color(0xFF6200EA);
    const secondaryColor = Color(0xFF03DAC6);
    const backgroundColor = Color(0xFFF5F7FA);
    const darkBackgroundColor = Color(0xFF121212);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withOpacity(0.9),
              secondaryColor.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.0, 1.0],
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 65,
                      height: 65,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 0,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    const CircularProgressIndicator(
                      color: secondaryColor,
                      strokeWidth: 5,
                    ),
                  ],
                ).animate().fadeIn(duration: 400.ms, curve: Curves.easeInOut),
              );
            }
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      'Xin chào!',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        letterSpacing: 0.8,
                      ),
                    ).animate().fadeIn(duration: 500.ms, delay: 100.ms).slideY(
                      begin: -0.3,
                      end: 0,
                      curve: Curves.easeOutCubic,
                    ),
                    const SizedBox(height: 12),
                    // Subtitle
                    Text(
                      'Chưa Ngỉ Ra',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.85),
                        fontFamily: 'Poppins',
                      ),
                    ).animate().fadeIn(duration: 500.ms, delay: 200.ms).slideY(
                      begin: -0.2,
                      end: 0,
                      curve: Curves.easeOutCubic,
                    ),
                    const SizedBox(height: 36),
                    // Login Section
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Google Sign-In Button
                        ElevatedButton.icon(
                          onPressed: controller.nativeGoogleSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 28,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(
                                color: primaryColor.withOpacity(0.7),
                                width: 1,
                              ),
                            ),
                            elevation: 6,
                            minimumSize: const Size(220, 56),
                          ),

                          label: const Text(
                            'Đăng nhập với Google',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              color: primaryColor,
                            ),
                          ),
                          icon: Image.network(
                            'https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_92x30dp.png',
                            height: 24,
                            errorBuilder: (context, error, stackTrace) => const Icon(
                              Icons.g_mobiledata_rounded,
                              size: 24,
                              color: primaryColor,
                            ),
                          ),
                        ).animate().fadeIn(duration: 400.ms, delay: 400.ms).slideX(
                          begin: 0.2,
                          end: 0,
                          curve: Curves.easeOutCubic,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}