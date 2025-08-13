import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../../data/models/ProfileModel.dart';

class EditProfileDialog extends StatefulWidget {
  final ProfileModel profile;
  final ColorScheme colorScheme;
  final void Function(ProfileModel updatedProfile) onSave;

  const EditProfileDialog({
    super.key,
    required this.profile,
    required this.colorScheme,
    required this.onSave,
  });

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController nameController;
  late TextEditingController avatarUrlController;
  String? avatarUrl;
  bool isAvatarUrlValid = true;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.username);
    avatarUrlController = TextEditingController(text: widget.profile.avatarUrl);
    avatarUrl = widget.profile.avatarUrl;

    avatarUrlController.addListener(() {
      final url = avatarUrlController.text.trim();
      setState(() {
        avatarUrl = url;
        isAvatarUrlValid = url.isEmpty || isValidImageUrl(url);
      });
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    avatarUrlController.dispose();
    super.dispose();
  }

  bool isValidImageUrl(String? url) {
    if (url == null || url.isEmpty) return true; // Cho phép URL trống
    final uri = Uri.tryParse(url);
    return uri != null &&
        uri.hasAbsolutePath &&
        (url.endsWith('.png') ||
            url.endsWith('.jpg') ||
            url.endsWith('.jpeg') ||
            url.endsWith('.gif') ||
            url.endsWith('.webp'));
  }

  ImageProvider getAvatarImage() {
    if (isAvatarUrlValid && avatarUrl != null && avatarUrl!.isNotEmpty) {
      return NetworkImage(avatarUrl!);
    }
    return widget.profile.avatarUrl != null && isValidImageUrl(widget.profile.avatarUrl)
        ? NetworkImage(widget.profile.avatarUrl!)
        : const AssetImage('assets/default_avatar.png');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: widget.colorScheme.surface.withOpacity(0.95),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Chỉnh sửa hồ sơ',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: widget.colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  letterSpacing: 0.5,
                ),
              ).animate().fadeIn(duration: 300.ms).slideY(
                begin: -0.3,
                end: 0,
                curve: Curves.easeOut,
              ),
            ),
            const SizedBox(height: 20),

            // Avatar preview with gradient border
            Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      widget.colorScheme.primary.withOpacity(0.7),
                      widget.colorScheme.secondary.withOpacity(0.5),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: widget.colorScheme.shadow.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: getAvatarImage(),
                    backgroundColor: widget.colorScheme.primary.withOpacity(0.1),
                  ),
                ),
              ).animate().fadeIn(duration: 300.ms, delay: 100.ms).scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.0, 1.0),
                curve: Curves.easeOutBack,
              ),
            ),
            const SizedBox(height: 16),

            // Avatar URL field
            TextField(
              controller: avatarUrlController,
              decoration: InputDecoration(
                labelText: 'URL ảnh đại diện',
                labelStyle: TextStyle(color: widget.colorScheme.onSurface),
                filled: true,
                fillColor: widget.colorScheme.surfaceVariant.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: widget.colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: widget.colorScheme.primary),
                ),
                errorText: isAvatarUrlValid ? null : 'URL ảnh không hợp lệ',
                errorStyle: TextStyle(color: widget.colorScheme.error),
              ),
              style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: widget.colorScheme.onSurface),
            ),
            const SizedBox(height: 16),

            // Name field
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Tên',
                labelStyle: TextStyle(color: widget.colorScheme.onSurface),
                filled: true,
                fillColor: widget.colorScheme.surfaceVariant.withOpacity(0.8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: widget.colorScheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: widget.colorScheme.primary),
                ),
              ),
              style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: widget.colorScheme.onSurface),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Hủy',
                    style: TextStyle(
                      color: widget.colorScheme.error,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ).animate().fadeIn(duration: 200.ms, delay: 300.ms),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.colorScheme.primary,
                    foregroundColor: widget.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    shadowColor: widget.colorScheme.shadow.withOpacity(0.3),
                  ),
                  onPressed: () {
                    if (!isAvatarUrlValid && avatarUrlController.text.isNotEmpty) {
                      Get.snackbar(
                        'Lỗi',
                        'URL ảnh không hợp lệ',
                        colorText: Colors.white,
                        backgroundColor: widget.colorScheme.error,
                        borderRadius: 10,
                        margin: const EdgeInsets.all(10),
                      );
                      return;
                    }
                    final updatedProfile = widget.profile.copyWith(
                      username: nameController.text.trim(),
                      avatarUrl: avatarUrlController.text.trim(),
                    );
                    widget.onSave(updatedProfile);
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Lưu',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                    ),
                  ).animate().fadeIn(duration: 200.ms, delay: 300.ms),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate()
        .fade(duration: 300.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.0, 1.0), curve: Curves.easeOutBack);
  }
}