import 'dart:io';
import 'dart:typed_data';

import 'package:ai_image_enlarger/app/routes/app_pages.dart';
import 'package:ai_image_enlarger/constants/api_constants.dart';
import 'package:ai_image_enlarger/constants/sizeConstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../constants/color_constant.dart';
import '../../../../utilities/buttons.dart';
import '../controllers/share_file_controller.dart';

class ShareFileView extends GetView<ShareFileController> {
  const ShareFileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        (controller.isFromMyCollection.isTrue)
            ? Get.offAndToNamed(Routes.MY_COLLECTION_PAGE)
            : showConfirmationDialog(
                context: context,
                text: "Are you sure you want to go home.",
                submitText: "Yes",
                cancelText: "Cancel",
                submitCallBack: () {
                  Get.offAllNamed(Routes.HOME);
                },
                cancelCallback: () {
                  Get.back();
                });
        return await true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: appTheme.primaryTheme,
          appBar: AppBar(
            backgroundColor: appTheme.primaryTheme,
            centerTitle: true,
            title: Text("Name"),
            leading: GestureDetector(
              onTap: () {
                (controller.isFromMyCollection.isTrue)
                    ? Get.offAndToNamed(Routes.MY_COLLECTION_PAGE)
                    : showConfirmationDialog(
                        context: context,
                        text: "Are you sure you want to go home.",
                        submitText: "Yes",
                        cancelText: "Cancel",
                        submitCallBack: () {
                          Get.offAllNamed(Routes.HOME);
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: controller.capturedImage != null
                          ? Image.file(controller.capturedImage!)
                          : Container()),
                  SizedBox(
                    height: MySize.getHeight(25),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Share.shareFiles([controller.capturedImage!.path]);
                        },
                        child: SvgPicture.asset(
                          imagePath + "share.svg",
                          height: MySize.getHeight(70),
                          width: MySize.getWidth(70),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
