import 'package:get/get.dart';

import 'package:chat_client/app/data/providers/user_provider.dart';
import 'package:chat_client/app/modules/login/controllers/register_controller.dart';
import 'package:chat_client/app/modules/login/controllers/signin_controller.dart';
import 'package:chat_client/app/modules/login/controllers/verification_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VerificationController>(
      () => VerificationController(),
    );
    Get.lazyPut<SigninController>(
      () => SigninController(),
    );
    Get.lazyPut<RegisterController>(
      () => RegisterController(),
    );
    Get.lazyPut<VerificationController>(
      () => VerificationController(),
    );
    Get.lazyPut<UserProvider>(() => UserProvider());
  }
}
