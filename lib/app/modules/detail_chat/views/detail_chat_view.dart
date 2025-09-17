import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_chat_controller.dart';

class DetailChatView extends GetView<DetailChatController> {
  DetailChatView({super.key});

  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.friendName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              controller.friendEmail,
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          /// Danh sách tin nhắn
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.messages.isEmpty) {
                return const Center(child: Text("Chưa có tin nhắn"));
              }

              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: controller.messages.length,
                itemBuilder: (context, index) {
                  final msg = controller.messages[index];

                  // Handle different possible column names for sender identification
                  final senderId = msg['sender_id'] ??
                      msg['user_id'] ??
                      msg['from_user_id'] ??
                      msg['author_id'];
                  final isMe = senderId == controller.currentUserId;

                  // Handle different possible column names for message content
                  final content = msg['content'] ?? msg['message'] ?? msg['text'] ?? '';

                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 14),
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 8),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue[300] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        content,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          /// Ô nhập tin nhắn + nút gửi
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      decoration: const InputDecoration(
                        hintText: "Nhập tin nhắn...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onSubmitted: (text) {
                        if (text.trim().isNotEmpty) {
                          controller.sendMessage(text.trim());
                          textController.clear();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: () {
                      final text = textController.text.trim();
                      if (text.isNotEmpty) {
                        controller.sendMessage(text);
                        textController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
