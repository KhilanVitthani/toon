import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/timer_service.dart';
import '../../../routes/app_pages.dart';

class MyCollectionPageController extends GetxController {
  RxList myImage = RxList([]);
  var connectivityResult;

  @override
  Future<void> onInit() async {
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.myCollection))) {
      RxList myImage1 = RxList([]);
      connectivityResult = await Connectivity().checkConnectivity();
      myImage1.value = jsonDecode(box.read(ArgumentConstant.myCollection));
      print(myImage);
      myImage.value = myImage1.reversed.toList();
    }
    Yodo1MAS.instance.setInterstitialListener((event, message) {
      switch (event) {
        case Yodo1MAS.AD_EVENT_OPENED:
          print('Interstitial AD_EVENT_OPENED');
          break;
        case Yodo1MAS.AD_EVENT_ERROR:
          print('Interstitial AD_EVENT_ERROR' + message);
          break;
        case Yodo1MAS.AD_EVENT_CLOSED:
          getIt<TimerService>().verifyTimer();
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          Get.offAndToNamed(Routes.MAIN_SCREEN);
          break;
      }
    });
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
