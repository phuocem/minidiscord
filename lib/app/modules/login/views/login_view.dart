import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://cdn.leonardo.ai/users/1b016cca-4848-450c-9cef-409b9e89f1f3/generations/3a6f52fd-1458-41ea-82b7-4fe0a8c6906e/segments/1:4:1/Lucid_Origin_a_cinematic_photo_of_A_large_bright_futuristic_vi_0.jpg',
            fit: BoxFit.cover,
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator(color: Color(
                  0xFFAA46BB))); // Shimmering silver
            }

            return Center(
              child: SingleChildScrollView(
                child: AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Xin chào đến với ...',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFAA46BB), // Shimmering silver
                          shadows: [
                            Shadow(color: Colors.black38, offset: Offset(2, 2), blurRadius: 6),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(
                            width: 500,
                            padding: const EdgeInsets.all(32),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFFFFFF).withOpacity(0.25), Color(0xFFE0F7FA).withOpacity(0.35)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Color(0xFFAB47BC).withOpacity(0.5)), // Rich magenta border
                            ),
                            child: Obx(() => Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!controller.isLoginForm.value)
                                  Column(
                                    children: [
                                      TextFormField(
                                        onChanged: (value) => controller.username.value = value,
                                        style: const TextStyle(color: Color(0xFF212121)),
                                        decoration: _inputDecoration('Tên người dùng', Icons.person),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                TextFormField(
                                  onChanged: (value) => controller.email.value = value,
                                  style: const TextStyle(color: Color(0xFF212121)),
                                  decoration: _inputDecoration('Email', Icons.email),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  obscureText: !controller.isPasswordVisible.value,
                                  onChanged: (value) => controller.password.value = value,
                                  style: const TextStyle(color: Color(0xFF212121)),
                                  decoration: _passwordInputDecoration(),
                                ),

                                if (!controller.isLoginForm.value) ...[
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    obscureText: !controller.isPasswordVisible.value,
                                    onChanged: (value) => controller.confirmPassword.value = value,
                                    style: const TextStyle(color: Color(0xFF212121)),
                                    decoration: _inputDecoration('Xác nhận mật khẩu', Icons.lock),
                                  ),
                                ],

                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (controller.isLoginForm.value) {
                                        controller.loginUser(
                                          controller.email.value,
                                          controller.password.value,
                                        );
                                      } else {
                                        controller.registerUser(
                                          email: controller.email.value,
                                          password: controller.password.value,
                                          confirmPassword: controller.confirmPassword.value,
                                          username: controller.username.value,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(

                                      backgroundColor: Color(0xFFB761C1), // Deep cyan
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(32),
                                      ),
                                      elevation: 8,
                                    ),
                                    child: Text(
                                      controller.isLoginForm.value ? 'Đăng nhập' : 'Tạo tài khoản',
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: controller.nativeGoogleSignIn,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFFAA46BB),
                                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                      side: const BorderSide(color: Color(0xFFAA46BB)),
                                    ),
                                    elevation: 4,
                                  ),
                                  child: const Text(
                                    'Đăng nhập với Google',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFFAA46BB),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                GestureDetector(
                                  onTap: controller.isLoginForm.toggle,
                                  child: Text(
                                    controller.isLoginForm.value
                                        ? 'Chưa có tài khoản? Tạo tài khoản'
                                        : 'Đã có tài khoản? Đăng nhập',
                                    style: const TextStyle(
                                      color: Color(0xFFAA46BB), // Shimmering silver
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Color(0xFF212121)),
      prefixIcon: Icon(icon, color: Color(0xFF212121)),
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFAB47BC)), // Rich magenta
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFAA46BB)), // Shimmering silver
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  InputDecoration _passwordInputDecoration() {
    return InputDecoration(
      labelText: 'Mật khẩu',
      labelStyle: const TextStyle(color: Color(0xFF212121)),
      prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF212121)),
      suffixIcon: IconButton(
        icon: Icon(
          controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
          color: Color(0xFF212121),
        ),
        onPressed: () => controller.isPasswordVisible.toggle(),
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFAB47BC)), // Rich magenta
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFAA46BB)), // Shimmering silver
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}