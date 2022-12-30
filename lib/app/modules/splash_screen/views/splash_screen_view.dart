import 'package:ai_image_enlarger/constants/api_constants.dart';
import 'package:ai_image_enlarger/constants/color_constant.dart';
import 'package:ai_image_enlarger/constants/sizeConstant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetWidget<SplashScreenController> {
  const SplashScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    MySize().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: appTheme.primaryTheme,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(imagePath + "icon1.png"),
              Text(
                "Toon Photo Editor",
                style: GoogleFonts.karla(
                  fontSize: MySize.getHeight(28),
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "Make you avtar using powerful AI tool",
                style: GoogleFonts.karla(
                  fontSize: MySize.getHeight(16),
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
