import 'package:get/get.dart';
import 'package:minidiscord/app/modules/Profile/controllers/setting_controller.dart';
import 'package:minidiscord/app/modules/Profile/views/setting_view.dart';
import 'package:minidiscord/app/modules/Room/controllers/room_controller.dart';
import 'package:minidiscord/app/modules/Room/views/room_view.dart';
import 'package:minidiscord/app/modules/chat/controllers/chat_controller.dart';
import 'package:minidiscord/app/modules/chat/views/chat_view.dart';
import 'package:minidiscord/app/modules/home/controllers/home_controller.dart';
import 'package:minidiscord/app/modules/home/views/home_view.dart';

import '../controllers/layout_controller.dart';

class LayoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LayoutController>(
          () => LayoutController(pages: [
        HomeView(),
        ChatView(),
        RoomView(),
        SettingView(),
      ]),
    );
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<ChatController>(() => ChatController());
    Get.lazyPut<RoomController>(() => RoomController());
    Get.lazyPut<SettingController>(() => SettingController());
  }
}