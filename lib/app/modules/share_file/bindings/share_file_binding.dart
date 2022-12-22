import 'package:get/get.dart';

import '../controllers/share_file_controller.dart';

class ShareFileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareFileController>(
      () => ShareFileController(),
    );
  }
}
