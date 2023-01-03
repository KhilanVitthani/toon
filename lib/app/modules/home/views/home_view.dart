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

import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
import '../../../../utilities/timer_service.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetWidget<HomeController> {
  final imgPicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return WillPopScope(
      onWillPop: () async {
        if (getIt<TimerService>().is40SecCompleted) {
          await getIt<AdService>()
              .getAd(adType: AdService.interstitialAd)
              .then((value) {
            if (!value) {
              getIt<TimerService>().verifyTimer();
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              Get.offAndToNamed(Routes.MAIN_SCREEN);
            }
          });
        } else {
          Get.offAndToNamed(Routes.MAIN_SCREEN);
        }

        return await true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: appTheme.primaryTheme,
          appBar: AppBar(
            title: Text(
              'Toon Photo Editor',
              style: GoogleFonts.karla(
                fontSize: MySize.getHeight(24),
                fontWeight: FontWeight.w500,
              ),
            ),
            leading: GestureDetector(
              onTap: () async {
                if (getIt<TimerService>().is40SecCompleted) {
                  await getIt<AdService>()
                      .getAd(adType: AdService.interstitialAd)
                      .then((value) {
                    if (!value) {
                      getIt<TimerService>().verifyTimer();
                      SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.edgeToEdge);
                      Get.offAndToNamed(Routes.MAIN_SCREEN);
                    }
                  });
                } else {
                  Get.offAndToNamed(Routes.MAIN_SCREEN);
                }

                // box.erase();
              },
              child: Container(
                child: Icon(Icons.arrow_back),
              ),
            ),
            centerTitle: true,
            backgroundColor: appTheme.primaryTheme,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MySize.getWidth(20),
                  vertical: MySize.getHeight(10)),
              child: Column(
                children: [
                  ImageButton(
                      onTap: () {
                        uploadImage(context);
                      },
                      context: context,
                      title: "AI Cartoonizer",
                      subtitle: "Turn everything into a cartoon!",
                      image: "AiCartoonizer.png"),
                  SizedBox(
                    height: MySize.getHeight(20),
                  ),
                  ImageButton(
                      onTap: () {
                        controller.isFromEnhancer.value = true;
                        uploadImage(context);
                      },
                      context: context,
                      title: "AI Enhancer",
                      image: "AiEnhancer.png"),
                  SizedBox(
                    height: MySize.getHeight(20),
                  ),
                  (controller.connectivityResult == ConnectionState.none)
                      ? SizedBox()
                      : Yodo1MASNativeAd(
                          size: NativeSize.NativeSmall,
                          backgroundColor: "WHITE",
                          onLoad: () => print('Native Ad loaded:'),
                          onClosed: () => print('Native Ad clicked:'),
                          onLoadFailed: (message) =>
                              print('Native Ad $message'),
                        ),

                  SizedBox(
                    height: MySize.getHeight(20),
                  ),
                  ImageButton(
                      onTap: () {
                        controller.isFromColorizer.value = true;
                        uploadImage(context);
                      },
                      context: context,
                      title: "AI Photo colorizer",
                      image: "AiPhotocolorizer.png"),
                  // SizedBox(
                  //   height: MySize.getHeight(20),
                  // ),
                  // ImageButton(
                  //     onTap: () {
                  //       controller.isFromMagicEraser.value = true;
                  //       uploadImage(context);
                  //     },
                  //     context: context,
                  //     title: "Magic Eraser",
                  //     image: "MagicEraser.png"),
                  SizedBox(
                    height: MySize.getHeight(20),
                  ),
                  ImageButton(
                      onTap: () {
                        controller.isFromBGRemover.value = true;
                        uploadImage(context);
                      },
                      context: context,
                      title: "AI Bg remover",
                      image: "AiBgremover.png"),
                  SizedBox(
                    height: MySize.getHeight(20),
                  ),
                  ImageButton(
                      onTap: () {
                        controller.isFromImageUpscaler.value = true;
                        uploadImage(context);
                      },
                      context: context,
                      title: "AI Upscaler",
                      image: "AiUpscaler.png"),
                  // SizedBox(
                  //   height: MySize.getHeight(20),
                  // ),
                  // ImageButton(
                  //     onTap: () {
                  //       controller.isFromAnime.value = true;
                  //       uploadImage(context);
                  //     },
                  //     context: context,
                  //     title: "AI Anime16K",
                  //     image: "AiAnime16K.png"),
                  SizedBox(
                    height: MySize.getHeight(20),
                  ),
                  ImageButton(
                      onTap: () {
                        controller.isFromDenoiser.value = true;
                        uploadImage(context);
                      },
                      context: context,
                      title: "AI Denoiser",
                      image: "AiDenoiser.png"),
                  SizedBox(
                    height: MySize.getHeight(20),
                  ),
                  (controller.connectivityResult == ConnectionState.none)
                      ? SizedBox()
                      : Yodo1MASBannerAd(
                          size: BannerSize.Banner,
                        ),
                  SizedBox(
                    height: MySize.getHeight(20),
                  ),
                  ImageButton(
                      onTap: () {
                        controller.isFromImageEnlarger.value = true;
                        uploadImage(context);
                      },
                      context: context,
                      title: "AI Image Enlarger",
                      image: "AiImageEnlarger.png"),
                  SizedBox(
                    height: MySize.getHeight(20),
                  ),
                  ImageButton(
                      onTap: () {
                        controller.isFromSharpener.value = true;
                        uploadImage(context);
                      },
                      context: context,
                      title: "AI Sharpener",
                      image: "AiSharpener.png"),
                  SizedBox(
                    height: MySize.getHeight(20),
                  ),
                  ImageButton(
                      onTap: () {
                        controller.isFromFaceRetouch.value = true;
                        uploadImage(context);
                      },
                      context: context,
                      title: "AI Face Retouch",
                      image: "AiFaceRetouch.png"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ImageButton({
    required BuildContext context,
    required String image,
    required String title,
    String subtitle = "",
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xff38383a),
                borderRadius: BorderRadius.circular(MySize.getHeight(16))),
            width: MySize.getWidth(320),
            height:
                (MySize.isMini) ? MySize.getHeight(200) : MySize.getHeight(160),
            child: ClipRRect(
                child: Image.asset(
              imagePath + image,
              fit: BoxFit.fill,
            )),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(38, 35, 47, 0.6),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(MySize.getHeight(24)),
                    bottomLeft: Radius.circular(MySize.getHeight(16))),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: MySize.getWidth(10),
                    vertical: MySize.getHeight(5)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${title}",
                      style: GoogleFonts.karla(
                          color: Colors.white,
                          fontSize: MySize.getHeight(22),
                          fontWeight: FontWeight.w700),
                    ),
                    (subtitle != "")
                        ? Text(
                            subtitle,
                            style: GoogleFonts.karla(
                              color: Colors.white,
                              fontSize: MySize.getHeight(12),
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> uploadImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: appTheme.textGrayColor,
            height:
                (MySize.isMini) ? MySize.getHeight(150) : MySize.getHeight(100),
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
                          if (controller.isFromMagicEraser.isFalse) {
                            controller.cropImage(
                                pickedFile: value, context: context);
                          } else {
                            Get.offAndToNamed(Routes.MAGIC_REMOVE_PAGE,
                                arguments: {
                                  ArgumentConstant.imageFile: value,
                                });
                          }
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
                          if (controller.isFromMagicEraser.isFalse) {
                            controller.cropImage(
                                pickedFile: value, context: context);
                          } else {
                            Get.offAndToNamed(Routes.MAGIC_REMOVE_PAGE,
                                arguments: {
                                  ArgumentConstant.imageFile: value,
                                });
                          }
                          ;
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

  Future<File?> openCamera() async {
    String? imgCamera;
    await imgPicker.pickImage(source: ImageSource.camera).then((value) {
      imgCamera = value!.path;
      print(imgCamera);
      controller.imgFile = File(imgCamera!).obs;
      return controller.imgFile!.value;
    }).catchError((error) {
      print(error);
    });

    return (isNullEmptyOrFalse(controller.imgFile!.value))
        ? null
        : controller.imgFile!.value;
  }

  Future<File?> openGallery() async {
    String? imgGallery;
    await imgPicker.pickImage(source: ImageSource.gallery).then((value) {
      imgGallery = value!.path;

      controller.imgFile = File(imgGallery!).obs;
      print(controller.imgFile);
      controller.imgFile!.refresh();
    });

    return (isNullEmptyOrFalse(controller.imgFile!.value))
        ? null
        : controller.imgFile!.value;
  }
}
