class ChatRoomModel {
  final String id;
  final String? name;
  final bool isGroup;
  final List<String> members;
  final String? lastMessage;
  final DateTime? lastMessageAt;
  final DateTime? createdAt;

  ChatRoomModel({
    required this.id,
    this.name,
    this.isGroup = false,
    this.members = const [],
    this.lastMessage,
    this.lastMessageAt,
    this.createdAt,
  });

  factory ChatRoomModel.fromMap(Map<String, dynamic> map) {
    return ChatRoomModel(
      id: map['id'] ?? '',
      name: map['name'],
      isGroup: map['is_group'] ?? false,
      members: List<String>.from(map['members'] ?? []),
      lastMessage: map['last_message'],
      lastMessageAt: map['last_message_at'] != null
          ? DateTime.tryParse(map['last_message_at'])
          : null,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'is_group': isGroup,
      'members': members,
      'last_message': lastMessage,
      'last_message_at': lastMessageAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ChatRoomModel copyWith({
    String? id,
    String? name,
    bool? isGroup,
    List<String>? members,
    String? lastMessage,
    DateTime? lastMessageAt,
    DateTime? createdAt,
  }) {
    return ChatRoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isGroup: isGroup ?? this.isGroup,
      members: members ?? this.members,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
