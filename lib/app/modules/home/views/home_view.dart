import 'dart:io';

import 'package:ai_image_enlarger/constants/sizeConstant.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final imgPicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Center(
              child: GestureDetector(
            onTap: () {
              uploadImage(context);
            },
            child: Container(
              width: MySize.getWidth(100),
              height: MySize.getHeight(50),
              alignment: Alignment.center,
              child: Text(
                "AI Cartoonizer",
                style: TextStyle(
                    fontSize: MySize.getHeight(15),
                    fontWeight: FontWeight.bold),
              ),
            ),
          )),
          Center(
              child: GestureDetector(
            onTap: () {
              controller.isFromEnhancer.value = true;
              uploadImage(context);
            },
            child: Container(
              width: MySize.getWidth(100),
              height: MySize.getHeight(50),
              alignment: Alignment.center,
              child: Text(
                "AI Enhancer",
                style: TextStyle(
                    fontSize: MySize.getHeight(15),
                    fontWeight: FontWeight.bold),
              ),
            ),
          )),
          Center(
              child: GestureDetector(
            onTap: () {
              controller.isFromDenoiser.value = true;
              uploadImage(context);
            },
            child: Container(
              width: MySize.getWidth(100),
              height: MySize.getHeight(50),
              alignment: Alignment.center,
              child: Text(
                "AI Denoiser",
                style: TextStyle(
                    fontSize: MySize.getHeight(15),
                    fontWeight: FontWeight.bold),
              ),
            ),
          )),
          Center(
              child: GestureDetector(
            onTap: () {
              controller.isFromAnime.value = true;
              uploadImage(context);
            },
            child: Container(
              width: MySize.getWidth(100),
              height: MySize.getHeight(50),
              alignment: Alignment.center,
              child: Text(
                "AI Anime",
                style: TextStyle(
                    fontSize: MySize.getHeight(15),
                    fontWeight: FontWeight.bold),
              ),
            ),
          )),
          Center(
              child: GestureDetector(
            onTap: () {
              controller.isFromImageEnlarger.value = true;
              uploadImage(context);
            },
            child: Container(
              width: MySize.getWidth(100),
              height: MySize.getHeight(50),
              alignment: Alignment.center,
              child: Text(
                "AI Image Enlarger",
                style: TextStyle(
                    fontSize: MySize.getHeight(15),
                    fontWeight: FontWeight.bold),
              ),
            ),
          )),
          Center(
              child: GestureDetector(
            onTap: () {
              controller.isFromImageUpscaler.value = true;
              uploadImage(context);
            },
            child: Container(
              width: MySize.getWidth(100),
              height: MySize.getHeight(50),
              alignment: Alignment.center,
              child: Text(
                "AI Image Upscaler",
                style: TextStyle(
                    fontSize: MySize.getHeight(15),
                    fontWeight: FontWeight.bold),
              ),
            ),
          )),
          Center(
              child: GestureDetector(
            onTap: () {
              controller.isFromSharpener.value = true;
              uploadImage(context);
            },
            child: Container(
              width: MySize.getWidth(100),
              height: MySize.getHeight(50),
              alignment: Alignment.center,
              child: Text(
                "AI Sharpener",
                style: TextStyle(
                    fontSize: MySize.getHeight(15),
                    fontWeight: FontWeight.bold),
              ),
            ),
          )),
          Center(
              child: GestureDetector(
            onTap: () {
              controller.isFromFaceRetouch.value = true;
              uploadImage(context);
            },
            child: Container(
              width: MySize.getWidth(100),
              height: MySize.getHeight(50),
              alignment: Alignment.center,
              child: Text(
                "AI Face Retouch",
                style: TextStyle(
                    fontSize: MySize.getHeight(15),
                    fontWeight: FontWeight.bold),
              ),
            ),
          )),
          Center(
              child: GestureDetector(
            onTap: () {
              controller.isFromBGRemover.value = true;
              uploadImage(context);
            },
            child: Container(
              width: MySize.getWidth(100),
              height: MySize.getHeight(50),
              alignment: Alignment.center,
              child: Text(
                "AI BG Remover",
                style: TextStyle(
                    fontSize: MySize.getHeight(15),
                    fontWeight: FontWeight.bold),
              ),
            ),
          )),
          Center(
              child: GestureDetector(
            onTap: () {
              controller.isFromColorizer.value = true;
              uploadImage(context);
            },
            child: Container(
              width: MySize.getWidth(100),
              height: MySize.getHeight(50),
              alignment: Alignment.center,
              child: Text(
                "AI Colorizer",
                style: TextStyle(
                    fontSize: MySize.getHeight(15),
                    fontWeight: FontWeight.bold),
              ),
            ),
          )),
        ],
      ),
    );
  }

  Future<dynamic> uploadImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 150,
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  "choose profile photo",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 30),
                Row(
                  children: [
                    SizedBox(
                      width: 40,
                    ),
                    IconButton(
                        onPressed: () {
                          openCamera().then((value) {
                            controller.cropImage(
                                pickedFile: value, context: context);
                          });
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          size: 50,
                        )),
                    SizedBox(
                      width: 110,
                    ),
                    IconButton(
                        onPressed: () {
                          openGallery().then((value) {
                            controller.cropImage(
                                pickedFile: value, context: context);
                          });
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.photo_album,
                          size: 50,
                        )),
                  ],
                ),
              ],
            ),
          );
        });
  }

  Future<File> openCamera() async {
    var imgCamera =
        await imgPicker.pickImage(source: ImageSource.camera).then((value) {
      controller.imgFile = File(value!.path).obs;
      controller.imgFile!.refresh();
    }).catchError((error) {
      print(error);
    });
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
