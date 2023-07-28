import 'package:chat_client/app/modules/login/views/register_view.dart';
import 'package:chat_client/app/modules/login/views/signin_view.dart';
import 'package:chat_client/app/modules/login/views/verification_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: non_constant_identifier_names
  static final String INITIAL = (GetStorage().read('logged') == false ||
          GetStorage().read('logged') == null)
      ? Routes.LOGIN
      : Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_IN,
      page: () => SiginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.VERIF,
      page: () => VerificationView(),
      binding: LoginBinding(),
    ),
  ];
}
