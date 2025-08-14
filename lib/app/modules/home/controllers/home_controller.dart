import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/models/chat_model.dart';

class HomeController extends GetxController {
  final supabase = Supabase.instance.client;

  /// Danh sách các cuộc hội thoại
  final chats = <chatsModel>[].obs;

  /// ID của user hiện tại (nếu đã đăng nhập)
  String? currentUserId;

  @override
  void onInit() {
    super.onInit();

    final user = supabase.auth.currentUser;
    if (user == null) {
      print("⚠️ User chưa đăng nhập, không thể load chats.");
      return;
    }

    currentUserId = user.id;

    loadChats();
    subscribeNewMessages();
  }

  /// Lấy danh sách hội thoại mới nhất của user
  Future<void> loadChats() async {
    if (currentUserId == null) return;

    try {
      final response = await supabase
          .from('messages')
          .select('*, sender:sender_id(id, username, avatar_url), receiver:receiver_id(id, username, avatar_url)')
          .or('sender_id.eq.$currentUserId,receiver_id.eq.$currentUserId')
          .order('created_at', ascending: false);

      final Map<String, chatsModel> chatMap = {};

      for (var msg in response) {
        final bool isSender = msg['sender_id'] == currentUserId;
        final userData = isSender ? msg['receiver'] : msg['sender'];
        final otherUserId = userData['id'];

        // Chỉ lưu cuộc trò chuyện mới nhất với mỗi user
        chatMap.putIfAbsent(
          otherUserId,
              () => chatsModel(
            id: otherUserId,
            name: userData['username'] ?? 'Unknown',
            isGroup: false,
            createdAt: DateTime.parse(msg['created_at']),
          ),
        );
      }

      chats.assignAll(chatMap.values.toList());
    } catch (e) {
      print("❌ Lỗi khi load chats: $e");
    }
  }

  /// Lắng nghe tin nhắn mới qua Supabase Realtime
  void subscribeNewMessages() {
    if (currentUserId == null) return;

    supabase
        .channel('public:messages')
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'messages',
      callback: (_) => loadChats(),
    )
        .subscribe();
  }
}
