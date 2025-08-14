
class ChatUserModel
{
  final String id;
  final String userid;
  final DateTime joinedAt;
  ChatUserModel({
    required this.id,
    required this.userid,
    required this.joinedAt,
  });
  factory ChatUserModel.fromMap(Map<String, dynamic> map) {
    return ChatUserModel(
      id: map['id'] ?? '',
      userid: map['user_id'] ?? '',
      joinedAt: DateTime.parse(map['joined_at']),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userid,
      'joined_at': joinedAt.toIso8601String(),
    };
  }

  ChatUserModel copyWith({
    String? id,
    String? userid,
    DateTime? joinedAt,
  }) {
    return ChatUserModel(
      id: id ?? this.id,
      userid: userid ?? this.userid,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }

}