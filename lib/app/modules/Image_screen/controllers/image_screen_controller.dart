import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:http/http.dart' as http;
import 'package:screenshot/screenshot.dart';
import 'package:yodo1mas/Yodo1MAS.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/connectivityHelper.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
import '../../../../utilities/progress_dialog_utils.dart';
import '../../../../utilities/timer_service.dart';
import '../../../routes/app_pages.dart';

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
  RxString saveImage = "".obs;
  RxBool isFromHome = false.obs;
  RxBool isFromSave = false.obs;
  Map source = {ConnectivityResult.none: false};
  final ConnetctivityHelper connectivity = ConnetctivityHelper.instance;
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
      isFromHome.value = Get.arguments[ArgumentConstant.isFromHome];
    }
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.myCollection))) {
      imageList.value = jsonDecode(box.read(ArgumentConstant.myCollection));
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
          (isFromSave.isTrue)
              ? Get.offAndToNamed(Routes.SHARE_FILE, arguments: {
                  ArgumentConstant.capuredImage: File(saveImage.value),
                  ArgumentConstant.isFromMyCollection: false,
                  ArgumentConstant.isFromHome: false,
                })
              : Get.offAndToNamed(Routes.MAIN_SCREEN);
          break;
      }
    });

    print(selectedImagePath);
    connectivity.initialise();
    connectivity.myStream.listen((event) {
      source = event;
      if (source.keys.toList()[0] == ConnectivityResult.none) {
        getIt<CustomDialogs>().getDialog(
          title: "Error",
          desc: "No Internet Connection",
          onTap: () {
            Get.offAllNamed(Routes.MAIN_SCREEN);
          },
        );
      } else {
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
    saveImage.value = imageFile;
    getIt<AdService>().getAd(adType: AdService.interstitialAd).then((value) {
      // if (!value) {
      //   getIt<TimerService>().verifyTimer();
      //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      //
      //   Get.offAndToNamed(Routes.SHARE_FILE, arguments: {
      //     ArgumentConstant.capuredImage: File(imageFile),
      //     ArgumentConstant.isFromMyCollection: false,
      //     ArgumentConstant.isFromHome: false,
      //   });
      // }
    });
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
          Get.offAllNamed(Routes.MAIN_SCREEN);
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
      image3D.value = "http://get.imglarger.com:8887/results/${imageID}.jpg";
      print(image2D);
      isImageDone(imageId: imageID.value, context: context, urlId: "8558");
    } else {
      getIt<CustomDialogs>().getDialog(
        title: "Something Went Wrong, Please Try Again",
        desc: "${response.reasonPhrase}",
        onTap: () {
          Get.offAllNamed(Routes.MAIN_SCREEN);
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
      image3D.value = "http://get.imglarger.com:8662/results/${imageID}.jpg";
      isImageDone(imageId: imageID.value, context: context, urlId: "8552");
    } else {
      getIt<CustomDialogs>().getDialog(
        title: "Something Went Wrong, Please Try Again",
        desc: "${response.reasonPhrase}",
        onTap: () {
          Get.offAllNamed(Routes.MAIN_SCREEN);
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
      image3D.value =
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
          Get.offAllNamed(Routes.MAIN_SCREEN);
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
      image3D.value = "http://get.imglarger.com:8889/results/${imageID}_2x.jpg";
      isImageDone(imageId: imageID.value, context: context, urlId: "8999");
    } else {
      getIt<CustomDialogs>().getDialog(
        title: "Something Went Wrong, Please Try Again",
        desc: "${response.reasonPhrase}",
        onTap: () {
          Get.offAllNamed(Routes.MAIN_SCREEN);
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
      image3D.value = "http://get.imglarger.com:8888/db_results/${imageID}.png";
      isImageDone(imageId: imageID.value, context: context, urlId: "8559");
    } else {
      getIt<CustomDialogs>().getDialog(
        title: "Something Went Wrong, Please Try Again",
        desc: "${response.reasonPhrase}",
        onTap: () {
          Get.offAllNamed(Routes.MAIN_SCREEN);
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
      image3D.value = "http://get.imglarger.com:8664/results/${imageID}.jpg";
      isImageDone(imageId: imageID.value, context: context, urlId: "8995");
    } else {
      getIt<CustomDialogs>().getDialog(
        title: "Something Went Wrong, Please Try Again",
        desc: "${response.reasonPhrase}",
        onTap: () {
          Get.offAllNamed(Routes.MAIN_SCREEN);
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
      image3D.value =
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
          Get.offAllNamed(Routes.MAIN_SCREEN);
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
      image3D.value =
          "http://access1.imagecolorizer.com:8663/results/${imageID}.jpg";
      isImageDone(imageId: imageID.value, context: context, urlId: "8661");
    } else {
      getIt<CustomDialogs>().getDialog(
        title: "Something Went Wrong, Please Try Again",
        desc: "${response.reasonPhrase}",
        onTap: () {
          Get.offAllNamed(Routes.MAIN_SCREEN);
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
      image3D.value = "http://get.imglarger.com:8889/results/${imageID}_2x.jpg";
      isImageDone(imageId: imageID.value, context: context, urlId: "8999");
    } else {
      Get.offAndToNamed(Routes.MAIN_SCREEN);
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
              Get.offAllNamed(Routes.MAIN_SCREEN);
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
            Get.offAllNamed(Routes.MAIN_SCREEN);
            selectedImagePath.value = "";
          },
        );
      } else if (imageResponse.value == "noface") {
        getIt<CustomDialogs>().getDialog(
          title: "Something Went Wrong, Please Try Again",
          desc: "Face not detected",
          onTap: () {
            Get.offAllNamed(Routes.MAIN_SCREEN);
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
