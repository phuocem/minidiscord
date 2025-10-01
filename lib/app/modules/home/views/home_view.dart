import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat Rooms'),
        backgroundColor: colors.primaryContainer,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.chatRooms.isEmpty) {
          return const Center(child: Text('No chat rooms found.'));
        }
        return ListView.builder(
          itemCount: controller.chatRooms.length,
          itemBuilder: (context, index) {
            final room = controller.chatRooms[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: colors.secondaryContainer,
                child: const Icon(Icons.chat_bubble_outline),
              ),
              title: Text(room['name'] ?? 'No name'),
              subtitle: Text(room['is_group'] == true ? 'Group chat' : 'Private chat'),
              onTap: () {
                // TODO: mở ChatPage(room['id'])

              },
            );
          },
        );
      }),
    );
  }
}
