
class chatsModel{
  final String id  ;
  final String name;
  final bool isGroup;
  final DateTime createdAt;
  chatsModel(
  {
    required this.id,
    required this.name,
    required this.isGroup,
    required this.createdAt,
  });

  factory chatsModel.fromMap(Map<String, dynamic> map) {
    return chatsModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      isGroup: map['is_group'] ?? false,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'is_group': isGroup,
      'created_at': createdAt.toIso8601String(),
    };
  }
  chatsModel copyWith({
    String? id,
    String? name,
    bool? isGroup,
    DateTime? createdAt,
  }) {
    return chatsModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isGroup: isGroup ?? this.isGroup,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
