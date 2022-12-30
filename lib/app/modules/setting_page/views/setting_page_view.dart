import 'dart:io';
import '../../../../constants/api_constants.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/sizeConstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
import '../../../../utilities/timer_service.dart';
import '../../../routes/app_pages.dart';
import '../controllers/setting_page_controller.dart';

class SettingPageView extends GetView<SettingPageController> {
  const SettingPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //
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
              backgroundColor: appTheme.primaryTheme,
              elevation: 0,
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
              title: Text(
                'Settings',
                style: GoogleFonts.karla(
                  fontSize: MySize.getHeight(24),
                  fontWeight: FontWeight.w500,
                ),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: MySize.getHeight(20)),
              child: Column(
                children: [
                  SizedBox(
                    height: MySize.getHeight(20),
                  ),
                  Image.asset(
                    "assets/images/setting.png",
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                    height: MySize.getHeight(20),
                  ),
                  settingTile(
                    onTap: () {
                      Share.share(
                          'check out my website https://play.google.com/store/apps/details?id=com.mobileappxperts.aieffects.toonphotoeditor');
                    },
                    context: context,
                    image: "shareicon.svg",
                    name: "Share",
                  ),
                  settingTile(
                    onTap: () {
                      controller.rateMyApp.init().then((value) {
                        controller.rateMyApp.showRateDialog(
                          context,
                          title: 'Rate this app', // The dialog title.0
                          message:
                              'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.', // The dialog message.
                          rateButton: 'RATE', // The dialog "rate" button text.
                          noButton: 'NO THANKS', // The dialog "no" button text.
                          laterButton:
                              'MAYBE LATER', // The dialog "later" button text.
                          listener: (button) {
                            // The button click listener (useful if you want to cancel the click event).
                            switch (button) {
                              case RateMyAppDialogButton.rate:
                                print('Clicked on "Rate".');
                                break;
                              case RateMyAppDialogButton.later:
                                print('Clicked on "Later".');
                                break;
                              case RateMyAppDialogButton.no:
                                print('Clicked on "No".');
                                break;
                            }

                            return true; // Return false if you want to cancel the click event.
                          },
                          ignoreNativeDialog: Platform
                              .isAndroid, // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
                          dialogStyle:
                              const DialogStyle(), // Custom dialog styles.
                          onDismissed: () => controller.rateMyApp.callEvent(
                              RateMyAppEventType
                                  .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
                        );
                      });
                    },
                    context: context,
                    image: "rateus.svg",
                    name: "Rate Us!",
                  ),
                  settingTile(
                    onTap: () async {
                      const url =
                          "https://sites.google.com/view/mobapp-privacy-policy/policy";
                      await launch(url);
                    },
                    context: context,
                    image: "policy.svg",
                    name: "Privacy Policy",
                  ),
                  settingTile(
                    onTap: () async {
                      final Uri params = Uri(
                        scheme: 'mailto',
                        path: '${feedBackEmail}',
                      );
                      var url = params.toString();
                      await launch(url);
                    },
                    context: context,
                    image: "feedback.svg",
                    name: "Feedback & Suggestions",
                  ),
                ],
              ),
            )),
      ),
    );
  }

  settingTile(
      {required BuildContext context,
      required String name,
      required String image,
      VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(bottom: MySize.getHeight(8)),
        child: Container(
          height: (MySize.isMini) ? MySize.getHeight(55) : MySize.getHeight(50),
          width: MySize.getWidth(320),
          decoration: BoxDecoration(
              color: Color(0xff3B3943),
              borderRadius: BorderRadius.circular(MySize.getHeight(8))),
          child: Row(
            children: [
              SizedBox(
                width: MySize.getWidth(23),
              ),
              SvgPicture.asset(imagePath + image),
              SizedBox(
                width: MySize.getWidth(18),
              ),
              Text(
                "${name}",
                style: GoogleFonts.karla(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: MySize.getHeight(18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
