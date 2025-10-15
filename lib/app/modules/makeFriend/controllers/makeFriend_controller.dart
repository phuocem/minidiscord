import 'package:get/get.dart';
import 'package:minidiscord/app/data/models/ChatModel.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../data/models/ProfileModel.dart';
import '../../../data/models/FriendRequestModel.dart';

/// ViewModel để gom cả FriendRequest + thông tin user gửi
class FriendRequestViewModel {
  final FriendRequestModel request;
  final ProfileModel senderProfile;

  FriendRequestViewModel({
    required this.request,
    required this.senderProfile,
  });
}

class SentRequestViewModel {
  final FriendRequestModel request;
  final ProfileModel receiverProfile;

  SentRequestViewModel({required this.request, required this.receiverProfile});
}

class MakeFriendController extends GetxController {
  final SupabaseClient supabase = Supabase.instance.client;

  var isLoading = false.obs;

  var searchResults = <ProfileModel>[].obs;
  var friendRequests = <FriendRequestViewModel>[].obs;
  var friends = <ProfileModel>[].obs;
  var sentRequests = <SentRequestViewModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFriendRequests();
    loadSentRequests();
    loadFriends();
  }

  /// Helper: kiểm tra 2 user đã là bạn chưa
  Future<bool> _areFriends(String userId, String otherId) async {
    try {
      final resp = await supabase
          .from('friends')
          .select('id')
          .eq('user_id', userId)
          .eq('friend_id', otherId)
          .limit(1);
      return (resp is List && resp.isNotEmpty);
    } catch (e) {
      print('check friends error: $e');
      return false;
    }
  }

  /// Helper: kiểm tra có lời mời đang chờ giữa 2 user không (bất kỳ chiều)
  Future<bool> _hasPendingRequestBetween(String aId, String bId) async {
    try {
      final resp1 = await supabase
          .from('friend_requests')
          .select('id')
          .eq('sender_id', aId)
          .eq('receiver_id', bId)
          .eq('status', 'pending')
          .limit(1);

      if (resp1 is List && resp1.isNotEmpty) return true;

      final resp2 = await supabase
          .from('friend_requests')
          .select('id')
          .eq('sender_id', bId)
          .eq('receiver_id', aId)
          .eq('status', 'pending')
          .limit(1);

      return (resp2 is List && resp2.isNotEmpty);
    } catch (e) {
      print('check pending request error: $e');
      return false;
    }
  }

  /// 🔍 Tìm kiếm user theo username
  Future<void> searchUsers(String query) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }

    try {
      final response = await supabase
          .from('profiles')
          .select()
          .ilike('username', '%$query%')
          .neq('id', user.id);

      searchResults.value =
          (response as List).map((u) => ProfileModel.fromMap(u)).toList();
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể tìm kiếm user");
    }
  }

  /// ➕ Gửi lời mời kết bạn (đã thêm kiểm tra)
  Future<void> sendFriendRequest(String receiverId) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    // Không cho gửi trùng
    final check = await supabase
        .from("friend_requests")
        .select()
        .eq("sender_id", user.id)
        .eq("receiver_id", receiverId)
        .eq("status", "pending");
    if (check.isNotEmpty) {
      Get.snackbar("Thông báo", "Đã gửi lời mời rồi!");
      return;
    }
  }
    /// 📋 Lấy danh sách lời mời kết bạn mình nhận được
  Future<void> loadFriendRequests() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    isLoading.value = true;
    try {
      final response = await supabase
          .from('friend_requests')
          .select(
        'id, sender_id, status, profiles!friend_requests_sender_id_fkey(id, username, avatar_url, email)',
      )
          .eq('receiver_id', user.id)
          .eq('status', 'pending');

      friendRequests.value = (response as List).map((e) {
        final req = FriendRequestModel(
          id: e['id'].toString(),
          senderId: e['sender_id'].toString(),
          receiverId: user.id,
          status: e['status'] ?? 'pending',
        );

        final sender = ProfileModel.fromMap(e['profiles']);

        return FriendRequestViewModel(
          request: req,
          senderProfile: sender,
        );
      }).toList();
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể tải danh sách lời mời");
      print(e);
    }
    isLoading.value = false;
  }

  /// ✅ Đồng ý kết bạn (tránh chèn trùng)
  Future<void> acceptFriendRequest(String requestId, String senderId) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      // Update trạng thái
      await supabase.from("friend_requests").update({
        'status': 'accepted',
      }).eq('id', requestId);

      // Thêm vào bảng friends (2 chiều) nhưng kiểm tra trùng trước
      final already1 = await _areFriends(user.id, senderId);
      final already2 = await _areFriends(senderId, user.id);

      final inserts = <Map<String, dynamic>>[];
      if (!already1) inserts.add({'user_id': user.id, 'friend_id': senderId});
      if (!already2) inserts.add({'user_id': senderId, 'friend_id': user.id});

      if (inserts.isNotEmpty) {
        await supabase.from("friends").insert(inserts);
      }

      Get.snackbar("Thành công", "Đã chấp nhận lời mời kết bạn");
      await loadFriendRequests();
      await loadFriends();
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể chấp nhận lời mời");
      print(e);
    }
  }

  /// ❌ Từ chối lời mời kết bạn
  Future<void> rejectFriendRequest(String requestId) async {
    try {
      await supabase.from("friend_requests").update({
        'status': 'rejected',
      }).eq('id', requestId);

      Get.snackbar("Thành công", "Đã từ chối lời mời");
      await loadFriendRequests();
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể từ chối lời mời");
      print(e);
    }
  }

  /// 📋 Lấy danh sách bạn bè
  Future<void> loadFriends() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    isLoading.value = true;
    try {
      final response = await supabase
          .from('friends')
          .select(
        'friend_id, profiles!friends_friend_id_fkey(id, username, avatar_url, email)',
      )
          .eq('user_id', user.id);

      friends.value = (response as List)
          .map((f) => ProfileModel.fromMap(f['profiles']))
          .toList();
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể tải danh sách bạn bè");
      print(e);
    }
    isLoading.value = false;
  }

  /// 📋 Lấy danh sách lời mời kết bạn đã gửi
  Future<void> loadSentRequests() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    isLoading.value = true;
    try {
      final response = await supabase
          .from('friend_requests')
          .select(
          'id, receiver_id, status, profiles!friend_requests_receiver_id_fkey(id, username, avatar_url, email)')
          .eq('sender_id', user.id)
          .eq('status', 'pending');

      sentRequests.value = (response as List).map((e) {
        final req = FriendRequestModel(
          id: e['id'].toString(),
          senderId: user.id,
          receiverId: e['receiver_id'].toString(),
          status: e['status'] ?? 'pending',
        );
        final receiver = ProfileModel.fromMap(e['profiles']);
        return SentRequestViewModel(request: req, receiverProfile: receiver);
      }).toList();
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể tải lời mời đã gửi");
      print(e);
    }
    isLoading.value = false;
  }

  /// ❌ Hủy lời mời đã gửi
  Future<void> cancelFriendRequest(String requestId) async {
    try {
      await supabase.from('friend_requests').delete().eq('id', requestId);
      Get.snackbar("Thành công", "Đã hủy lời mời kết bạn");
      await loadSentRequests();
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể hủy lời mời");
      print(e);
    }
  }
  /// Kiểm tra trạng thái giữa currentUser và user khác
  Future<String> getRelationStatus(String otherUserId) async {
    final user = supabase.auth.currentUser;
    if (user == null) return "none";

    // Đã là bạn chưa
    if (await _areFriends(user.id, otherUserId)) {
      return "friend";
    }

    // Có lời mời pending giữa 2 người không
    if (await _hasPendingRequestBetween(user.id, otherUserId)) {
      // Check chiều
      final sent = await supabase
          .from("friend_requests")
          .select('id')
          .eq("sender_id", user.id)
          .eq("receiver_id", otherUserId)
          .eq("status", "pending")
          .maybeSingle();

      if (sent != null) return "sent"; // mình gửi
      return "received"; // họ gửi cho mình
    }

    return "none"; // chưa có gì
  }

  /// Sửa hàm Naviga: ChatModel không nên so sánh với bool
  void Naviga(ChatModel chat) {
    // ví dụ: nếu bạn muốn kiểm tra chat.id tồn tại thì:
    if (chat.id != null && chat.id!.isNotEmpty) {
      Get.offAllNamed('/detail-chat', arguments: chat);
    } else {
      Get.snackbar("Lỗi", "Chat không hợp lệ");
    }
  }
}
