import 'dart:convert';

import 'package:ai_image_enlarger/constants/api_constants.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:get/get.dart';

import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';

class MainScreenController extends GetxController {
  RxList image = RxList([]);
  RxList effectImage = RxList([]);
  RxInt selectedBannerIndex = 0.obs;
  RxList myImage = RxList([]);

  CarouselController carouselController = CarouselController();
  @override
  void onInit() {
    if (!isNullEmptyOrFalse(box.read(ArgumentConstant.myCollection))) {
      RxList myImage1 = RxList([]);

      myImage1.value = jsonDecode(box.read(ArgumentConstant.myCollection));
      print(myImage);
      myImage.value = myImage1.reversed.toList();
    }
    addImage();
    super.onInit();
  }

  addImage() {
    image.add("${imagePath}1.png");
    image.add("${imagePath}2.png");
    image.add("${imagePath}3.png");
    image.add("${imagePath}4.png");
    effectImage.add("${imagePath}AiImageEnlarger.png");
    effectImage.add("${imagePath}AiAnime16K.png");
    effectImage.add("${imagePath}AiSketch.png");
    effectImage.add("${imagePath}AiEnhancer.png");
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
