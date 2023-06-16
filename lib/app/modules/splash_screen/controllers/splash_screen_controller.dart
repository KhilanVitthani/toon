import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:toon_photo_editor/constants/api_constants.dart';

import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
import '../../../../utilities/timer_service.dart';
import '../../../routes/app_pages.dart';

class SplashScreenController extends GetxController {
  RxBool isFirstTime = true.obs;

  @override
  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    if (box.read(ArgumentConstant.isFirstTime) != null) {
      isFirstTime.value = box.read(ArgumentConstant.isFirstTime);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Timer(Duration(seconds: 3), () {
        if (isFirstTime.value) {
          Get.offAllNamed(Routes.MAIN_SCREEN);
          getIt<TimerService>().verifyTimer();
        } else {
          loadAdd();
        }
        // Get.offAndToNamed(Routes.MAIN_SCREEN);
      });
    });
    super.onInit();
  }

  loadAdd() async {
    Get.offAllNamed(Routes.MAIN_SCREEN);
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
