import 'dart:convert';

import 'package:chat_client/app/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RegisterController extends GetxController {
  final userProvider = Get.find<UserProvider>();
  final sharedPref = GetStorage();
  final _email = ''.obs;
  final _name = ''.obs;
  final _username = ''.obs;
  final _buttonLoading = false.obs;

  get getButtonLoading => _buttonLoading.value;

  set email(String value) => _email.value = value;
  set name(String value) => _name.value = value;
  set username(String value) => _username.value = value;

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

  void register() async {
    if (_email.value.isNotEmpty && _name.value.isNotEmpty) {
      _buttonLoading.value = true;
      Response<dynamic> res = await userProvider.postUser(
          _name.value, _username.value, _email.value);
      dynamic data = res.bodyString;
      Map<String, dynamic> jsonData = jsonDecode(data);
      String message = jsonData['message'];
      if (res.statusCode == 201) {
        snackBar('Notification', message);
        _buttonLoading.value = false;
        sharedPref.write('username', _username.value);
        Get.toNamed('/verif');
      } else {
        snackBar('Notification', message);
        _buttonLoading.value = false;
      }
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
