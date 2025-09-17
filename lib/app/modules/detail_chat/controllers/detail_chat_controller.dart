import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailChatController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  // Thông tin bạn bè
  late final String friendId;
  late final String friendName;
  late final String friendEmail;

  // User hiện tại
  late final String currentUserId;

  // Chat ID hiện tại
  String? chatId;

  // Danh sách tin nhắn
  var messages = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  // Text controller cho input
  final TextEditingController messageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initializeChat();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  /// Khởi tạo chat
  Future<void> _initializeChat() async {
    try {
      isLoading.value = true;

      // Lấy arguments
      final args = Get.arguments ?? {};
      friendId = args['friendId'] ?? '';
      friendName = args['friendName'] ?? '';
      friendEmail = args['friendEmail'] ?? '';

      // Lấy current user
      currentUserId = supabase.auth.currentUser?.id ?? "";

      if (currentUserId.isEmpty || friendId.isEmpty) {
        Get.snackbar("Lỗi", "Thông tin người dùng không hợp lệ");
        return;
      }

      // Tạo hoặc lấy chat ID
      chatId = await _getOrCreateChat();

      if (chatId != null) {
        // Load tin nhắn
        await _fetchMessages();
        // Lắng nghe tin nhắn mới
        _listenToMessages();
      }
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể khởi tạo chat: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Tạo hoặc lấy chat ID giữa 2 người
  Future<String?> _getOrCreateChat() async {
    try {
      // Tạo một chat_id duy nhất dựa trên 2 user IDs (sắp xếp để đảm bảo tính nhất quán)
      final userIds = [currentUserId, friendId]..sort();
      final chatRoomId = '${userIds[0]}_${userIds[1]}';

      print("🔍 Checking chat room: $chatRoomId");

      // Đơn giản hóa: không cần kiểm tra tin nhắn đã tồn tại
      // Chat room sẽ được tạo tự động khi gửi tin nhắn đầu tiên
      print("✅ Chat room ID created: $chatRoomId");
      return chatRoomId;
    } catch (e) {
      print("❌ Lỗi tạo/lấy chat: $e");
      return null;
    }
  }

  /// Load tin nhắn từ database
  Future<void> _fetchMessages() async {
    if (chatId == null) return;

    try {
      print("📥 Fetching messages for chat: $chatId");

      // Đơn giản hóa query để tránh RLS policy conflicts
      final response = await supabase
          .from('messages')
          .select('id, chat_id, user_id, content, created_at')
          .eq('chat_id', chatId!)
          .order('created_at', ascending: true);

      final messagesList = List<Map<String, dynamic>>.from(response);
      messages.assignAll(messagesList);

      print("✅ Loaded ${messagesList.length} messages");
      if (messagesList.isNotEmpty) {
        print("📋 Sample message structure: ${messagesList.first.keys.toList()}");
      }
    } catch (e) {
      print("❌ Lỗi load tin nhắn: $e");
      // Không hiển thị snackbar để tránh spam user
    }
  }

  /// Gửi tin nhắn
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || chatId == null) return;

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

    try {
      print("📤 Sending message to chat: $chatId");

      // Thêm tin nhắn tạm thời vào UI ngay lập tức
      final tempMessage = {
        'id': tempId,
        'chat_id': chatId,
        'user_id': currentUserId,
        'content': text.trim(),
        'created_at': DateTime.now().toIso8601String(),
      };
      messages.add(tempMessage);

      // Gửi tin nhắn lên server với cấu trúc đơn giản
      final response = await supabase
          .from('messages')
          .insert({
            'chat_id': chatId,
            'user_id': currentUserId,
            'content': text.trim(),
            'created_at': DateTime.now().toIso8601String(),
          })
          .select('id, chat_id, user_id, content, created_at')
          .single();

      // Thay thế tin nhắn tạm thời bằng tin nhắn thực từ server
      final index = messages.indexWhere((msg) => msg['id'] == tempId);
      if (index != -1) {
        messages[index] = response;
      }

      print("✅ Message sent successfully: ${response['content']}");
    } catch (e) {
      // Xóa tin nhắn tạm thời nếu gửi thất bại
      messages.removeWhere((msg) => msg['id'] == tempId);
      print("❌ Lỗi gửi tin nhắn: $e");
      Get.snackbar("Lỗi", "Không gửi được tin nhắn: ${e.toString().contains('policy') ? 'Lỗi cấu hình database' : 'Lỗi kết nối'}");
    }
  }

  /// Lắng nghe tin nhắn realtime
  void _listenToMessages() {
    if (chatId == null) return;

    print("🔴 Bắt đầu lắng nghe realtime cho chat: $chatId");

    try {
      supabase
          .channel('messages-$chatId')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'messages',
            filter: PostgresChangeFilter(
              type: PostgresChangeFilterType.eq,
              column: 'chat_id',
              value: chatId,
            ),
            callback: (payload) {
              final newMessage = payload.newRecord;
              print("🟢 Nhận tin nhắn realtime: ${newMessage['content']}");

              // Chỉ thêm tin nhắn nếu không phải từ chính mình (để tránh duplicate)
              // và chưa có trong danh sách
              if (newMessage['user_id'] != currentUserId) {
                final exists = messages.any((msg) => msg['id'] == newMessage['id']);
                if (!exists) {
                  messages.add(newMessage);
                  print("✅ Đã thêm tin nhắn mới vào danh sách");
                }
              }
            },
          )
          .subscribe();
    } catch (e) {
      print("❌ Lỗi thiết lập realtime: $e");
    }
  }

  /// Refresh tin nhắn
  Future<void> refreshMessages() async {
    await _fetchMessages();
  }
}
