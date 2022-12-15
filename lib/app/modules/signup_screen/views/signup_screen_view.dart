import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/signup_screen_controller.dart';

class SignupScreenView extends GetView<SignupScreenController> {
  const SignupScreenView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignupScreenView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'SignupScreenView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
