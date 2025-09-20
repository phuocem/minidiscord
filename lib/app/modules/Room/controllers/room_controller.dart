import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class RoomController extends GetxController {
  var cameraGranted = false.obs;

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    cameraGranted.value = status.isGranted;

    if (status.isDenied) {
      Get.snackbar("Thông báo", "Bạn cần cấp quyền camera để sử dụng tính năng này.");
    } else if (status.isPermanentlyDenied) {
      Get.snackbar("Thông báo", "Vào cài đặt để bật quyền camera.");
      await openAppSettings();
    }
  }
}
