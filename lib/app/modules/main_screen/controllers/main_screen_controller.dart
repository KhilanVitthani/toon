import 'dart:convert';

import 'dart:io';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:rate_my_app/rate_my_app.dart';

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

import '../../../../utilities/ad_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class MainScreenController extends GetxController {
  final imgPicker = ImagePicker();
  Rx<File>? imgFile;

  RxList image = RxList([]);
  RxList effectImage = RxList([]);
  RxInt selectedBannerIndex = 0.obs;
  RxList myImage = RxList([]);
  RxBool isFirstTime = false.obs;
  CarouselController carouselController = CarouselController();
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    box.write(ArgumentConstant.isFirstTime, false);
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.myCollection))) {
      RxList myImage1 = RxList([]);
      myImage1.value = jsonDecode(box.read(ArgumentConstant.myCollection));
      print(myImage);
      myImage.value = myImage1.reversed.toList();
    }

    addImage();
    getIt<AdService>().loadInterstitialAd();

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

  Future<dynamic> uploadImage({
    required BuildContext context,
    bool isFromEnhancer = false,
    bool isFromImageEnlarger = false,
  }) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: appTheme.textGrayColor,
            height:
                (MySize.isMini) ? MySize.getHeight(150) : MySize.getHeight(150),
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        openCamera().then((value) {
                          cropImage(
                              pickedFile: value,
                              context: context,
                              isFromEnhancer: isFromEnhancer,
                              isFromImageEnlarger: isFromImageEnlarger);
                          // if (isFromMagicEraser.isFalse) {
                          //   cropImage(
                          //       pickedFile: value, context: context);
                          // } else {
                          //   Get.offAndToNamed(Routes.MAGIC_REMOVE_PAGE,
                          //       arguments: {
                          //         ArgumentConstant.imageFile: value,
                          //       });
                          // }
                        }).catchError((error) {
                          print(error);
                        });
                        Navigator.of(context).pop();
                      },
                      child: getButton(
                        image: "camera.svg",
                        title: "Camera",
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        openGallery().then((value) {
                          cropImage(
                              pickedFile: value,
                              context: context,
                              isFromEnhancer: isFromEnhancer,
                              isFromImageEnlarger: isFromImageEnlarger);
                          // if (isFromMagicEraser.isFalse) {
                          //   cropImage(
                          //       pickedFile: value, context: context);
                          // } else {
                          //   Get.offAndToNamed(Routes.MAGIC_REMOVE_PAGE,
                          //       arguments: {
                          //         ArgumentConstant.imageFile: value,
                          //       });
                          // }
                          // ;
                        });
                        Navigator.of(context).pop();
                      },
                      child: getButton(
                        image: "gallery.svg",
                        title: "Gallery",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future<void> cropImage({
    File? pickedFile,
    BuildContext? context,
    bool isFromEnhancer = false,
    bool isFromImageEnlarger = false,
  }) async {
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Edit Photo',
              toolbarColor: appTheme.primaryTheme,
              toolbarWidgetColor: Colors.white,
              dimmedLayerColor: appTheme.primaryTheme,
              backgroundColor: appTheme.primaryTheme,
              activeControlsWidgetColor: appTheme.buttonColor,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: 'Edit Photo',
          ),
        ],
      ).then((value) {
        if (isFromEnhancer) {
          Get.offAndToNamed(Routes.IMAGE_SCREEN, arguments: {
            ArgumentConstant.imageFile: value!.path,
            ArgumentConstant.isFromEnhancer: true,
            ArgumentConstant.isFromCatoonizer: false,
            ArgumentConstant.isFromDenoiser: false,
            ArgumentConstant.isFromAnime: false,
            ArgumentConstant.isFromFaceRetouch: false,
            ArgumentConstant.isFromImageEnlarger: false,
            ArgumentConstant.isFromColorizer: false,
            ArgumentConstant.isFromImageUpscaler: false,
            ArgumentConstant.isFromSharpener: false,
            ArgumentConstant.isFromBGRemover: false,
            ArgumentConstant.isFromHome: true,
          });
        } else if (isFromImageEnlarger) {
          Get.offAndToNamed(Routes.IMAGE_SCREEN, arguments: {
            ArgumentConstant.imageFile: value!.path,
            ArgumentConstant.isFromEnhancer: false,
            ArgumentConstant.isFromCatoonizer: false,
            ArgumentConstant.isFromDenoiser: false,
            ArgumentConstant.isFromFaceRetouch: false,
            ArgumentConstant.isFromAnime: false,
            ArgumentConstant.isFromHome: true,
            ArgumentConstant.isFromImageEnlarger: true,
            ArgumentConstant.isFromImageUpscaler: false,
            ArgumentConstant.isFromSharpener: false,
            ArgumentConstant.isFromBGRemover: false,
            ArgumentConstant.isFromColorizer: false,
          });
        } else {
          Get.offAndToNamed(Routes.IMAGE_SCREEN, arguments: {
            ArgumentConstant.imageFile: value!.path,
            ArgumentConstant.isFromEnhancer: false,
            ArgumentConstant.isFromCatoonizer: true,
            ArgumentConstant.isFromDenoiser: false,
            ArgumentConstant.isFromAnime: false,
            ArgumentConstant.isFromImageEnlarger: false,
            ArgumentConstant.isFromHome: true,
            ArgumentConstant.isFromImageUpscaler: false,
            ArgumentConstant.isFromSharpener: false,
            ArgumentConstant.isFromFaceRetouch: false,
            ArgumentConstant.isFromBGRemover: false,
            ArgumentConstant.isFromColorizer: false,
          });
        }
      });
    }
  }

  Future<File?> openCamera() async {
    String? imgCamera;
    await imgPicker.pickImage(source: ImageSource.camera).then((value) {
      imgCamera = value!.path;
      print(imgCamera);
      imgFile = File(imgCamera!).obs;
      return imgFile!.value;
    }).catchError((error) {
      print(error);
    });

    return (isNullEmptyOrFalse(imgFile!.value)) ? null : imgFile!.value;
  }

  Future<File?> openGallery() async {
    String? imgGallery;
    await imgPicker.pickImage(source: ImageSource.gallery).then((value) {
      imgGallery = value!.path;

      imgFile = File(imgGallery!).obs;
      print(imgFile);
      imgFile!.refresh();
    });

    return (isNullEmptyOrFalse(imgFile!.value)) ? null : imgFile!.value;
  }
}
