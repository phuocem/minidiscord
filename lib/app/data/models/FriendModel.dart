class FriendModel {
  final String id;
  final String userId;
  final String friendId;
  final DateTime? createdAt;

  FriendModel({
    required this.id,
    required this.userId,
    required this.friendId,
    this.createdAt,
  });

  factory FriendModel.fromMap(Map<String, dynamic> map) {
    return FriendModel(
      id: map['id'] ?? '',
      userId: map['user_id'] ?? '',
      friendId: map['friend_id'] ?? '',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'friend_id': friendId,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  FriendModel copyWith({
    String? id,
    String? userId,
    String? friendId,
    DateTime? createdAt,
  }) {
    return FriendModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      friendId: friendId ?? this.friendId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
