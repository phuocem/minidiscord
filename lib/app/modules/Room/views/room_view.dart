import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/room_controller.dart';
import 'camera_page.dart';

class RoomView extends GetView<RoomController> {
  const RoomView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RoomController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('RoomView'),
        centerTitle: true,
      ),
      body: Center(
        child: Obx(() {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.cameraGranted.value
                    ? "Đã có quyền camera"
                    : "Chưa có quyền camera",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await controller.requestCameraPermission();
                  if (controller.cameraGranted.value) {
                    Get.to(() => const CameraPage());
                  }
                },

                // child: const Text('Mở Camera')
                  child : ButtonTheme(child: Text("Mở camera"))
              ),

            ],
          );
        }),
      ),
    );
  }
}
