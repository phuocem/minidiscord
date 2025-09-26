import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  static const double _avatarSize = 45;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat List'),
        backgroundColor: const Color(0xFFE1BEE7),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFDDFAF6),
              Color(0xFFF1DDF4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        // child: Obx(() {
        //   if (controller.chatRooms.isEmpty) {
        //     return const Center(child: Text("No chats yet"));
        //   }
        //   return ListView.builder(
        //     itemCount: controller.chatRooms.length,
        //     itemBuilder: (context, index) {
        //       final room = controller.chatRooms[index];
        //       return ListTile(
        //         leading: _buildAvatar(colors),
        //         title: Text(
        //           room.name ?? "Private Chat",
        //           style: theme.textTheme.bodyLarge?.copyWith(
        //             fontWeight: FontWeight.bold,
        //           ),
        //         ),
        //         subtitle: Text(
        //           room.lastMessage ?? "",
        //           maxLines: 1,
        //           overflow: TextOverflow.ellipsis,
        //           style: theme.textTheme.bodyMedium,
        //         ),
        //         trailing: Text(
        //           room.lastMessageAt != null
        //               ? _formatTime(room.lastMessageAt!)
        //               : "",
        //           style: theme.textTheme.bodySmall,
        //         ),
        //         onTap: () {controller.loadChatRooms();}
        //       );
        //     },
        //   );
        // }),
      ),
    );
  }

  Widget _buildAvatar(ColorScheme colors) {
    return Container(
      width: _avatarSize,
      height: _avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.surfaceContainerHighest,
        border: Border.all(
          color: colors.primary,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.primary.withOpacity(0.25),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(
        Icons.person,
        size: 28,
        color: colors.onSurfaceVariant,
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (now.difference(time).inDays == 0) {
      // cùng ngày → hh:mm
      return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
    } else {
      // khác ngày → dd/MM
      return "${time.day}/${time.month}";
    }
  }
}
