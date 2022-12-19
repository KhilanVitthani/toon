import 'package:get/get.dart';

import '../modules/Image_screen/bindings/image_screen_binding.dart';
import '../modules/Image_screen/views/image_screen_view.dart';
import '../modules/forget_password/bindings/forget_password_binding.dart';
import '../modules/forget_password/views/forget_password_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login_screen/bindings/login_screen_binding.dart';
import '../modules/login_screen/views/login_screen_view.dart';
import '../modules/magic_remove_page/bindings/magic_remove_page_binding.dart';
import '../modules/magic_remove_page/bindings/magic_remove_page_binding.dart';
import '../modules/magic_remove_page/views/magic_remove_page_view.dart';
import '../modules/magic_remove_page/views/magic_remove_page_view.dart';
import '../modules/signup_screen/bindings/signup_screen_binding.dart';
import '../modules/signup_screen/views/signup_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_SCREEN,
      page: () => const LoginScreenView(),
      binding: LoginScreenBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP_SCREEN,
      page: () => const SignupScreenView(),
      binding: SignupScreenBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => const ForgetPasswordView(),
      binding: ForgetPasswordBinding(),
    ),
    GetPage(
      name: _Paths.IMAGE_SCREEN,
      page: () => const ImageScreenView(),
      binding: ImageScreenBinding(),
    ),
    GetPage(
      name: _Paths.MAGIC_REMOVE_PAGE,
      page: () => const MagicRemovePageView(),
      binding: MagicRemovePageBinding(),
      children: [
        GetPage(
          name: _Paths.MAGIC_REMOVE_PAGE,
          page: () => const MagicRemovePageView(),
          binding: MagicRemovePageBinding(),
        ),
      ],
    ),
  ];
}
