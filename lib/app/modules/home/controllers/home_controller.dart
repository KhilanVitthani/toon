import 'dart:io';

import 'package:ai_image_enlarger/app/routes/app_pages.dart';
import 'package:ai_image_enlarger/constants/api_constants.dart';
import 'package:ai_image_enlarger/constants/color_constant.dart';
import 'package:ai_image_enlarger/main.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';

import '../../../../constants/connectivityHelper.dart';
import '../../../../utilities/progress_dialog_utils.dart';

class HomeController extends GetxController {
  CroppedFile? _croppedFile;
  Rx<File>? imgFile;
  RxBool isFromEnhancer = false.obs;
  RxBool isFromDenoiser = false.obs;
  RxBool isFromAnime = false.obs;
  RxBool isFromImageEnlarger = false.obs;
  RxBool isFromImageUpscaler = false.obs;
  RxBool isFromSharpener = false.obs;
  RxBool isFromFaceRetouch = false.obs;
  RxBool isFromBGRemover = false.obs;
  RxBool isFromColorizer = false.obs;
  RxBool isFromMagicEraser = false.obs;
  Map source = {ConnectivityResult.none: false};
  final ConnetctivityHelper connectivity = ConnetctivityHelper.instance;
  @override
  void onInit() {
    connectivity.initialise();
    connectivity.myStream.listen((event) {
      source = event;
      if (source.keys.toList()[0] == ConnectivityResult.none) {
        getIt<CustomDialogs>().getDialog(
          title: "Error",
          desc: "No Internet Connection",
          onTap: () {
            Get.offAndToNamed(Routes.MAIN_SCREEN);
          },
        );
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
    source.clear();
    super.onClose();
  }

  Future<void> cropImage({File? pickedFile, BuildContext? context}) async {
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
      );
      if (croppedFile != null) {
        _croppedFile = croppedFile;
        print("CropFile ${_croppedFile!.path}");
        if (isFromEnhancer.isTrue) {
          Get.toNamed(Routes.IMAGE_SCREEN, arguments: {
            ArgumentConstant.imageFile: _croppedFile!.path,
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
          });
        } else if (isFromDenoiser.isTrue) {
          Get.toNamed(Routes.IMAGE_SCREEN, arguments: {
            ArgumentConstant.imageFile: _croppedFile!.path,
            ArgumentConstant.isFromEnhancer: false,
            ArgumentConstant.isFromCatoonizer: false,
            ArgumentConstant.isFromDenoiser: true,
            ArgumentConstant.isFromAnime: false,
            ArgumentConstant.isFromFaceRetouch: false,
            ArgumentConstant.isFromColorizer: false,
            ArgumentConstant.isFromImageEnlarger: false,
            ArgumentConstant.isFromImageUpscaler: false,
            ArgumentConstant.isFromSharpener: false,
            ArgumentConstant.isFromBGRemover: false,
          });
        } else if (isFromAnime.isTrue) {
          Get.toNamed(Routes.IMAGE_SCREEN, arguments: {
            ArgumentConstant.imageFile: _croppedFile!.path,
            ArgumentConstant.isFromEnhancer: false,
            ArgumentConstant.isFromCatoonizer: false,
            ArgumentConstant.isFromDenoiser: false,
            ArgumentConstant.isFromAnime: true,
            ArgumentConstant.isFromImageEnlarger: false,
            ArgumentConstant.isFromFaceRetouch: false,
            ArgumentConstant.isFromImageUpscaler: false,
            ArgumentConstant.isFromSharpener: false,
            ArgumentConstant.isFromColorizer: false,
            ArgumentConstant.isFromBGRemover: false,
          });
        } else if (isFromImageEnlarger.isTrue) {
          Get.toNamed(Routes.IMAGE_SCREEN, arguments: {
            ArgumentConstant.imageFile: _croppedFile!.path,
            ArgumentConstant.isFromEnhancer: false,
            ArgumentConstant.isFromCatoonizer: false,
            ArgumentConstant.isFromDenoiser: false,
            ArgumentConstant.isFromFaceRetouch: false,
            ArgumentConstant.isFromAnime: false,
            ArgumentConstant.isFromImageEnlarger: true,
            ArgumentConstant.isFromImageUpscaler: false,
            ArgumentConstant.isFromSharpener: false,
            ArgumentConstant.isFromBGRemover: false,
            ArgumentConstant.isFromColorizer: false,
          });
        } else if (isFromImageUpscaler.isTrue) {
          Get.toNamed(Routes.IMAGE_SCREEN, arguments: {
            ArgumentConstant.imageFile: _croppedFile!.path,
            ArgumentConstant.isFromEnhancer: false,
            ArgumentConstant.isFromCatoonizer: false,
            ArgumentConstant.isFromDenoiser: false,
            ArgumentConstant.isFromAnime: false,
            ArgumentConstant.isFromFaceRetouch: false,
            ArgumentConstant.isFromImageEnlarger: false,
            ArgumentConstant.isFromImageUpscaler: true,
            ArgumentConstant.isFromSharpener: false,
            ArgumentConstant.isFromColorizer: false,
            ArgumentConstant.isFromBGRemover: false,
          });
        } else if (isFromSharpener.isTrue) {
          Get.toNamed(Routes.IMAGE_SCREEN, arguments: {
            ArgumentConstant.imageFile: _croppedFile!.path,
            ArgumentConstant.isFromEnhancer: false,
            ArgumentConstant.isFromCatoonizer: false,
            ArgumentConstant.isFromDenoiser: false,
            ArgumentConstant.isFromFaceRetouch: false,
            ArgumentConstant.isFromAnime: false,
            ArgumentConstant.isFromImageEnlarger: false,
            ArgumentConstant.isFromImageUpscaler: false,
            ArgumentConstant.isFromSharpener: true,
            ArgumentConstant.isFromBGRemover: false,
            ArgumentConstant.isFromColorizer: false,
          });
        } else if (isFromFaceRetouch.isTrue) {
          Get.toNamed(Routes.IMAGE_SCREEN, arguments: {
            ArgumentConstant.imageFile: _croppedFile!.path,
            ArgumentConstant.isFromEnhancer: false,
            ArgumentConstant.isFromCatoonizer: false,
            ArgumentConstant.isFromDenoiser: false,
            ArgumentConstant.isFromAnime: false,
            ArgumentConstant.isFromImageEnlarger: false,
            ArgumentConstant.isFromImageUpscaler: false,
            ArgumentConstant.isFromSharpener: false,
            ArgumentConstant.isFromFaceRetouch: true,
            ArgumentConstant.isFromBGRemover: false,
            ArgumentConstant.isFromColorizer: false,
          });
        } else if (isFromBGRemover.isTrue) {
          Get.toNamed(Routes.IMAGE_SCREEN, arguments: {
            ArgumentConstant.imageFile: _croppedFile!.path,
            ArgumentConstant.isFromEnhancer: false,
            ArgumentConstant.isFromCatoonizer: false,
            ArgumentConstant.isFromDenoiser: false,
            ArgumentConstant.isFromAnime: false,
            ArgumentConstant.isFromImageEnlarger: false,
            ArgumentConstant.isFromImageUpscaler: false,
            ArgumentConstant.isFromSharpener: false,
            ArgumentConstant.isFromFaceRetouch: false,
            ArgumentConstant.isFromBGRemover: true,
            ArgumentConstant.isFromColorizer: false,
          });
        } else if (isFromColorizer.isTrue) {
          Get.toNamed(Routes.IMAGE_SCREEN, arguments: {
            ArgumentConstant.imageFile: _croppedFile!.path,
            ArgumentConstant.isFromEnhancer: false,
            ArgumentConstant.isFromCatoonizer: false,
            ArgumentConstant.isFromDenoiser: false,
            ArgumentConstant.isFromAnime: false,
            ArgumentConstant.isFromImageEnlarger: false,
            ArgumentConstant.isFromImageUpscaler: false,
            ArgumentConstant.isFromSharpener: false,
            ArgumentConstant.isFromFaceRetouch: false,
            ArgumentConstant.isFromBGRemover: false,
            ArgumentConstant.isFromColorizer: true,
          });
        } else {
          Get.toNamed(Routes.IMAGE_SCREEN, arguments: {
            ArgumentConstant.imageFile: _croppedFile!.path,
            ArgumentConstant.isFromEnhancer: false,
            ArgumentConstant.isFromCatoonizer: true,
            ArgumentConstant.isFromDenoiser: false,
            ArgumentConstant.isFromAnime: false,
            ArgumentConstant.isFromImageEnlarger: false,
            ArgumentConstant.isFromImageUpscaler: false,
            ArgumentConstant.isFromSharpener: false,
            ArgumentConstant.isFromFaceRetouch: false,
            ArgumentConstant.isFromBGRemover: false,
            ArgumentConstant.isFromColorizer: false,
          });
        }
      }
    }
  }
}
