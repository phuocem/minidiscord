import 'package:get/get.dart';

import '../modules/Profile/bindings/setting_binding.dart';
import '../modules/Profile/views/setting_view.dart';
import '../modules/Room/bindings/room_binding.dart';
import '../modules/Room/views/room_view.dart';
import '../modules/chat/bindings/chat_binding.dart';
import '../modules/chat/views/chat_view.dart';
import '../modules/detail_chat/bindings/detail_chat_binding.dart';
import '../modules/detail_chat/views/detail_chat_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/layout/bindings/layout_binding.dart';
import '../modules/layout/views/layout_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.HOME,
          page: () => HomeView(),
          binding: HomeBinding(),
        ),
      ],
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.LAYOUT,
      page: () => const LayoutView(),
      binding: LayoutBinding(),
    ),
    GetPage(
      name: _Paths.CHAT,
      page: () => const ChatView(),
      binding: ChatBinding(),
    ),
    GetPage(
      name: _Paths.ROOM,
      page: () => const RoomView(),
      binding: RoomBinding(),
    ),
    GetPage(
      name: _Paths.Setting,
      page: () =>  SettingView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_CHAT,
      page: () => const DetailChatView(),
      binding: DetailChatBinding(),
    ),
  ];
}
