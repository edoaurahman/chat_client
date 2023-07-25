import 'package:chat_client/app/modules/login/controllers/signin_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SiginView extends GetView<SigninController> {
  SiginView({Key? key}) : super(key: key);

  @override
  final controller = Get.find<SigninController>();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.only(top: 60),
        decoration: const BoxDecoration(
          color: Color.fromRGBO(89, 228, 209, 1.0),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1.0,
                        child: Container(
                          height: 150,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color.fromARGB(255, 89, 228, 209),
                          ),
                          child: Text(
                            'SIGN IN',
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => controller.email = value,
                        decoration: const InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(89, 228, 209, 1.0),
                              width: 2.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            borderSide: BorderSide(
                              color: Color.fromRGBO(89, 228, 209, 1.0),
                              width: 2.0,
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(
                              left: 30,
                              right: 10,
                            ), // Menambahkan jarak di sebelah kiri prefixIcon
                            child: Icon(
                              Icons.email,
                              color: Color.fromRGBO(89, 228, 209, 1.0),
                            ),
                          ),
                          hintText: 'EMAIL',
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(89, 228, 209, 1.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            side: const BorderSide(
                              width: 2,
                              color: Color.fromRGBO(89, 228, 209, 1.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            backgroundColor:
                                const Color.fromRGBO(89, 228, 209, 1.0),
                          ),
                          onPressed: () {
                            if (!controller.getButtonLoading) {
                              controller.signIn();
                            }
                          },
                          child: Obx(
                            () => controller.getButtonLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 7.0,
                                  )
                                : Text(
                                    'SIGN IN',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 5,
                                    ),
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 20,
                left: 20,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromRGBO(89, 228, 209, 1.0),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
