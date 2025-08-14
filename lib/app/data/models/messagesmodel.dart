import 'package:supabase_flutter/supabase_flutter.dart';

class MessageModel {
  final int id;
  final int chatId;
  final String userId;
  final String content;
  final DateTime? createdAt;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.userId,
    required this.content,
    this.createdAt,
  });

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: map['id'] ?? 0,
      chatId: map['chat_id'] ?? 0,
      userId: map['user_id'] ?? '',
      content: map['content'] ?? '',
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chat_id': chatId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  MessageModel copyWith({
    int? id,
    int? chatId,
    String? userId,
    String? content,
    DateTime? createdAt,
  }) {
    return MessageModel(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}