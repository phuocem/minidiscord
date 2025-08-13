import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  static const double _avatarSize = 45;
  static const double _lightningSize = 30;
  static const double _rowHeight = 84;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat List'),
        backgroundColor:const Color(0xFFE1BEE7),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFDDFAF6),
              Color(0xFFF1DDF4), // Tím nhạt
              // Xanh diệp lục nhạt
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Obx(
              () => ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: controller.chats.length,
            itemBuilder: (context, index) {
              final chat = controller.chats[index];
              final bool isOnline = chat.status == 'online';

              const activeColor = Color(0xFF00FF36);
              final inactiveColor = colors.onSurfaceVariant;
              final statusColor = isOnline ? activeColor : inactiveColor;

              return Container(
                height: _rowHeight,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Avatar
                    SizedBox(
                      width: _avatarSize,
                      height: _rowHeight,
                      child: Center(
                        child: _buildAvatar(chat, statusColor, colors),
                      ),
                    ),

                    // Lightning
                    SizedBox(
                      width: _lightningSize,
                      height: _rowHeight,
                      child: Center(
                        child: Transform.rotate(
                          angle: 180 * 3.1415926535 / 180,
                          child: Image.asset(
                            'assets/lightning.png',
                            width: _lightningSize,
                            height: _lightningSize,
                            color: statusColor,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 0),
                    // Chat bubble
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12, // Giảm từ 8 xuống 6
                        ),
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: colors.shadow.withValues(alpha: 0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Tên + giờ
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    chat.name,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  chat.time,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4), // Giảm từ 10 xuống 4

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    chat.lastMessage,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: colors.onSurfaceVariant,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                                if (chat.unread > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      chat.unread.toString(),
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: colors.onError,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(dynamic chat, Color borderColor, ColorScheme colors) {
    return SizedBox(
      width: _avatarSize,
      height: _avatarSize,
      child: Container(
        width: _avatarSize,
        height: _avatarSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
            width: 2, // Giảm từ 3 xuống 2 pixel
          ),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.25),
              blurRadius: 6,
              spreadRadius: 1,
            ),
          ],
          image: chat.avatar != null && chat.avatar.isNotEmpty
              ? DecorationImage(
            image: NetworkImage(chat.avatar),
            fit: BoxFit.cover,
          )
              : null,
          color: colors.surfaceContainerHighest,
        ),
        child: (chat.avatar == null || chat.avatar.isEmpty)
            ? Icon(
          Icons.person,
          size: 30,
          color: colors.onSurfaceVariant,
        )
            : null,
      ),
    );
  }
}