import 'package:get/get.dart';

import '../controllers/my_collection_page_controller.dart';

class MyCollectionPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyCollectionPageController>(
      () => MyCollectionPageController(),
    );
  }
}
