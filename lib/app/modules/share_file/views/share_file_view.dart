import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:yodo1mas/Yodo1MasBannerAd.dart';

import '../../../../constants/api_constants.dart';
import '../../../../constants/color_constant.dart';
import '../../../../constants/sizeConstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/file_type.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../constants/color_constant.dart';
import '../../../../main.dart';
import '../../../../utilities/ad_service.dart';
import '../../../../utilities/buttons.dart';
import '../../../../utilities/progress_dialog_utils.dart';
import '../../../../utilities/timer_service.dart';
import '../../../routes/app_pages.dart';
import '../controllers/share_file_controller.dart';

class ShareFileView extends GetView<ShareFileController> {
  const ShareFileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (controller.isFromMyCollection.isTrue) {
          if (getIt<TimerService>().is40SecCompleted) {
            await getIt<AdService>()
                .getAd(adType: AdService.interstitialAd)
                .then((value) {
              if (!value) {
                getIt<TimerService>().verifyTimer();
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                Get.offAllNamed(Routes.MY_COLLECTION_PAGE);
              }
            });
          } else {
            Get.offAllNamed(Routes.MY_COLLECTION_PAGE);
          }
        } else if (controller.isFromHome.isTrue) {
          Get.offAllNamed(Routes.MAIN_SCREEN);
        } else {
          showConfirmationDialog(
              context: context,
              text: "Are you sure you want to go home.",
              submitText: "Yes",
              cancelText: "Cancel",
              submitCallBack: () async {
                if (getIt<TimerService>().is40SecCompleted) {
                  await getIt<AdService>()
                      .getAd(adType: AdService.interstitialAd)
                      .then((value) {
                    if (!value) {
                      getIt<TimerService>().verifyTimer();
                      SystemChrome.setEnabledSystemUIMode(
                          SystemUiMode.edgeToEdge);
                      Get.offAllNamed(Routes.MAIN_SCREEN);
                    }
                  });
                  return await false;
                } else {
                  Get.offAllNamed(Routes.MAIN_SCREEN);
                }
              },
              cancelCallback: () {
                Get.back();
              });
        }
        return await true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: appTheme.primaryTheme,
          appBar: AppBar(
            backgroundColor: appTheme.primaryTheme,
            centerTitle: true,
            title: Text(
              "Toon Photo Editor",
              style: GoogleFonts.karla(
                fontSize: MySize.getHeight(24),
                fontWeight: FontWeight.w500,
              ),
            ),
            leading: GestureDetector(
              onTap: () async {
                (controller.isFromMyCollection.isTrue)
                    ? await getIt<AdService>()
                        .getAd(adType: AdService.interstitialAd)
                        .then((value) {
                        if (!value) {
                          getIt<TimerService>().verifyTimer();
                          SystemChrome.setEnabledSystemUIMode(
                              SystemUiMode.edgeToEdge);
                          Get.offAllNamed(Routes.MY_COLLECTION_PAGE);
                        }
                      })
                    : (controller.isFromHome.isTrue)
                        ? Get.offAllNamed(Routes.MAIN_SCREEN)
                        : showConfirmationDialog(
                            context: context,
                            text: "Are you sure you want to go home.",
                            submitText: "Yes",
                            cancelText: "Cancel",
                            submitCallBack: () async {
                              if (getIt<TimerService>().is40SecCompleted) {
                                await getIt<AdService>()
                                    .getAd(adType: AdService.interstitialAd)
                                    .then((value) {
                                  if (!value) {
                                    getIt<TimerService>().verifyTimer();
                                    SystemChrome.setEnabledSystemUIMode(
                                        SystemUiMode.edgeToEdge);
                                    Get.offAllNamed(Routes.MAIN_SCREEN);
                                  }
                                });
                              } else {
                                Get.offAllNamed(Routes.MAIN_SCREEN);
                              }
                            },
                            cancelCallback: () {
                              Get.back();
                            });
              },
              child: Container(
                width: MySize.getWidth(70),
                child: Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
            elevation: 0,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: MySize.getHeight(10)),
            child: Column(
              children: [
                SizedBox(
                  height: MySize.getHeight(45),
                ),
                Container(
                    child: controller.capturedImage != null
                        ? Container(
                            height: MySize.getHeight(400),
                            width: MySize.getWidth(320),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                    MySize.getHeight(24))),
                            child: PinchZoom(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(MySize.getHeight(24)),
                                child: Image.file(
                                  controller.capturedImage!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              resetDuration: const Duration(milliseconds: 100),
                              maxScale: 2.5,
                            ),
                          )
                        : Container()),
                SizedBox(
                  height: MySize.getHeight(25),
                ),
                Row(
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        if (!isNullEmptyOrFalse(
                            controller.capturedImage!.path)) {
                          await controller.flutterShareMe
                              .shareToInstagram(
                                  filePath: controller.capturedImage!.path,
                                  fileType: FileType.image)
                              .then((value) async {
                            if (value!.contains("Instagram not found")) {
                              await getIt<CustomDialogs>().getDialog(
                                  title: "Failed",
                                  desc:
                                      "Instagram is not installed on device.");
                            }
                          }).catchError((error) {
                            print(error);
                          });
                        }
                      },
                      child: SvgPicture.asset(
                        imagePath + "insta.svg",
                        height: MySize.getHeight(70),
                        width: MySize.getWidth(70),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        if (!isNullEmptyOrFalse(
                            controller.capturedImage!.path)) {
                          await controller.flutterShareMe
                              .shareToFacebook(
                            msg: "Hello",
                            url: controller.capturedImage!.path,
                          )
                              .catchError((error) {
                            print(error);
                          });
                        }
                      },
                      child: SvgPicture.asset(
                        imagePath + "fb.svg",
                        height: MySize.getHeight(70),
                        width: MySize.getWidth(70),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        if (!isNullEmptyOrFalse(
                            controller.capturedImage!.path)) {
                          await controller.flutterShareMe
                              .shareToWhatsApp(
                                  imagePath: controller.capturedImage!.path,
                                  fileType: FileType.image)
                              .then((value) async {
                            if (value!.contains("error")) {
                              await getIt<CustomDialogs>().getDialog(
                                  title: "Failed",
                                  desc: "Whatsapp not installed on device.");
                            }
                          });
                        }
                      },
                      child: SvgPicture.asset(
                        imagePath + "whatsapp.svg",
                        height: MySize.getHeight(70),
                        width: MySize.getWidth(70),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () {
                        // ignore: deprecated_member_use
                        Share.shareFiles([controller.capturedImage!.path])
                            .catchError((error) {
                          print(error);
                        });
                      },
                      child: SvgPicture.asset(
                        imagePath + "share.svg",
                        height: MySize.getHeight(70),
                        width: MySize.getWidth(70),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                Spacer(),
                (controller.connectivityResult == ConnectionState.none)
                    ? SizedBox()
                    : Yodo1MASBannerAd(
                        size: BannerSize.Banner,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
