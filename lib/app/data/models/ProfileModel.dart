class ProfileModel {
  final String id;       // UUID user (trùng với auth.users.id)
  final String? email;   // Email user
  final String? username; // Tên hiển thị (ở bảng là "username", không phải "display_name")
  final String? avatarUrl; // Link ảnh đại diện
  final DateTime? createdAt;

  ProfileModel({
    required this.id,
    this.email,
    this.username,
    this.avatarUrl,
    this.createdAt,
  });

  // Tạo từ bản ghi Supabase (map từ bảng profiles)
  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] ?? '',
      email: map['email'],
      username: map['username'],          // Trùng tên cột DB
      avatarUrl: map['avatar_url'],
      createdAt:
      map['created_at'] != null ? DateTime.parse(map['created_at']) : null,
    );
  }

  // Tạo từ Supabase Auth User (đối tượng user trả về supabase.auth.currentUser)
  factory ProfileModel.fromAuthUser(dynamic user) {
    return ProfileModel(
      id: user.id,
      email: user.email,
      // createdAt ở user dạng String ISO8601 hoặc DateTime?
      createdAt: user.createdAt is String
          ? DateTime.tryParse(user.createdAt)
          : (user.createdAt as DateTime?),
    );
  }

  // Chuyển sang map để gửi lên Supabase (thường dùng khi insert/update)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
