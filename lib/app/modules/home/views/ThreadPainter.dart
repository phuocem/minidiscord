import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThreadPainter extends CustomPainter {
  final double centerX;
  final double centerY;
  final bool isOnline;
  final ui.Image lightningImage;

  ThreadPainter({
    required this.centerX,
    required this.centerY,
    required this.isOnline,
    required this.lightningImage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Lưu trạng thái canvas
    canvas.save();

    // Di chuyển tâm xoay về đúng vị trí avatar
    canvas.translate(centerX, centerY);

    // Xoay 90 độ (π/2 radian)
    canvas.rotate(90 * 3.1415926535 / 180);

    // Đưa ảnh về tâm
    canvas.translate(-lightningImage.width / 2, -lightningImage.height / 2);

    // Vẽ ảnh với màu theo trạng thái
    final paint = Paint()
      ..colorFilter = ColorFilter.mode(
        isOnline ? Colors.greenAccent : Colors.grey,
        BlendMode.srcIn,
      );

    canvas.drawImage(lightningImage, Offset.zero, paint);

    // Khôi phục canvas
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant ThreadPainter oldDelegate) {
    return oldDelegate.isOnline != isOnline ||
        oldDelegate.lightningImage != lightningImage;
  }

  // Hàm load ảnh (gọi trước khi vẽ)
  static Future<ui.Image> loadLightningImage(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frame = await codec.getNextFrame();
    return frame.image;
  }
}
