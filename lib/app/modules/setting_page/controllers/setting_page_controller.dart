import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

import '../../../../main.dart';
import '../../../../utilities/timer_service.dart';
import '../../../routes/app_pages.dart';

class SettingPageController extends GetxController {
  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
    googlePlayIdentifier: 'com.mobileappxperts.aieffects.toonphotoeditor',
    // appStoreIdentifier: '1491556149',
  );
  @override
  void onInit() {
    Yodo1MAS.instance.setInterstitialListener(
      (event, message) {
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
      },
    );
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
