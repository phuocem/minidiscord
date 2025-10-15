import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/MessageModel.dart';

class DetailChatController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  late final String chatRoomId;
  late final String friendName;
  late final String currentUserId;

  var messages = <MessageModel>[].obs;
  final TextEditingController messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    chatRoomId = (Get.arguments['chatRoomId'] ?? '') as String;
    friendName = (Get.arguments['friendName'] ?? 'Unknown') as String;
    currentUserId = supabase.auth.currentUser?.id ?? '';


    _loadMessages();
    _listenToMessages();
  }

  /// 📌 Load tin nhắn ban đầu
  Future<void> _loadMessages() async {
    try {
      final response = await supabase
          .from('messages')
          .select('*')
          .eq('chat_room_id', chatRoomId)
          .order('created_at', ascending: true);

      messages.value = (response as List)
          .map((json) => MessageModel.fromMap(json))
          .toList();

      _scrollToBottom();
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể tải tin nhắn");
    }
  }

  /// 📡 Lắng nghe realtime tin nhắn mới
  void _listenToMessages() {
    supabase
        .channel('messages_channel')
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      callback: (payload) {
        final data = payload.newRecord;
        if (data['chat_room_id'] == chatRoomId) {
          messages.add(MessageModel.fromMap(data));
          _scrollToBottom();
        }
      },
    )
        .subscribe();
  }


  /// ✉ Gửi tin nhắn
  Future<void> sendMessage() async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;

    messageController.clear();

    await supabase.from('messages').insert({
      'chat_room_id': chatRoomId,
      'sender_id': currentUserId,
      'content': text,
    });

    _scrollToBottom();
  }

  /// ✅ Auto scroll xuống cuối
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }
}
