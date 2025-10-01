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
 }

 Future<void> fetchChatRooms() async {
  try {
   isLoading.value = true;
   final userId = supabase.auth.currentUser!.id;

   final response = await supabase
       .from('chat_rooms')
       .select('*')
       .contains('members', [userId]) // kiểm tra user trong members[]
       .order('created_at', ascending: false);

   chatRooms.value = List<Map<String, dynamic>>.from(response);
  } catch (e) {
   Get.snackbar('Error', e.toString());
  } finally {
   isLoading.value = false;
  }
 }
}
