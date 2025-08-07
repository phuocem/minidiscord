import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LayoutController extends GetxController {
  LayoutController({required this.pages});
  final List<Widget> pages;
  final RxInt currentIndex = 0.obs;

  void changePage(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}