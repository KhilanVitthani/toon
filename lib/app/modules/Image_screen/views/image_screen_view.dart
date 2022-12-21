import 'dart:io';
import 'dart:typed_data';

import 'package:ai_image_enlarger/app/routes/app_pages.dart';
import 'package:ai_image_enlarger/constants/api_constants.dart';
import 'package:ai_image_enlarger/constants/color_constant.dart';
import 'package:ai_image_enlarger/constants/sizeConstant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gallery_saver/gallery_saver.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/image_screen_controller.dart';

class ImageScreenView extends GetWidget<ImageScreenController> {
  const ImageScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAndToNamed(Routes.HOME);
        return await true;
      },
      child: Obx(() {
        return SafeArea(
          child: Scaffold(
            backgroundColor: appTheme.primaryTheme,
            appBar: (controller.hasDate.isTrue)
                ? AppBar(
                    backgroundColor: appTheme.primaryTheme,
                    elevation: 0,
                    actions: [
                      IconButton(
                          onPressed: () {
                            Get.offAndToNamed(Routes.HOME);
                          },
                          icon: Icon(Icons.arrow_back)),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          controller.screenshotController
                              .capture(
                                  delay: Duration(
                            milliseconds: 10,
                          ))
                              .then((value) async {
                            if (value!.isNotEmpty) {
                              Uint8List imageInUnit8List = value;
                              final tempDir = await getTemporaryDirectory();
                              final time = DateTime.now();

                              File file = await File(
                                      '${tempDir.path}/Screenshot${time}.png')
                                  .create();

                              GallerySaver.saveImage(file.path).then((value) {
                                Fluttertoast.showToast(
                                    msg: "Success!",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              });
                              file.writeAsBytesSync(imageInUnit8List);
                            }
                            ShowCapturedWidget(context, value);
                          });
                        },
                        child: Container(
                          width: MySize.getWidth(70),
                          height: MySize.getHeight(50),
                          padding: EdgeInsets.symmetric(
                              horizontal: MySize.getHeight(8.0)),
                          alignment: Alignment.center,
                          child: Text(
                            "Save",
                            style: GoogleFonts.karla(
                                fontSize: MySize.getHeight(18)),
                          ),
                        ),
                      )
                    ],
                  )
                : null,
            body: Column(
              children: [
                Spacer(),
                (controller.hasDate.isTrue)
                    ? Screenshot(
                        controller: controller.screenshotController,
                        child: Stack(
                          children: [
                            (controller.is2d.isTrue)
                                ? getImageByLink(
                                    url: "${controller.image2D}",
                                    height: MySize.getHeight(400),
                                    boxFit: BoxFit.contain,
                                    width: MySize.getHeight(500))
                                : getImageByLink(
                                    url: "${controller.image3D}",
                                    boxFit: BoxFit.contain,
                                    height: MySize.getHeight(350),
                                    width: MySize.getHeight(500)),
                            (controller.isSwitched.value)
                                ? Positioned(
                                    left: MySize.getWidth(10),
                                    bottom: MySize.getHeight(5),
                                    child: Container(
                                      height: MySize.getHeight(100),
                                      width: MySize.getHeight(100),
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius: BorderRadius.circular(
                                              MySize.getHeight(75))),
                                      child: ClipOval(
                                        child: Image.file(
                                            File(controller.imagePath),
                                            fit: BoxFit.fitWidth),
                                      ),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    : Container(
                        height: MySize.screenHeight -
                            MediaQuery.of(context).padding.top,
                        decoration: BoxDecoration(
                          color: Colors.transparent.withOpacity(0.9),
                          image: DecorationImage(
                            image: FileImage(File(controller.imagePath)),
                            fit: BoxFit.fill,
                            opacity: 0.2,
                          ),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "We are drawing your Cartoon!",
                                style: GoogleFonts.karla(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: MySize.getHeight(18)),
                              ),
                              Container(
                                child: Image.asset(
                                  imagePath + "loading.gif",
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                (controller.hasDate.isTrue)
                    ? Row(
                        children: [
                          Text(
                            "Mini-Image",
                            style: GoogleFonts.karla(
                                color: Colors.white,
                                fontSize: MySize.getHeight(15)),
                          ),
                          Switch(
                            onChanged: (value) {
                              controller.isSwitched.toggle();
                            },
                            value: controller.isSwitched.value,
                          ),
                        ],
                      )
                    : Container(),
                Spacer(),
                (controller.hasDate.isTrue)
                    ? (controller.isFromCatoonizer.isTrue)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.is2d.value = true;
                                },
                                child: getImageByLink(
                                    url:
                                        "http://get.imglarger.com:8889/results/${controller.imageID}_a.jpg",
                                    height: MySize.getHeight(100),
                                    width: MySize.getHeight(100)),
                              ),
                              GestureDetector(
                                onTap: () {
                                  controller.is2d.value = false;
                                },
                                child: getImageByLink(
                                    url:
                                        "http://get.imglarger.com:8889/results/${controller.imageID}_t.jpg",
                                    height: MySize.getHeight(100),
                                    width: MySize.getHeight(100)),
                              ),
                            ],
                          )
                        : Container()
                    : Container(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<dynamic> ShowCapturedWidget(
    BuildContext context,
    Uint8List capturedImage,
  ) {
    return showDialog(
      useSafeArea: false,
      context: context,
      builder: (context) => Scaffold(
        backgroundColor: appTheme.primaryTheme,
        appBar: AppBar(
          backgroundColor: appTheme.primaryTheme,
          centerTitle: true,
          title: Text("your Image"),
          elevation: 0,
        ),
        body: Center(
            child: capturedImage != null
                ? Image.memory(capturedImage)
                : Container()),
        floatingActionButton: FloatingActionButton(
          backgroundColor: appTheme.primaryTheme,
          onPressed: () async {
            if (capturedImage.isNotEmpty) {
              Uint8List imageInUnit8List = capturedImage;
              final tempDir = await getTemporaryDirectory();
              final time = DateTime.now();

              File file =
                  await File('${tempDir.path}/Screenshot${time}.png').create();
              file.writeAsBytesSync(imageInUnit8List);
              await Share.shareFiles([file.path]);
            }
          },
          child: Icon(Icons.share),
        ),
      ),
    );
  }
}
