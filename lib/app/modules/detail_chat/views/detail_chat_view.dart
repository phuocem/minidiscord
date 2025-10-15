import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/detail_chat_controller.dart';

class DetailChatView extends GetView<DetailChatController> {
  const DetailChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.friendName),
        elevation: 1,
      ),
      body: Column(
        children: [
          // Message list
          Expanded(
            child: Obx(() {
              final msgs = controller.messages;
              return ListView.builder(
                controller: controller.scrollController,
                padding: const EdgeInsets.all(12),
                itemCount: msgs.length,
                itemBuilder: (_, index) {
                  final msg = msgs[index];
                  final isMine = msg.isMine;

                  return Align(
                    alignment: isMine
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      decoration: BoxDecoration(
                        color: isMine
                            ? Colors.blueAccent.withOpacity(0.8)
                            : Colors.grey.shade300,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(12),
                          topRight: const Radius.circular(12),
                          bottomLeft:
                          isMine ? const Radius.circular(12) : Radius.zero,
                          bottomRight:
                          isMine ? Radius.zero : const Radius.circular(12),
                        ),
                      ),
                      child: Text(
                        msg.content,
                        style: TextStyle(
                            color: isMine ? Colors.white : Colors.black87),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // Input Field
          SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.messageController,
                      decoration: InputDecoration(
                        hintText: "Nhập tin nhắn...",
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.send, size: 26),
                    color: Colors.blueAccent,
                    onPressed: controller.sendMessage,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
