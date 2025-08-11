import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_chat_controller.dart';

class DetailChatView extends GetView<DetailChatController> {
  const DetailChatView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DetailChatView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'DetailChatView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
