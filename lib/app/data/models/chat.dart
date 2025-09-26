class ChatModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String message;
  final String type;
  final String status;
  final DateTime? createdAt;

  ChatModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.message,
    this.type = 'text',
    this.status = 'sent',
    this.createdAt,
  });

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] ?? '',
      senderId: map['sender_id'] ?? '',
      receiverId: map['receiver_id'] ?? '',
      message: map['message'] ?? '',
      type: map['type'] ?? 'text',
      status: map['status'] ?? 'sent',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'message': message,
      'type': type,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ChatModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? message,
    String? type,
    String? status,
    DateTime? createdAt,
  }) {
    return ChatModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      type: type ?? this.type,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
