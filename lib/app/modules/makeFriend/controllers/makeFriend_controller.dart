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

  /// Danh sách user tìm thấy
  var searchResults = <ProfileModel>[].obs;

  /// Danh sách lời mời kết bạn nhận được
  var friendRequests = <FriendRequestViewModel>[].obs;

  /// Danh sách bạn bè
  var friends = <ProfileModel>[].obs;

  /// Danh sách lời mời kết bạn đã gửi
  var sentRequests = <SentRequestViewModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFriendRequests();
    loadSentRequests();
    loadFriends();
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

  /// ➕ Gửi lời mời kết bạn
  Future<void> sendFriendRequest(String receiverId) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      await supabase.from("friend_requests").insert({
        'sender_id': user.id,
        'receiver_id': receiverId,
      });

      Get.snackbar("Thành công", "Đã gửi lời mời kết bạn");
      loadSentRequests();
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể gửi lời mời kết bạn");
      print(e);
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

  /// ✅ Đồng ý kết bạn
  Future<void> acceptFriendRequest(String requestId, String senderId) async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      // Update trạng thái
      await supabase.from("friend_requests").update({
        'status': 'accepted',
      }).eq('id', requestId);

      // Thêm vào bảng friends (2 chiều)
      await supabase.from("friends").insert([
        {'user_id': user.id, 'friend_id': senderId},
        {'user_id': senderId, 'friend_id': user.id},
      ]);

      Get.snackbar("Thành công", "Đã chấp nhận lời mời kết bạn");
      loadFriendRequests();
      loadFriends();
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
      loadFriendRequests();
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
      loadSentRequests();
    } catch (e) {
      Get.snackbar("Lỗi", "Không thể hủy lời mời");
      print(e);
    }
  }

void Naviga( ChatModel id)
{
  if(id == true ){
  Get.offAllNamed('/detail-chat');}
  else
    Get.snackbar("sai", "sai");
}  
}
