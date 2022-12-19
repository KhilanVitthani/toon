import 'package:get/get.dart';

import '../controllers/magic_remove_page_controller.dart';

class MagicRemovePageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MagicRemovePageController>(
      () => MagicRemovePageController(),
    );
  }
}
