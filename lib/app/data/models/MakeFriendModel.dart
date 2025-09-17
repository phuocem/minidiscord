import 'package:supabase_flutter/supabase_flutter.dart';

class MakeFriendModel {
  final String id;
  final String? email;
  final String? username;
  final String? avatarUrl;
  final String status; // none | requested | pending | friend
  final DateTime? createdAt;

  MakeFriendModel({
    required this.id,
    this.email,
    this.username,
    this.avatarUrl,
    this.status = 'none',
    this.createdAt,
  });

  factory MakeFriendModel.fromMap(Map<String, dynamic> map) {
    return MakeFriendModel(
      id: map['id'] ?? '',
      email: map['email'],
      username: map['username'],
      avatarUrl: map['avatar_url'],
      status: map['status'] ?? 'none',
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
    );
  }

  factory MakeFriendModel.fromAuthUser(User user) {
    return MakeFriendModel(
      id: user.id,
      email: user.email,
      username: user.userMetadata?['name'],
      avatarUrl: user.userMetadata?['avatar_url'],
      createdAt: user.createdAt is String
          ? DateTime.tryParse(user.createdAt)
          : (user.createdAt as DateTime?),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatar_url': avatarUrl,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  MakeFriendModel copyWith({
    String? id,
    String? email,
    String? username,
    String? avatarUrl,
    String? status,
    DateTime? createdAt,
  }) {
    return MakeFriendModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
