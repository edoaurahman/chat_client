import 'dart:convert';

import 'package:chat_client/app/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class VerificationController extends GetxController {
  final sharedPref = GetStorage();
  final userProvider = Get.find<UserProvider>();
  final _code = ''.obs;

  set setCode(String value) => _code.value = value;

  void snackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color.fromARGB(255, 89, 228, 209),
      animationDuration: const Duration(milliseconds: 500),
    );
  }

  void verif() async {
    if (_code.value.length == 6) {
      final email = sharedPref.read('email');
      dynamic res = await userProvider.verif(email, _code.value);
      Map<String, dynamic> jsonData = jsonDecode(res.bodyString);
      String message = jsonData['message'];
      if (res.statusCode == 202) {
        sharedPref.write('logged', true);
        Get.offAllNamed('/home');
      } else {
        snackBar('Notification', message);
      }
    }
  }

  void reSend() async {
    final email = sharedPref.read('email');
    Response<dynamic> response = await userProvider.signin(email);
    dynamic data = response.bodyString;
    Map<String, dynamic> jsonData = jsonDecode(data);
    String message = jsonData['message'];
    if (response.statusCode == 200) {
      snackBar('Notification', message);
      Get.toNamed('/verif');
    } else {
      snackBar('Notification', message);
    }
  }

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
}
