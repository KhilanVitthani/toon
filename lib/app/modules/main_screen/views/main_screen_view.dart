import 'dart:io';

import '../../../../constants/api_constants.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/progress_dialog_utils.dart';
import '../../../routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/svg.dart';

import '../controllers/main_screen_controller.dart';

class MainScreenView extends GetWidget<MainScreenController> {
  const MainScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return Obx(() {
      return SafeArea(
        child: Scaffold(
          backgroundColor: appTheme.primaryTheme,
          appBar: AppBar(
            backgroundColor: appTheme.primaryTheme,
            elevation: 0,
            title: Text(
              'Toon Photo Editor',
              style: GoogleFonts.karla(
                fontSize: MySize.getHeight(24),
                fontWeight: FontWeight.w500,
              ),
            ),
            centerTitle: true,
          ),
          body: Column(
            children: [
              CarouselSlider.builder(
                itemCount: controller.image.length,
                options: CarouselOptions(
                  height: MySize.getHeight(170),
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 2),
                  reverse: false,
                  viewportFraction: 1.0,
                  onPageChanged: (val, _) {
                    controller.selectedBannerIndex.value = val;
                  },
                ),
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return Image.asset(
                    controller.image[index],
                    width: MySize.getWidth(320),
                    fit: BoxFit.fill,
                  );
                },
              ),
              // Container(
              //   child: AnimatedSmoothIndicator(
              //     count: controller.image.length,
              //     activeIndex: controller.selectedBannerIndex.value,
              //     effect: WormEffect(
              //       dotHeight: MySize.getHeight(8),
              //       dotWidth: MySize.getWidth(8),
              //       type: WormType.thin,
              //       activeDotColor: appTheme.textGrayColor,
              //       dotColor: Colors.white,
              //     ),
              //   ),
              // ),
              SizedBox(
                height: MySize.getHeight(30),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MySize.getWidth(8)),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Apply amazing effects!",
                    style: GoogleFonts.karla(
                      fontSize: MySize.getHeight(20),
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: MySize.getHeight(18)),
                child: CarouselSlider.builder(
                  itemCount: controller.effectImage.length,
                  options: CarouselOptions(
                    height: MySize.getHeight(175),
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 4),
                    reverse: false,
                    viewportFraction: 1.0,
                    onPageChanged: (val, _) {
                      controller.selectedBannerIndex.value = val;
                    },
                  ),
                  itemBuilder:
                      (BuildContext context, int index, int realIndex) {
                    return Image.asset(
                      controller.effectImage[index],
                      width: MySize.getWidth(320),
                      fit: BoxFit.fill,
                    );
                  },
                ),
              ),
              SizedBox(
                height: MySize.getHeight(30),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MySize.getWidth(8)),
                child: Row(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "My Collection",
                        style: GoogleFonts.karla(
                          fontSize: MySize.getHeight(20),
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Get.offAndToNamed(Routes.MY_COLLECTION_PAGE);
                      },
                      child: Container(
                        // color: Colors.amber,
                        alignment: Alignment.topRight,
                        width: MySize.getWidth(50),
                        child: Icon(
                          Icons.arrow_forward_outlined,
                          color: Colors.white,
                          size: MySize.getHeight(25),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: MySize.getHeight(18)),
                child: (controller.myImage.isEmpty)
                    ? Container(
                        child: SvgPicture.asset(imagePath + "404.svg",
                            height: MySize.getHeight(109),
                            width: MySize.getWidth(215)),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: MySize.getWidth(8)),
                        height: (MySize.isMini)
                            ? MySize.getHeight(112)
                            : MySize.getHeight(124),
                        child: GridView.builder(
                          padding: EdgeInsets.only(bottom: 10),
                          itemCount: controller.myImage.length,
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  crossAxisSpacing: MySize.getHeight(10.0),
                                  mainAxisSpacing: MySize.getHeight(10.0)),
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Get.offAndToNamed(Routes.SHARE_FILE,
                                    arguments: {
                                      ArgumentConstant.capuredImage:
                                          File(controller.myImage[index]),
                                      ArgumentConstant.isFromMyCollection:
                                          false,
                                      ArgumentConstant.isFromHome: true,
                                    });
                              },
                              child: Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      MySize.getHeight(8)),
                                  child: Image.file(
                                    File(
                                      controller.myImage[index],
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
              Spacer(),
              Stack(
                children: [
                  Container(
                    height: MySize.getHeight(120),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: MySize.getHeight(50)),
                          child: Container(
                            height: MySize.getHeight(70),
                            decoration: BoxDecoration(
                              color: appTheme.buttonColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                  MySize.getHeight(20),
                                ),
                                topRight: Radius.circular(
                                  MySize.getHeight(20),
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star_border,
                                      size: MySize.getHeight(20),
                                      color: Colors.white,
                                    ),
                                    Text(
                                      "Rate us!",
                                      style: GoogleFonts.karla(
                                          fontSize: MySize.getHeight(15),
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: MySize.getHeight(20)),
                                  child: Text(
                                    "Create effect",
                                    style: GoogleFonts.karla(
                                        fontSize: MySize.getHeight(15),
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.offAndToNamed(Routes.SETTING_PAGE);
                                  },
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.settings_outlined,
                                        size: MySize.getHeight(20),
                                        color: Colors.white,
                                      ),
                                      Text(
                                        "Setting",
                                        style: GoogleFonts.karla(
                                            fontSize: MySize.getHeight(15),
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: MySize.getHeight(44),
                    left: MySize.getWidth(151),
                    child: GestureDetector(
                      onTap: () {
                        controller.check().then((intenet) {
                          if (intenet) {
                            Get.offAndToNamed(Routes.HOME);
                          } else {
                            getIt<CustomDialogs>().getDialog(
                              title: "Error",
                              desc: "No Internet Connection",
                            );
                          }
                        });
                      },
                      child: Container(
                        child: Image.asset(
                          imagePath + "add_btn.png",
                          width: MySize.getWidth(61),
                          height: MySize.getHeight(61),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
