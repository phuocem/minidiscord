import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import '../../../../main.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;

  @override
  void initState() {
    super.initState();

    if (cameras.isNotEmpty) {
      _controller = CameraController(
        cameras[0], // dùng camera sau
        ResolutionPreset.medium,
      );
      _initializeControllerFuture = _controller!.initialize();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return const Scaffold(
        body: Center(child: Text("Không tìm thấy camera")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Camera")),
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller!.takePicture();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Ảnh đã chụp: ${image.path}')),
              );
            }
          } catch (e) {
            print("❌ Lỗi chụp ảnh: $e");
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
