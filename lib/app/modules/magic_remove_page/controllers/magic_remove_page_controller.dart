import 'dart:io';

import 'package:ai_image_enlarger/constants/api_constants.dart';
import 'package:ai_image_enlarger/constants/sizeConstant.dart';
import 'package:get/get.dart';

class MagicRemovePageController extends GetxController {
  File? image;
  @override
  void onInit() {
    if (Get.arguments != null) {
      if (!isNullEmptyOrFalse(Get.arguments[ArgumentConstant.imageFile])) {
        image = Get.arguments[ArgumentConstant.imageFile];
      }
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
