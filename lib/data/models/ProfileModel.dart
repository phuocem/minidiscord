class ProfileModel {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;

  ProfileModel({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      avatarUrl: map['avatar_url'] as String?,
    );
  }
}

