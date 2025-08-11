import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final username = ''.obs;
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isLoginForm = true.obs;

  final supabase = Supabase.instance.client;

  void showToast({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    Get.snackbar(
      '', '',
      titleText: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(
              child: Text(title,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        ],
      ),
      messageText: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: color.withOpacity(0.95),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.only(top: 30, right: 16),
      borderRadius: 12,
      maxWidth: 350,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> loginUser(String email, String password) async {
    isLoading.value = true;
    try {
      final res = await supabase.auth.signInWithPassword(
          email: email, password: password);
      if (res.user != null) {
        navigateToHome();
      } else {
        showToast(
            title: 'Lỗi',
            message: 'Sai email hoặc mật khẩu',
            icon: Icons.error,
            color: Colors.red);
      }
    } on AuthException catch (e) {
      showToast(
          title: 'Lỗi đăng nhập',
          message: e.message,
          icon: Icons.warning,
          color: Colors.red);
    } catch (e) {
      showToast(
          title: 'Lỗi hệ thống',
          message: '$e',
          icon: Icons.bug_report,
          color: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerUser({
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    if ([email, username, password, confirmPassword].any((e) => e.isEmpty)) {
      showToast(
          title: 'Thiếu thông tin',
          message: 'Điền đầy đủ các trường.',
          icon: Icons.info,
          color: Colors.orange);
      return;
    }
    if (password.length < 6) {
      showToast(
          title: 'Mật khẩu yếu',
          message: 'Tối thiểu 6 ký tự.',
          icon: Icons.lock_outline,
          color: Colors.red);
      return;
    }
    if (password != confirmPassword) {
      showToast(
          title: 'Xác nhận sai',
          message: 'Mật khẩu không khớp.',
          icon: Icons.warning,
          color: Colors.red);
      return;
    }

    isLoading.value = true;
    try {
      final res = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'display_name': username},
      );
      if (res.user != null) {
        showToast(
            title: 'Thành công',
            message: 'Tạo tài khoản thành công. Vui lòng đăng nhập.',
            icon: Icons.check_circle,
            color: Colors.green);
        isLoginForm.value = true;
      } else {
        showToast(
            title: 'Lỗi',
            message: 'Không thể tạo tài khoản.',
            icon: Icons.error_outline,
            color: Colors.red);
      }
    } on AuthException catch (e) {
      showToast(
          title: 'Lỗi đăng ký',
          message: e.message,
          icon: Icons.warning_amber,
          color: Colors.red);
    } catch (e) {
      showToast(
          title: 'Lỗi hệ thống',
          message: '$e',
          icon: Icons.bug_report,
          color: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> nativeGoogleSignIn() async {
    isLoading.value = true;
    const webClientId = '377618414149-q6f159k39o8mg2jqlq1e4q4qmfvppqdj.apps.googleusercontent.com';
    const iosClientId = '377618414149-ssa17spetbb096vei2jtgbfgau0lbl04.apps.googleusercontent.com';

    try {
      final google = GoogleSignIn(clientId: iosClientId, serverClientId: webClientId);
      await google.signOut(); // Force account selection
      final user = await google.signIn();
      final auth = await user?.authentication;

      if (auth?.accessToken == null || auth?.idToken == null) {
        throw 'Không lấy được token từ Google';
      }

      final response = await supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: auth!.idToken!,
        accessToken: auth.accessToken!,
      );

      if (response.user != null) {
        navigateToHome();
      } else {
        throw 'Không thể xác thực người dùng với Supabase';
      }
    } catch (e) {
      showToast(
        title: 'Lỗi Google Sign-In',
        message: '$e',
        icon: Icons.g_mobiledata,
        color: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToHome() {
    final user = supabase.auth.currentUser;
    if (user != null) {
      Get.offAllNamed('/layout');
    } else {
      showToast(
          title: 'Lỗi',
          message: 'Không thể xác thực người dùng',
          icon: Icons.warning,
          color: Colors.red);
    }
  }
}
