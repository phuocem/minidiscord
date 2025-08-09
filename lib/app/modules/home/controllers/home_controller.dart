import 'package:get/get.dart';

import '../../../data/models/chat_model.dart';


class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }


  final chats = <Chat>[
    Chat(
      name: 'Trần Phước Anh',
      avatar: '',
      lastMessage: 'Ok cảm ơn!',
      status: 'offline',
      time: '08:45',
      unread: 1,
    ),
    Chat(
      name: 'Trần Phước Anh',
      avatar: '',
      lastMessage: 'Ok cảm ơn!',
      status: 'offline',
      time: '08:45',
      unread: 0,
    ),
    Chat(
      name: 'Trần Phước Anh',
      avatar: '',
      lastMessage: 'Ok cảm ơn!',
      status: 'offline',
      time: '08:45',
      unread: 0,
    ),
    Chat(
      name: 'Trần Phước Anh',
      avatar: '',
      lastMessage: 'Ok cảm ơn!',
      status: 'offline',
      time: '08:45',
      unread: 0,
    ),    Chat(
      name: 'Trần Phước Anh',
      avatar: '',
      lastMessage: 'Ok cảm ơn!',
      status: 'online',
      time: '08:45',
      unread: 7,
    ),
  ].obs;
}
