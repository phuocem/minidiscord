import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            'https://cdn.leonardo.ai/users/81618a10-1000-445e-af8e-4c9aa75d72bb/generations/ddb9b77a-23da-42af-a16d-61a0c98b71ec/Leonardo_Phoenix_10_A_large_futuristic_virtual_space_with_mult_1.jpg',
            fit: BoxFit.cover,
          ),
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Xin chào đến với ...',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
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
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Obx(() => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (!controller.isLoginForm.value)
                                Column(
                                  children: [
                                    TextFormField(
                                      onChanged: (value) => controller.username.value = value,
                                      style: const TextStyle(color: Colors.black),
                                      decoration: _inputDecoration('Tên người dùng', Icons.person),
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              TextFormField(
                                onChanged: (value) => controller.email.value = value,
                                style: const TextStyle(color: Colors.black),
                                decoration: _inputDecoration('Email', Icons.email),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                obscureText: !controller.isPasswordVisible.value,
                                onChanged: (value) => controller.password.value = value,
                                style: const TextStyle(color: Colors.black),
                                decoration: _passwordInputDecoration(),
                              ),
                              if (!controller.isLoginForm.value) ...[
                                const SizedBox(height: 16),
                                TextFormField(
                                  obscureText: !controller.isPasswordVisible.value,
                                  onChanged: (value) => controller.confirmPassword.value = value,
                                  style: const TextStyle(color: Colors.black),
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
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(32),
                                    ),
                                  ),
                                  child: Text(
                                    controller.isLoginForm.value ? 'Đăng nhập' : 'Tạo tài khoản',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextButton(
                                onPressed: controller.nativeGoogleSignIn,
                                child: const Text(
                                  'Đăng nhập với Google',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
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
                                    color: Colors.white70,
                                    fontSize: 14,
                                    decoration: TextDecoration.underline,
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
            );
          }),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      prefixIcon: Icon(icon, color: Colors.black),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black45),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  InputDecoration _passwordInputDecoration() {
    return InputDecoration(
      labelText: 'Mật khẩu',
      labelStyle: const TextStyle(color: Colors.black),
      prefixIcon: const Icon(Icons.lock_outline, color: Colors.black),
      suffixIcon: IconButton(
        icon: Icon(
          controller.isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
          color: Colors.black,
        ),
        onPressed: () => controller.isPasswordVisible.toggle(),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black45),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
