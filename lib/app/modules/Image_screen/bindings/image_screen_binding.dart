import 'package:get/get.dart';

import '../controllers/image_screen_controller.dart';

class ImageScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageScreenController>(
      () => ImageScreenController(),
    );
  }
}
