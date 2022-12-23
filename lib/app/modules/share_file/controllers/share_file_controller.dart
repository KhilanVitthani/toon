import 'dart:io';
import 'dart:typed_data';

import 'package:ai_image_enlarger/constants/api_constants.dart';
import 'package:get/get.dart';

class ShareFileController extends GetxController {
  File? capturedImage;
  RxBool isFromMyCollection = false.obs;
  @override
  void onInit() {
    if (Get.arguments != null) {
      capturedImage = Get.arguments[ArgumentConstant.capuredImage];
      isFromMyCollection.value =
          Get.arguments[ArgumentConstant.isFromMyCollection];
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
