import 'dart:convert';

import 'dart:io';

import '../../../../constants/api_constants.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/connectivityHelper.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/buttons.dart';
import '../../../../utilities/progress_dialog_utils.dart';
import '../../../../utilities/timer_service.dart';
import '../../../routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yodo1mas/Yodo1MasBannerAd.dart';
import 'package:yodo1mas/Yodo1MasNativeAd.dart';

import '../../../../utilities/ad_service.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

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
