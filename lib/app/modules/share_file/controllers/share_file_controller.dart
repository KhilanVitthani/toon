import 'dart:io';
import '../../../../constants/api_constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:get/get.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

import '../../../../main.dart';
import '../../../../utilities/buttons.dart';
import '../../../../utilities/timer_service.dart';
import '../../../routes/app_pages.dart';

class ShareFileController extends GetxController {
  File? capturedImage;
  RxBool isFromMyCollection = false.obs;
  RxBool isFromHome = false.obs;
  final FlutterShareMe flutterShareMe = FlutterShareMe();
  @override
  void onInit() {
    if (Get.arguments != null) {
      capturedImage = Get.arguments[ArgumentConstant.capuredImage];
      isFromMyCollection.value =
          Get.arguments[ArgumentConstant.isFromMyCollection];
      isFromHome.value = Get.arguments[ArgumentConstant.isFromHome];
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
          (isFromMyCollection.isTrue)
              ? Get.offAndToNamed(Routes.MY_COLLECTION_PAGE)
              : (isFromHome.isTrue)
                  ? Get.offAndToNamed(Routes.MAIN_SCREEN)
                  : showConfirmationDialog(
                      context: Get.context!,
                      text: "Are you sure you want to go home.",
                      submitText: "Yes",
                      cancelText: "Cancel",
                      submitCallBack: () {
                        SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.edgeToEdge);
                        Get.offAllNamed(Routes.MAIN_SCREEN);
                      },
                      cancelCallback: () {
                        Get.back();
                      });
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
