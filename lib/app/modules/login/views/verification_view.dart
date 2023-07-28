import 'package:chat_client/app/modules/login/controllers/verification_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class VerificationView extends GetView<VerificationController> {
  VerificationView({Key? key}) : super(key: key);

  @override
  final controller = Get.find<VerificationController>();

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
                            'VERIFICATION',
                            style: GoogleFonts.rubik(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 80),
                      SizedBox(
                        child: VerificationBox(
                          length: 6,
                          textStyle: const TextStyle(color: Colors.white),
                          boxDecoration: BoxDecoration(
                            color: const Color.fromARGB(255, 89, 228, 209),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onChanged: (value) {
                            controller.setCode = value;
                          },
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
                          onPressed: () => controller.verif(),
                          child: Text(
                            'VERIFY',
                            style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 5,
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
                            side: const BorderSide(
                              width: 2,
                              color: Color.fromRGBO(89, 228, 209, 1.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () => controller.reSend(),
                          child: Text(
                            'RESEND',
                            style: GoogleFonts.montserrat(
                              color: const Color.fromRGBO(89, 228, 209, 1.0),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 5,
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

class VerificationBox extends StatefulWidget {
  final int length;
  final TextStyle textStyle;
  final BoxDecoration boxDecoration;
  final void Function(String)? onChanged;

  const VerificationBox({
    Key? key,
    required this.length,
    this.textStyle = const TextStyle(),
    this.boxDecoration = const BoxDecoration(),
    this.onChanged,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VerificationBoxState createState() => _VerificationBoxState();
}

class _VerificationBoxState extends State<VerificationBox> {
  late List<FocusNode> _focusNodes;
  late List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(widget.length, (index) => FocusNode());
    _controllers =
        List.generate(widget.length, (index) => TextEditingController());
  }

  @override
  void dispose() {
    for (var i = 0; i < widget.length; i++) {
      _focusNodes[i].dispose();
      _controllers[i].dispose();
    }
    super.dispose();
  }

  void clearAll() {
    for (var i = 0; i < widget.length; i++) {
      _controllers[i].clear();
    }
    _handleChange('');
  }

  void _handleChange(String value) {
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Row(
                  children: List.generate(
                    widget.length,
                    (index) => Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: Container(
                          alignment: Alignment.center,
                          decoration: widget.boxDecoration,
                          child: TextField(
                            controller: _controllers[index],
                            focusNode: _focusNodes[index],
                            maxLength: 1,
                            style: widget.textStyle,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              counterText: '',
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty &&
                                  index < widget.length - 1) {
                                _focusNodes[index].unfocus();
                                _focusNodes[index + 1].requestFocus();
                              }
                              String verificationCode = _getVerificationCode();
                              _handleChange(verificationCode);
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          TextButton(
            onPressed: clearAll,
            child: const Text(
              'clear all',
              style: TextStyle(
                color: Color.fromRGBO(89, 228, 209, 1.0),
                decoration: TextDecoration.underline,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
    );
  }

  String _getVerificationCode() {
    return _controllers.map((controller) => controller.text).join();
  }
}
