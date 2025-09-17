class MakeFriendModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String status;
  final DateTime createdAt;

  MakeFriendModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
    required this.createdAt,
  });

  factory MakeFriendModel.fromMap(Map<String, dynamic> map) {
    return MakeFriendModel(
      id: map['id'] as String,
      senderId: map['sender_id'] as String,
      receiverId: map['receiver_id'] as String,
      status: map['status'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

