import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
 final SupabaseClient supabase = Supabase.instance.client;

 var chatRooms = <Map<String, dynamic>>[].obs; // danh sách phòng chat
 var isLoading = false.obs;

 @override
 void onInit() {
  super.onInit();
  fetchChatRooms();
  listenToChatRooms(); // ✅ Thêm realtime theo dõi phòng mới
 }

 /// 📥 Lấy danh sách phòng chat của user hiện tại
 Future<void> fetchChatRooms() async {
  try {
   isLoading.value = true;
   final userId = supabase.auth.currentUser!.id;

   final response = await supabase
       .from('chat_rooms')
       .select('*')
       .contains('members', [userId])
       .order('created_at', ascending: false);

   chatRooms.value = List<Map<String, dynamic>>.from(response);
  } catch (e) {
   Get.snackbar('Error', e.toString());
  } finally {
   isLoading.value = false;
  }
 }

 /// 📡 Realtime — nếu có phòng chat mới mà mình nằm trong `members`
 void listenToChatRooms() {
  final userId = supabase.auth.currentUser?.id;
  if (userId == null) return;

  final channel = supabase.channel('public:chat_rooms');

  // ✅ Lắng nghe INSERT từ bảng chat_rooms
  channel.onPostgresChanges(
   event: PostgresChangeEvent.insert, // Tương đương RealtimeListenTypes.insert
   schema: 'public',
   table: 'chat_rooms',
   callback: (payload) {
    final newRoom = payload.newRecord; // ✅ payload.newRecord thay vì payload['new']

    // ✅ Nếu user hiện tại thuộc members của phòng mới → thêm vào danh sách
    if (newRoom['members'] != null && (newRoom['members'] as List).contains(userId)) {
     chatRooms.insert(0, Map<String, dynamic>.from(newRoom));
    }
   },
  );

  channel.subscribe();
 }

}
