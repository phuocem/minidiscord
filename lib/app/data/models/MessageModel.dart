import 'package:supabase_flutter/supabase_flutter.dart';

class MessageModel {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String content;
  final DateTime createdAt;

  bool get isMine => senderId == Supabase.instance.client.auth.currentUser!.id;

  MessageModel({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'].toString(),
      chatRoomId: map['chat_room_id'].toString(),
      senderId: map['sender_id'].toString(),
      content: map['content'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
