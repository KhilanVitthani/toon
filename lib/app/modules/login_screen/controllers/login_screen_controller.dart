import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:http/http.dart' as http;
import '../../../../constants/api_constants.dart';
import '../../../../data/NetworkClient.dart';
import '../../../../main.dart';
import '../../../../utilities/progress_dialog_utils.dart';
import '../../../routes/app_pages.dart';

class LoginScreenController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isVisible = false.obs;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  callApiForLogin({
    required BuildContext context,
  }) {
    FocusManager.instance.primaryFocus!.unfocus();
    getIt.get<CustomDialogs>().showCircularDialog(context);
    Map<String, dynamic> dict = {};
    dict["userName"] = emailController.value.text;
    dict["password"] = passwordController.value.text;
    FormData formData = new FormData.fromMap(dict);

    // print(token);

    return NetworkClient.getInstance.callApi(
      context,
      baseUrl,
      ApiConstant.login,
      MethodType.Post,
      params: formData,
      successCallback: (response, message) {
        print("response:-$response");
        getIt.get<CustomDialogs>().hideCircularDialog(context);

        if (response["responseCode"] == 200) {
          print(response);
          // LogInResponse logInResponse = LogInResponse.fromJson(response);
          // if (logInResponse.data!.token != null) {
          //   box.write(
          //       ArgumentConstant.token, logInResponse.data!.token.toString());
          //   box.write(ArgumentConstant.password, passwordController.value.text);
          //   Get.offAllNamed(Routes.HOME);
          // } else {
          //   getIt
          //       .get<CustomDialogs>()
          //       .getDialog(title: "Failed", desc: response["message"]);
          // }
        } else {
          getIt
              .get<CustomDialogs>()
              .getDialog(title: "Failed", desc: response["message"]);
        }
      },
      failureCallback: (status, message) {
        getIt.get<CustomDialogs>().hideCircularDialog(context);

        getIt<CustomDialogs>().getDialog(title: "Failed", desc: message);
        print(" error");
      },
    );
  }
}
