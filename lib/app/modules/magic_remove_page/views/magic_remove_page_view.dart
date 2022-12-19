import 'package:ai_image_enlarger/Image_psinter/image_painter_file.dart';
import 'package:ai_image_enlarger/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../Image_psinter/image_painter.dart';
import '../controllers/magic_remove_page_controller.dart';

class MagicRemovePageView extends GetView<MagicRemovePageController> {
  final _imageKey = GlobalKey<ImagePainterState>();
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.offAndToNamed(Routes.HOME);
        return await true;
      },
      child: SafeArea(
        child: Scaffold(
          key: _key,
          body: ImagePainter.file(
            controller.image!,
            key: _imageKey,
            scalable: false,
            initialStrokeWidth: 30,
            initialColor: Color(0xff4a47ff).withOpacity(0.07),
            initialPaintMode: PaintMode.freeStyle,
          ),
        ),
      ),
    );
  }
}
