import 'package:chat_client/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends GetView {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      // color palete
      // rgb(89 228 209)
      decoration: const BoxDecoration(color: Colors.white),
      child: Center(
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(89, 228, 209, 1.0),
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(350)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FractionallySizedBox(
                widthFactor: 1.0,
                child: Container(
                  height: 200,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Text(
                    'Chat Me',
                    style: GoogleFonts.firaCode(
                      color: const Color.fromARGB(255, 89, 228, 209),
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w900,
                      fontSize: 50,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      side: const BorderSide(width: 2, color: Colors.white),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: Colors.white),
                  onPressed: () => Get.toNamed(Routes.SIGN_IN),
                  child: Text(
                    'SIGN IN',
                    style: GoogleFonts.montserrat(
                      color: const Color.fromARGB(255, 89, 228, 209),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 5,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      side: const BorderSide(width: 2, color: Colors.white),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      backgroundColor: const Color.fromARGB(255, 89, 228, 209)),
                  onPressed: () => Get.toNamed(Routes.REGISTER),
                  child: Text(
                    'REGISTER',
                    style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2),
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
