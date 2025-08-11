class Chat {
  final String name;
  final String avatar;
  final String lastMessage;
  final String status;
  final String time;
  final int unread;

  Chat({
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.status,
    required this.time,
    required this.unread,
  });

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      name: map['name'] ?? '',
      avatar: map['avatar'] ?? '',
      lastMessage: map['last_message'] ?? '',
      status: map['status'] ?? 'offline',
      time: map['time'] ?? '',
      unread: map['unread'] ?? 0,
    );
  }
}
