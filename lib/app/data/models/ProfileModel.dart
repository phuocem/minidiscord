import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileModel {
  final String id;
  final String? email;
  final String? username;
  final String? avatarUrl;
  final DateTime? createdAt;

  ProfileModel({
    required this.id,
    this.email,
    this.username,
    this.avatarUrl,
    this.createdAt,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] ?? '',
      email: map['email'],
      username: map['username'],
      avatarUrl: map['avatar_url'],
      createdAt: map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  factory ProfileModel.fromAuthUser(User user) {
    return ProfileModel(
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
      'created_at': createdAt?.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? id,
    String? email,
    String? username,
    String? avatarUrl,
    DateTime? createdAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}