import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yodo1mas/Yodo1MasBannerAd.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/sizeConstant.dart';
import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
import '../../../../utilities/timer_service.dart';
import '../../../routes/app_pages.dart';
import '../controllers/my_collection_page_controller.dart';

class MyCollectionPageView extends GetWidget<MyCollectionPageController> {
  const MyCollectionPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
      child: Scaffold(
        backgroundColor: appTheme.primaryTheme,
        appBar: AppBar(
          backgroundColor: appTheme.primaryTheme,
          title: Text(
            'My Collection',
            style: GoogleFonts.karla(
              fontSize: MySize.getHeight(24),
              fontWeight: FontWeight.w500,
            ),
          ),
          centerTitle: true,
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
            },
            child: Container(
              padding: EdgeInsets.only(left: MySize.getWidth(10)),
              child: Icon(Icons.arrow_back),
            ),
          ),
          elevation: 0,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: MySize.getWidth(10)),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: GridView.builder(
                    padding: EdgeInsets.only(bottom: 10),
                    itemCount: controller.myImage.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: MySize.getHeight(10.0),
                        mainAxisSpacing: MySize.getHeight(10.0)),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.offAndToNamed(Routes.SHARE_FILE, arguments: {
                            ArgumentConstant.capuredImage:
                                File(controller.myImage[index]),
                            ArgumentConstant.isFromMyCollection: true,
                            ArgumentConstant.isFromHome: false,
                          });
                        },
                        child: Container(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(MySize.getHeight(8)),
                            child: Image.file(
                              File(
                                controller.myImage[index],
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              (controller.connectivityResult == ConnectionState.none)
                  ? SizedBox()
                  : Yodo1MASBannerAd(
                      size: BannerSize.Banner,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
