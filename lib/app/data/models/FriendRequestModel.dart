class FriendRequestModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String status; // pending | accepted | rejected
  final DateTime? createdAt;

  FriendRequestModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    this.status = 'pending',
    this.createdAt,
  });

  factory FriendRequestModel.fromMap(Map<String, dynamic> map) {
    return FriendRequestModel(
      id: map['id'] ?? '',
      senderId: map['sender_id'] ?? '',
      receiverId: map['receiver_id'] ?? '',
      status: map['status'] ?? 'pending',
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
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  FriendRequestModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? status,
    DateTime? createdAt,
  }) {
    return FriendRequestModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
