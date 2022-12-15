import 'dart:io';
import 'package:ai_image_enlarger/app/routes/app_pages.dart';
import 'package:ai_image_enlarger/constants/api_constants.dart';
import 'package:ai_image_enlarger/main.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../utilities/progress_dialog_utils.dart';

class HomeController extends GetxController {
  File? _lastCropped;
  CroppedFile? _croppedFile;
  Rx<File>? imgFile;
  RxBool isFromEnhancer = false.obs;
  RxBool isFromDenoiser = false.obs;
  @override
  void onInit() {
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

  Future<void> cropImage({File? pickedFile, BuildContext? context}) async {
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
        ],
      );
      if (croppedFile != null) {
        _croppedFile = croppedFile;
        print("CropFile ${_croppedFile!.path}");
        if (isFromEnhancer.isTrue) {
          Get.offAndToNamed(Routes.IMAGE_SCREEN, arguments: {
            ArgumentConstant.imageFile: _croppedFile!.path,
            ArgumentConstant.isFromEnhancer: true,
            ArgumentConstant.isFromCatoonizer: false,
            ArgumentConstant.isFromDenoiser: false,
          });
        } else if (isFromDenoiser.isTrue) {
          Get.offAndToNamed(Routes.IMAGE_SCREEN, arguments: {
            ArgumentConstant.imageFile: _croppedFile!.path,
            ArgumentConstant.isFromEnhancer: false,
            ArgumentConstant.isFromCatoonizer: false,
            ArgumentConstant.isFromDenoiser: true,
          });
        } else {
          Get.offAndToNamed(Routes.IMAGE_SCREEN, arguments: {
            ArgumentConstant.imageFile: _croppedFile!.path,
            ArgumentConstant.isFromEnhancer: false,
            ArgumentConstant.isFromCatoonizer: true,
            ArgumentConstant.isFromDenoiser: false,
          });
        }
      }
    }
  }
}
