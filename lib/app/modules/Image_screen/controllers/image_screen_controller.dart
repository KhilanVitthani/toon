import 'dart:convert';
import 'dart:io';

import 'package:ai_image_enlarger/main.dart';
import 'package:ai_image_enlarger/models/categoriesModels.dart';
import 'package:ai_image_enlarger/utilities/progress_dialog_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:http/http.dart' as http;
import 'package:screenshot/screenshot.dart';
import '../../../../constants/api_constants.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../routes/app_pages.dart';
import 'package:path/path.dart' as p;

class ImageScreenController extends GetxController {
  RxString selectedImagePath = "".obs;
  RxString imageID = "".obs;
  RxString image2D = "".obs;
  RxString image3D = "".obs;
  RxBool isSwitched = false.obs;
  RxList imageList = RxList([]);
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
      selectedImagePath.value = Get.arguments[ArgumentConstant.imageFile];
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
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.myCollection))) {
      imageList.value = jsonDecode(box.read(ArgumentConstant.myCollection));
    }
    print(selectedImagePath);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      if (selectedImagePath.value.isNotEmpty) {
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

  addImageToDataBase({required String imageFile}) {
    imageList.add(imageFile);
    box.write(ArgumentConstant.myCollection, jsonEncode(imageList));
    print("DataBase Collection ${box.read(ArgumentConstant.myCollection)}");
  }

  callApiForCartoonImage({
    required BuildContext context,
  }) async {
    print("Image path : = ${selectedImagePath.value}");
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://access2.imglarger.com:8997/upload'));
    request.fields.addAll({'Alg': 'slow', 'scaleRadio': '4'});
    request.files.add(
        await http.MultipartFile.fromPath('myfile', selectedImagePath.value));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();
      print(imageID);
      image2D.value = "http://get.imglarger.com:8889/results/${imageID}_a.jpg";
      image3D.value = "http://get.imglarger.com:8889/results/${imageID}_t.jpg";
      isImageDone(imageId: imageID.value, context: context, urlId: "8997");
    } else {
      getIt<CustomDialogs>().getDialog(
        title: "Something Went Wrong, Please Try Again",
        desc: "${response.reasonPhrase}",
        onTap: () {
          Get.offAllNamed(Routes.HOME);
          selectedImagePath.value = "";
        },
      );
      print(response.reasonPhrase);
    }
  }

  callApiForEnhancer({
    required BuildContext context,
  }) async {
    FocusManager.instance.primaryFocus!.unfocus();

    print("Image path : = ${selectedImagePath.value}");
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://access2.imglarger.com:8558/upload'));
    request.fields.addAll({'Alg': 'slow', 'scaleRadio': '0'});
    request.files.add(
        await http.MultipartFile.fromPath('myfile', selectedImagePath.value));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();
      print(imageID);
      image2D.value = "http://get.imglarger.com:8887/results/${imageID}.jpg";
      print(image2D);
      isImageDone(imageId: imageID.value, context: context, urlId: "8558");
    } else {
      getIt<CustomDialogs>().getDialog(
        title: "Something Went Wrong, Please Try Again",
        desc: "${response.reasonPhrase}",
        onTap: () {
          Get.offAllNamed(Routes.HOME);
          selectedImagePath.value = "";
        },
      );
      print(response.reasonPhrase);
    }
  }

  callApiForDenoiser({required BuildContext context}) async {
    FocusManager.instance.primaryFocus!.unfocus();

    Map<String, dynamic> dict = {};
    dict["Alg"] = "slow";
    dict["scaleRadio"] = "4";

    print("Image path : = ${selectedImagePath.value}");
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://access2.imglarger.com:8552/upload'));
    request.fields.addAll({'Alg': 'slow', 'scaleRadio': '4'});
    request.files.add(
        await http.MultipartFile.fromPath('myfile', selectedImagePath.value));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();
      image2D.value = "http://get.imglarger.com:8662/results/${imageID}.jpg";
      isImageDone(imageId: imageID.value, context: context, urlId: "8552");
    } else {
      getIt<CustomDialogs>().getDialog(
        title: "Something Went Wrong, Please Try Again",
        desc: "${response.reasonPhrase}",
        onTap: () {
          Get.offAllNamed(Routes.HOME);
          selectedImagePath.value = "";
        },
      );
      print(response.reasonPhrase);
    }
  }

  callApiForAnime({required BuildContext context}) async {
    FocusManager.instance.primaryFocus!.unfocus();

    Map<String, dynamic> dict = {};
    dict["Alg"] = "slow";
    dict["scaleRadio"] = "4";

    print("Image path : = ${selectedImagePath.value}");
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://access.imglarger.com:8998/upload'));
    request.fields.addAll({'Alg': 'slow', 'scaleRadio': '4'});
    request.files.add(
        await http.MultipartFile.fromPath('myfile', selectedImagePath.value));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();
      print(imageID);
      image2D.value =
          "http://access.imglarger.com:8889/results/${imageID}_4x.jpg";
      isImageDone(
          imageId: imageID.value,
          context: context,
          urlId: "8998",
          isFromAnime: true);
    } else {
      getIt<CustomDialogs>().getDialog(
        title: "Something Went Wrong, Please Try Again",
        desc: "${response.reasonPhrase}",
        onTap: () {
          Get.offAllNamed(Routes.HOME);
          selectedImagePath.value = "";
        },
      );
      print(response.reasonPhrase);
    }
  }

  callApiForImageEnlarger({required BuildContext context}) async {
    FocusManager.instance.primaryFocus!.unfocus();

    Map<String, dynamic> dict = {};
    dict["Alg"] = "slow";
    dict["scaleRadio"] = "4";
    print("Image path : = ${selectedImagePath.value}");
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://access2.imglarger.com:8999/upload'));
    request.fields.addAll({'Alg': 'slow', 'scaleRadio': '2'});
    request.files.add(
        await http.MultipartFile.fromPath('myfile', selectedImagePath.value));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();
      print(imageID);
      image2D.value = "http://get.imglarger.com:8889/results/${imageID}_2x.jpg";
      isImageDone(imageId: imageID.value, context: context, urlId: "8999");
    } else {
      getIt<CustomDialogs>().getDialog(
        title: "Something Went Wrong, Please Try Again",
        desc: "${response.reasonPhrase}",
        onTap: () {
          Get.offAllNamed(Routes.HOME);
          selectedImagePath.value = "";
        },
      );
      print(response.reasonPhrase);
    }
  }

  callApiForImageSharpener({required BuildContext context}) async {
    FocusManager.instance.primaryFocus!.unfocus();

    Map<String, dynamic> dict = {};
    dict["Alg"] = "slow";
    dict["scaleRadio"] = "4";

    print("Image path : = ${selectedImagePath.value}");
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://access2.imglarger.com:8559/upload'));
    request.fields.addAll({'Alg': 'slow', 'scaleRadio': '2'});
    request.files.add(
        await http.MultipartFile.fromPath('myfile', selectedImagePath.value));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();
      print(imageID);
      image2D.value = "http://get.imglarger.com:8888/db_results/${imageID}.png";
      isImageDone(imageId: imageID.value, context: context, urlId: "8559");
    } else {
      getIt<CustomDialogs>().getDialog(
        title: "Something Went Wrong, Please Try Again",
        desc: "${response.reasonPhrase}",
        onTap: () {
          Get.offAllNamed(Routes.HOME);
          selectedImagePath.value = "";
        },
      );
      print(response.reasonPhrase);
    }
  }

  callApiForFaceRetouch({required BuildContext context}) async {
    FocusManager.instance.primaryFocus!.unfocus();

    Map<String, dynamic> dict = {};
    dict["Alg"] = "slow";
    dict["scaleRadio"] = "4";

    print("Image path : = ${selectedImagePath.value}");
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://access2.imglarger.com:8995/upload'));
    request.fields.addAll({'Alg': 'slow', 'scaleRadio': '4'});
    request.files.add(
        await http.MultipartFile.fromPath('myfile', selectedImagePath.value));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();
      print(imageID);
      image2D.value = "http://get.imglarger.com:8664/results/${imageID}.jpg";
      isImageDone(imageId: imageID.value, context: context, urlId: "8995");
    } else {
      getIt<CustomDialogs>().getDialog(
        title: "Something Went Wrong, Please Try Again",
        desc: "${response.reasonPhrase}",
        onTap: () {
          Get.offAllNamed(Routes.HOME);
          selectedImagePath.value = "";
        },
      );
      print(response.reasonPhrase);
    }
  }

  callApiForBGRemover({required BuildContext context}) async {
    FocusManager.instance.primaryFocus!.unfocus();

    Map<String, dynamic> dict = {};
    dict["Alg"] = "slow";
    dict["scaleRadio"] = "4";

    print("Image path : = ${selectedImagePath.value}");
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://access2.bgeraser.com:8558/upload'));
    request.fields.addAll({'Alg': 'slow', 'scaleRadio': '4'});
    request.files.add(
        await http.MultipartFile.fromPath('myfile', selectedImagePath.value));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();

      print(imageID);
      image2D.value =
          "https://access2.bgeraser.com:8889/results/${imageID}.png";
      isImageDone(
          imageId: imageID.value,
          context: context,
          urlId: "8558",
          isFrombgRemover: true);
    } else {
      getIt<CustomDialogs>().getDialog(
        title: "Something Went Wrong, Please Try Again",
        desc: "${response.reasonPhrase}",
        onTap: () {
          Get.offAllNamed(Routes.HOME);
          selectedImagePath.value = "";
        },
      );
      print(response.reasonPhrase);
    }
  }

  callApiForColorizer({required BuildContext context}) async {
    FocusManager.instance.primaryFocus!.unfocus();

    Map<String, dynamic> dict = {};
    dict["Alg"] = "slow";
    dict["scaleRadio"] = "4";

    print("Image path : = ${selectedImagePath.value}");
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://access1.imagecolorizer.com:8661/upload'));
    request.fields.addAll({'scaleRadio': '0'});
    request.files.add(
        await http.MultipartFile.fromPath('myfile', selectedImagePath.value));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();

      print(imageID);
      image2D.value =
          "http://access1.imagecolorizer.com:8663/results/${imageID}.jpg";
      isImageDone(imageId: imageID.value, context: context, urlId: "8661");
    } else {
      getIt<CustomDialogs>().getDialog(
        title: "Something Went Wrong, Please Try Again",
        desc: "${response.reasonPhrase}",
        onTap: () {
          Get.offAllNamed(Routes.HOME);
          selectedImagePath.value = "";
        },
      );
      print(response.reasonPhrase);
    }
  }

  callApiForImageUpscaler({required BuildContext context}) async {
    FocusManager.instance.primaryFocus!.unfocus();

    Map<String, dynamic> dict = {};
    dict["Alg"] = "slow";
    dict["scaleRadio"] = "4";
    print("Image path : = ${selectedImagePath.value}");
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://access2.imglarger.com:8999/upload'));
    request.fields.addAll({'Alg': 'slow', 'scaleRadio': '2\n'});
    request.files.add(
        await http.MultipartFile.fromPath('myfile', selectedImagePath.value));

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      imageID.value = await response.stream.bytesToString();

      image2D.value = "http://get.imglarger.com:8889/results/${imageID}_2x.jpg";
      isImageDone(imageId: imageID.value, context: context, urlId: "8999");
    } else {
      Get.offAndToNamed(Routes.HOME);
      print(response.reasonPhrase);
    }
  }

  isImageDone({
    required String imageId,
    required BuildContext context,
    required String urlId,
    bool isFrombgRemover = false,
    bool isFromAnime = false,
    int count = 1,
  }) async {
    var url = (isFrombgRemover)
        ? Uri.parse("https://access2.bgeraser.com:8558/status/$imageID")
        : (isFromAnime)
            ? Uri.parse("https://access.imglarger.com:8998/status/$imageID")
            : Uri.parse(
                'https://access2.imglarger.com:${urlId}/status/$imageID');
    var request = http.Request('GET', url);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      RxString imageResponse = "".obs;
      imageResponse.value = await response.stream.bytesToString();
      print(imageResponse.value);
      if (imageResponse.value == "waiting") {
        print(count);
        if (count <= 40) {
          isImageDone(
            imageId: imageId,
            context: context,
            urlId: urlId,
            isFromAnime: isFromAnime,
            isFrombgRemover: isFrombgRemover,
            count: count + 1,
          );
        } else {
          getIt<CustomDialogs>().getDialog(
            title: "Something Went Wrong, Please Try Again",
            desc: "",
            onTap: () {
              Get.offAllNamed(Routes.HOME);
              selectedImagePath.value = "";
            },
          );
        }
      } else if (imageResponse.value == "not found" ||
          imageResponse.value == "Not Found") {
        getIt<CustomDialogs>().getDialog(
          title: "Something Went Wrong, Please Try Again",
          desc: "",
          onTap: () {
            Get.offAllNamed(Routes.HOME);
            selectedImagePath.value = "";
          },
        );
      } else if (imageResponse.value == "noface") {
        getIt<CustomDialogs>().getDialog(
          title: "Something Went Wrong, Please Try Again",
          desc: "Face not detected",
          onTap: () {
            Get.offAllNamed(Routes.HOME);
            selectedImagePath.value = "";
          },
        );
      } else {
        hasDate.value = true;
      }
    } else {
      print(response.reasonPhrase);
    }
  }
}
