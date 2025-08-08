import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import '../controllers/layout_controller.dart';

class LayoutView extends GetView<LayoutController> {
  const LayoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFFF5F7FA); // Soft greyish-blue background
    return Scaffold(
      backgroundColor: bg,
      body: Obx(() {
        final currentIndex = controller.currentIndex.value;
        final currentPage = controller.pages[currentIndex];
        return Column(
          children: [
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                transitionBuilder: (child, animation) {
                  final offsetAnim = Tween<Offset>(
                    begin: const Offset(0.08, 0.0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(position: offsetAnim, child: child),
                  );
                },
                child: SizedBox(
                  key: ValueKey<int>(currentIndex),
                  width: double.infinity,
                  height: double.infinity,
                  child: currentPage,
                ),
              ),
            ),

          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        final idx = controller.currentIndex.value;
        return SafeArea(
          bottom: true,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 760),
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F0F0), // Soft purple
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 12, offset: const Offset(0, 6)),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(controller.pages.length, (i) {
                final item = _navItems[i];
                final selected = i == idx;
                return Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => controller.changePage(i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 260),
                        curve: Curves.easeOut,
                        padding: selected ? const EdgeInsets.symmetric(vertical: 5, horizontal: 8) : const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: selected ? item.background.withOpacity(0.30) : Colors.transparent,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: selected ? item.background : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(item.icon, size: 20, color: selected ? Colors.white : Colors.grey[700]),
                            ),
                            const SizedBox(width: 6),
                            AnimatedSize(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              child: selected
                                  ? Text(item.label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12))
                                  : const SizedBox.shrink(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );
      }),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final Color background;
  const _NavItem({required this.icon, required this.label, required this.background});
}

const List<_NavItem> _navItems = [
  _NavItem(icon: Icons.home_outlined, label: 'Home', background: Color(0xFF4CAF50)), // Deep green
  _NavItem(icon: Icons.message_outlined, label: 'Chat', background: Color(0xFF42A5F5)), // Vibrant blue
  _NavItem(icon: Icons.video_call_outlined, label: 'Rooms', background: Color(
      0xFFEFBE1E)), // Bright yellow
  _NavItem(icon: Icons.person_outline, label: 'Profile', background: Color(0xFFD81B60)), // Vibrant pink
];