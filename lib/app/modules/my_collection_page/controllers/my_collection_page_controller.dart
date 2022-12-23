import 'dart:convert';

import 'package:ai_image_enlarger/constants/api_constants.dart';
import 'package:ai_image_enlarger/constants/sizeConstant.dart';
import 'package:get/get.dart';

import '../../../../main.dart';

class MyCollectionPageController extends GetxController {
  RxList myImage = RxList([]);
  @override
  void onInit() {
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.myCollection))) {
      myImage.value = jsonDecode(box.read(ArgumentConstant.myCollection));
      print(myImage);
    }
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
