import 'dart:convert';

import 'package:chat_client/app/data/models/user_model.dart';
import 'package:chat_client/app/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SigninController extends GetxController {
  final sharedPref = GetStorage();
  final userProvider = Get.find<UserProvider>();
  final _email = ''.obs;
  final _buttonLoading = false.obs;

  get getButtonLoading => _buttonLoading.value;

  set email(String value) => _email.value = value;

  // GetSnackBar
  void snackBar(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color.fromARGB(255, 89, 228, 209),
      animationDuration: const Duration(milliseconds: 500),
    );
  }

  void signIn() async {
    _buttonLoading.value = true;
    sharedPref.write('email', _email.value);
    sharedPref.write('logged', false);
    Response<dynamic> response = await userProvider.signin(_email.value);
    dynamic data = response.bodyString;
    Map<String, dynamic> jsonData = jsonDecode(data);
    String message = jsonData['message'];
    String username = jsonData['username'];
    if (response.statusCode == 200) {
      snackBar('Notification', message);
      _buttonLoading.value = false;
      sharedPref.write('username', username);
      Get.toNamed('/verif');
    } else {
      snackBar('Notification', message);
      _buttonLoading.value = false;
    }
  }

  void getById(int id) async {
    User? user = await userProvider.getUser(id);
    print(user?.verificationCode);
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
