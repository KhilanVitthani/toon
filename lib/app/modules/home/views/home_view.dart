import 'dart:io';

import 'package:ai_image_enlarger/app/routes/app_pages.dart';
import 'package:ai_image_enlarger/constants/api_constants.dart';
import 'package:ai_image_enlarger/constants/color_constant.dart';
import 'package:ai_image_enlarger/constants/sizeConstant.dart';
import 'package:ai_image_enlarger/utilities/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final imgPicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
      backgroundColor: appTheme.primaryTheme,
      appBar: AppBar(
        title: const Text('Name'),
        centerTitle: true,
        backgroundColor: appTheme.primaryTheme,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MySize.getWidth(20), vertical: MySize.getHeight(10)),
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
              SizedBox(
                height: MySize.getHeight(20),
              ),
              ImageButton(
                  onTap: () {
                    controller.isFromAnime.value = true;
                    uploadImage(context);
                  },
                  context: context,
                  title: "AI Anime16K",
                  image: "AiAnime16K.png"),
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
            height: MySize.getHeight(100),
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

  Future<File> openCamera() async {
    var imgCamera;
    await imgPicker.pickImage(source: ImageSource.camera).then((value) {
      imgCamera = value;
      print(imgCamera);
    });

    controller.imgFile = File(imgCamera!.path).obs;

    return controller.imgFile!.value;
  }

  Future<File> openGallery() async {
    var imgGallery =
        await imgPicker.pickImage(source: ImageSource.gallery).then((value) {
      controller.imgFile = File(value!.path).obs;
      print(controller.imgFile);
      controller.imgFile!.refresh();
    });
    return controller.imgFile!.value;
  }
}
