import 'package:ai_image_enlarger/app/routes/app_pages.dart';
import 'package:ai_image_enlarger/constants/api_constants.dart';
import 'package:ai_image_enlarger/constants/color_constant.dart';
import 'package:ai_image_enlarger/constants/sizeConstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/setting_page_controller.dart';

class SettingPageView extends GetView<SettingPageController> {
  const SettingPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAndToNamed(Routes.HOME);
        return await true;
      },
      child: SafeArea(
        child: Scaffold(
            backgroundColor: appTheme.primaryTheme,
            appBar: AppBar(
              backgroundColor: appTheme.primaryTheme,
              elevation: 0,
              leading: GestureDetector(
                onTap: () {
                  Get.offAndToNamed(Routes.HOME);
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
                    context: context,
                    image: "shareicon.svg",
                    name: "Share",
                  ),
                  settingTile(
                    context: context,
                    image: "rateus.svg",
                    name: "Rate Us!",
                  ),
                  settingTile(
                    context: context,
                    image: "policy.svg",
                    name: "Privacy Policy",
                  ),
                  settingTile(
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
      required String image}) {
    return Padding(
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
    );
  }
}
