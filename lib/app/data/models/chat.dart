class ChatModlel {
  final String id;
  final String senderId;
  final double underChat;
  final List<String> messenger;
  final DateTime createdAt;

  ChatModlel({
    required this.id,
    required this.senderId,
        required this.underChat,
    required this.messenger,
    required this.createdAt,
  });
  factory ChatModlel.fromMap(Map<String, dynamic> map) {
    return ChatModlel(
      id: map['id'] as String,
      senderId: map['sender_id'] as String,
          underChat: map['under_chat'] as double,
      messenger: List<String>.from(map['messenger'] as List<dynamic>),
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_id': senderId,
          'under_chat': underChat,
      'messenger': messenger,
      'created_at': createdAt.toIso8601String(),
    };
  }
  ChatModlel copyWith({
    String? id,
    String? senderId,
        double? underChat,
    List<String>? messenger,
    DateTime? createdAt,
  }) {
    return ChatModlel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
          underChat: underChat ?? this.underChat,
      messenger: messenger ?? this.messenger,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}