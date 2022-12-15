import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:http/http.dart' as http;
import 'package:screenshot/screenshot.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../data/NetworkClient.dart';
import '../../../../main.dart';
import '../../../../utilities/progress_dialog_utils.dart';
import '../../../routes/app_pages.dart';
import 'package:path/path.dart' as p;

class ImageScreenController extends GetxController {
  String imagePath = "";
  RxString imageID = "".obs;
  RxString image2D = "".obs;
  RxString image3D = "".obs;
  RxBool isSwitched = false.obs;
  ScreenshotController screenshotController = ScreenshotController();
  var image;
  RxBool hasDate = false.obs;
  RxBool is2d = true.obs;
  RxBool isFromEnhancer = false.obs;
  RxBool isFromCatoonizer = false.obs;
  RxBool isFromDenoiser = false.obs;
  @override
  void onInit() {
    if (Get.arguments != null) {
      imagePath = Get.arguments[ArgumentConstant.imageFile];
      isFromEnhancer.value = Get.arguments[ArgumentConstant.isFromEnhancer];
      isFromCatoonizer.value = Get.arguments[ArgumentConstant.isFromCatoonizer];
      isFromDenoiser.value = Get.arguments[ArgumentConstant.isFromDenoiser];
    }
    ;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (imagePath.isNotEmpty) {
        if (isFromEnhancer.isTrue) {
          callApiForEnhancer(context: Get.context!);
        }
        if (isFromDenoiser.isTrue) {
          callApiForDenoiser(context: Get.context!);
        } else {
          callApiForCartoonImage(context: Get.context!);
        }
      }
      super.onInit();
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  callApiForCartoonImage({
    required BuildContext context,
  }) async {
    FocusManager.instance.primaryFocus!.unfocus();
    getIt.get<CustomDialogs>().showCircularDialog(context);
    Map<String, dynamic> dict = {};
    dict["Alg"] = "slow";
    dict["scaleRadio"] = "0";
    String fileName = p.basenameWithoutExtension(imagePath);
    List<int> imageData = await File(imagePath).readAsBytes();
    // dict["myfile"] = (!isNullEmptyOrFalse(File(imagePath!)))
    //     ? await MultipartFile.fr(imagePath!, filename: fileName)
    //     : "";
    FormData formData = new FormData.fromMap(dict);
    print("Image path : = ${imagePath}");
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://access2.imglarger.com:8997/upload'));
    request.fields.addAll({'Alg': 'slow', 'scaleRadio': '4'});
    request.files.add(await http.MultipartFile.fromPath('myfile', imagePath));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();
      Future.delayed(Duration(seconds: 15)).then((value) {
        image2D.value =
            "http://get.imglarger.com:8889/results/${imageID}_a.jpg";
        image3D.value =
            "http://get.imglarger.com:8889/results/${imageID}_t.jpg";
        getIt<CustomDialogs>().hideCircularDialog(context);

        hasDate.value = true;
      });
    } else {
      getIt<CustomDialogs>().hideCircularDialog(context);
      Get.offAndToNamed(Routes.HOME);
      print(response.reasonPhrase);
    }
  }

  callApiForEnhancer({
    required BuildContext context,
  }) async {
    FocusManager.instance.primaryFocus!.unfocus();
    getIt.get<CustomDialogs>().showCircularDialog(context);
    Map<String, dynamic> dict = {};
    dict["Alg"] = "slow";
    dict["scaleRadio"] = "4";
    String fileName = p.basenameWithoutExtension(imagePath);
    List<int> imageData = await File(imagePath).readAsBytes();
    // dict["myfile"] = (!isNullEmptyOrFalse(File(imagePath!)))
    //     ? await MultipartFile.fr(imagePath!, filename: fileName)
    //     : "";
    FormData formData = new FormData.fromMap(dict);
    print("Image path : = ${imagePath}");
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://access2.imglarger.com:8558/upload'));
    request.fields.addAll({'Alg': 'slow', 'scaleRadio': '0'});
    request.files.add(await http.MultipartFile.fromPath('myfile', imagePath));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();
      Future.delayed(Duration(seconds: 15)).then((value) {
        image2D.value = "http://get.imglarger.com:8887/results/${imageID}.jpg";
        getIt<CustomDialogs>().hideCircularDialog(context);

        hasDate.value = true;
      });
    } else {
      getIt<CustomDialogs>().hideCircularDialog(context);
      Get.offAndToNamed(Routes.HOME);
      print(response.reasonPhrase);
    }
  }

  callApiForDenoiser({required BuildContext context}) async {
    FocusManager.instance.primaryFocus!.unfocus();
    getIt.get<CustomDialogs>().showCircularDialog(context);
    Map<String, dynamic> dict = {};
    dict["Alg"] = "slow";
    dict["scaleRadio"] = "4";
    String fileName = p.basenameWithoutExtension(imagePath);
    List<int> imageData = await File(imagePath).readAsBytes();
    // dict["myfile"] = (!isNullEmptyOrFalse(File(imagePath!)))
    //     ? await MultipartFile.fr(imagePath!, filename: fileName)
    //     : "";
    FormData formData = new FormData.fromMap(dict);
    print("Image path : = ${imagePath}");
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://access2.imglarger.com:8552/upload'));
    request.fields.addAll({'Alg': 'slow', 'scaleRadio': '4'});
    request.files.add(await http.MultipartFile.fromPath('myfile', imagePath));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();
      Future.delayed(Duration(seconds: 15)).then((value) {
        image2D.value = "http://get.imglarger.com:8662/results/${imageID}.jpg";
        getIt<CustomDialogs>().hideCircularDialog(context);

        hasDate.value = true;
      });
    } else {
      getIt<CustomDialogs>().hideCircularDialog(context);
      Get.offAndToNamed(Routes.HOME);
      print(response.reasonPhrase);
    }
  }
}
