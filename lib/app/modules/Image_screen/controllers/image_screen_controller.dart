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
  RxBool isFromAnime = false.obs;
  RxBool isFromImageEnlarger = false.obs;
  RxBool isFromImageUpscaler = false.obs;
  RxBool isFromSharpener = false.obs;
  RxBool isFromFaceRetouch = false.obs;
  RxBool isFromBGRemover = false.obs;
  RxBool isFromColorizer = false.obs;
  @override
  void onInit() {
    if (Get.arguments != null) {
      imagePath = Get.arguments[ArgumentConstant.imageFile];
      isFromEnhancer.value = Get.arguments[ArgumentConstant.isFromEnhancer];
      isFromCatoonizer.value = Get.arguments[ArgumentConstant.isFromCatoonizer];
      isFromDenoiser.value = Get.arguments[ArgumentConstant.isFromDenoiser];
      isFromAnime.value = Get.arguments[ArgumentConstant.isFromAnime];
      isFromImageEnlarger.value =
          Get.arguments[ArgumentConstant.isFromImageEnlarger];
      isFromImageUpscaler.value =
          Get.arguments[ArgumentConstant.isFromImageUpscaler];
      isFromSharpener.value = Get.arguments[ArgumentConstant.isFromSharpener];
      isFromFaceRetouch.value =
          Get.arguments[ArgumentConstant.isFromFaceRetouch];
      isFromBGRemover.value = Get.arguments[ArgumentConstant.isFromBGRemover];
      isFromColorizer.value = Get.arguments[ArgumentConstant.isFromColorizer];
    }
    ;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (imagePath.isNotEmpty) {
        if (isFromEnhancer.isTrue) {
          callApiForEnhancer(context: Get.context!);
        } else if (isFromDenoiser.isTrue) {
          callApiForDenoiser(context: Get.context!);
        } else if (isFromAnime.isTrue) {
          callApiForAnime(context: Get.context!);
        } else if (isFromImageEnlarger.isTrue) {
          callApiForImageEnlarger(context: Get.context!);
        } else if (isFromImageUpscaler.isTrue) {
          callApiForImageUpscaler(context: Get.context!);
        } else if (isFromSharpener.isTrue) {
          callApiForImageSharpener(context: Get.context!);
        } else if (isFromFaceRetouch.isTrue) {
          callApiForFaceRetouch(context: Get.context!);
        } else if (isFromBGRemover.isTrue) {
          callApiForBGRemover(context: Get.context!);
        } else if (isFromColorizer.isTrue) {
          callApiForColorizer(context: Get.context!);
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

  callApiForAnime({required BuildContext context}) async {
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
        'POST', Uri.parse('https://access.imglarger.com:8998/upload'));
    request.fields.addAll({'Alg': 'slow', 'scaleRadio': '4'});
    request.files.add(await http.MultipartFile.fromPath('myfile', imagePath));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();
      Future.delayed(Duration(seconds: 15)).then((value) {
        image2D.value =
            "http://access.imglarger.com:8889/results/${imageID}_4x.jpg";
        getIt<CustomDialogs>().hideCircularDialog(context);

        hasDate.value = true;
      });
    } else {
      getIt<CustomDialogs>().hideCircularDialog(context);
      Get.offAndToNamed(Routes.HOME);
      print(response.reasonPhrase);
    }
  }

  callApiForImageEnlarger({required BuildContext context}) async {
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
        'POST', Uri.parse('https://access.imglarger.com:8998/upload'));
    request.fields.addAll({'scaleRadio': '2'});
    request.files.add(await http.MultipartFile.fromPath('myfile', image));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();
      Future.delayed(Duration(seconds: 30)).then((value) {
        print(imageID);
        image2D.value =
            "http://access.imglarger.com:8889/results/${imageID}_2x.jpg";
        getIt<CustomDialogs>().hideCircularDialog(context);

        hasDate.value = true;
      });
    } else {
      getIt<CustomDialogs>().hideCircularDialog(context);
      Get.offAndToNamed(Routes.HOME);
      print(response.reasonPhrase);
    }
  }

  callApiForImageSharpener({required BuildContext context}) async {
    FocusManager.instance.primaryFocus!.unfocus();
    getIt.get<CustomDialogs>().showCircularDialog(context);
    Map<String, dynamic> dict = {};
    dict["Alg"] = "slow";
    dict["scaleRadio"] = "4";

    FormData formData = new FormData.fromMap(dict);
    print("Image path : = ${imagePath}");
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://access2.imglarger.com:8559/upload'));
    request.fields.addAll({'Alg': 'slow', 'scaleRadio': '2'});
    request.files.add(await http.MultipartFile.fromPath('myfile', imagePath));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();
      Future.delayed(Duration(seconds: 15)).then((value) {
        print(imageID);
        image2D.value =
            "http://get.imglarger.com:8888/db_results/${imageID}.png";
        getIt<CustomDialogs>().hideCircularDialog(context);

        hasDate.value = true;
      });
    } else {
      getIt<CustomDialogs>().hideCircularDialog(context);
      Get.offAndToNamed(Routes.HOME);
      print(response.reasonPhrase);
    }
  }

  callApiForFaceRetouch({required BuildContext context}) async {
    FocusManager.instance.primaryFocus!.unfocus();
    getIt.get<CustomDialogs>().showCircularDialog(context);
    Map<String, dynamic> dict = {};
    dict["Alg"] = "slow";
    dict["scaleRadio"] = "4";

    FormData formData = new FormData.fromMap(dict);
    print("Image path : = ${imagePath}");
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://access2.imglarger.com:8995/upload'));
    request.fields.addAll({'Alg': 'slow', 'scaleRadio': '4'});
    request.files.add(await http.MultipartFile.fromPath('myfile', imagePath));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();
      Future.delayed(Duration(seconds: 15)).then((value) {
        print(imageID);
        image2D.value = "http://get.imglarger.com:8664/results/${imageID}.jpg";
        getIt<CustomDialogs>().hideCircularDialog(context);

        hasDate.value = true;
      });
    } else {
      getIt<CustomDialogs>().hideCircularDialog(context);
      Get.offAndToNamed(Routes.HOME);
      print(response.reasonPhrase);
    }
  }

  callApiForBGRemover({required BuildContext context}) async {
    FocusManager.instance.primaryFocus!.unfocus();
    getIt.get<CustomDialogs>().showCircularDialog(context);
    Map<String, dynamic> dict = {};
    dict["Alg"] = "slow";
    dict["scaleRadio"] = "4";

    FormData formData = new FormData.fromMap(dict);
    print("Image path : = ${imagePath}");
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://access2.bgeraser.com:8558/upload'));
    request.fields.addAll({'Alg': 'slow', 'scaleRadio': '4'});
    request.files.add(await http.MultipartFile.fromPath('myfile', imagePath));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();
      Future.delayed(Duration(seconds: 15)).then((value) {
        print(imageID);
        image2D.value =
            "https://access2.bgeraser.com:8889/results/${imageID}.png";
        getIt<CustomDialogs>().hideCircularDialog(context);

        hasDate.value = true;
      });
    } else {
      getIt<CustomDialogs>().hideCircularDialog(context);
      Get.offAndToNamed(Routes.HOME);
      print(response.reasonPhrase);
    }
  }

  callApiForColorizer({required BuildContext context}) async {
    FocusManager.instance.primaryFocus!.unfocus();
    getIt.get<CustomDialogs>().showCircularDialog(context);
    Map<String, dynamic> dict = {};
    dict["Alg"] = "slow";
    dict["scaleRadio"] = "4";

    FormData formData = new FormData.fromMap(dict);
    print("Image path : = ${imagePath}");
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://access1.imagecolorizer.com:8661/upload'));
    request.fields.addAll({'scaleRadio': '0'});
    request.files.add(await http.MultipartFile.fromPath('myfile', imagePath));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();
      Future.delayed(Duration(seconds: 15)).then((value) {
        print(imageID);
        image2D.value =
            "http://access1.imagecolorizer.com:8663/results/${imageID}.jpg";
        getIt<CustomDialogs>().hideCircularDialog(context);

        hasDate.value = true;
      });
    } else {
      getIt<CustomDialogs>().hideCircularDialog(context);
      Get.offAndToNamed(Routes.HOME);
      print(response.reasonPhrase);
    }
  }

  callApiForImageUpscaler({required BuildContext context}) async {
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
        'POST', Uri.parse('https://access2.imglarger.com:8999/upload'));
    request.fields.addAll({'Alg': 'slow', 'scaleRadio': '2\n'});
    request.files.add(await http.MultipartFile.fromPath('myfile', imagePath));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();
      Future.delayed(Duration(seconds: 15)).then((value) {
        image2D.value =
            "http://get.imglarger.com:8889/results/${imageID}_2x.jpg";
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
