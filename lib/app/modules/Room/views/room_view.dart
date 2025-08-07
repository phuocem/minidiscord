import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/room_controller.dart';

class RoomView extends GetView<RoomController> {
  const RoomView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RoomView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'RoomView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
