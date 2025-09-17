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

      ),
    );
  }

  Widget _buildAvatar(ColorScheme colors) {
    return SizedBox(
      width: _avatarSize,
      height: _avatarSize,
      child: Container(
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
      ),
    );
  }
}
