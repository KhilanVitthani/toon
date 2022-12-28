import 'dart:convert';

import 'package:ai_image_enlarger/app/routes/app_pages.dart';
import 'package:ai_image_enlarger/constants/api_constants.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
import '../../../../utilities/timer_service.dart';

class MainScreenController extends GetxController {
  RxList image = RxList([]);
  RxList effectImage = RxList([]);
  RxInt selectedBannerIndex = 0.obs;
  RxList myImage = RxList([]);
  RxBool isFirstTime = false.obs;
  CarouselController carouselController = CarouselController();
  @override
  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.myCollection))) {
      RxList myImage1 = RxList([]);
      myImage1.value = jsonDecode(box.read(ArgumentConstant.myCollection));
      print(myImage);
      myImage.value = myImage1.reversed.toList();
    }

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
            Get.back();
            break;
        }
      },
    );
    addImage();
    // loadAdd();
    super.onInit();
  }

  loadAdd() async {
    await getIt<AdService>()
        .getAd(adType: AdService.interstitialAd)
        .then((value) {
      if (!value) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        Get.offAndToNamed(Routes.MAIN_SCREEN);
      }
    });
  }

  addImage() {
    image.add("${imagePath}1.png");
    image.add("${imagePath}2.png");
    image.add("${imagePath}3.png");
    image.add("${imagePath}4.png");
    effectImage.add("${imagePath}AiImageEnlarger.png");
    effectImage.add("${imagePath}AiAnime16K.png");
    effectImage.add("${imagePath}AiSketch.png");
    effectImage.add("${imagePath}AiEnhancer.png");
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
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
