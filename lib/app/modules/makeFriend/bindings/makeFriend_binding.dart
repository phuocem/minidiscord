import 'package:get/get.dart';

import '../controllers/makeFriend_controller.dart';

class makeFriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MakeFriendController>(
      () => MakeFriendController(),
    );
  }
}
