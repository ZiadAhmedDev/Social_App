import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../layout/social_layout/cubit/social_cubit.dart';
import '../../../../shared/components/components.dart';
import '../../../../shared/components/constants.dart';
import '../../login/login_screen.dart';
import '../cubit/social_register_cubit.dart';
import '../cubit/social_register_state.dart';

class OTPPage extends StatefulWidget {
  OTPPage({
    // this.verificationId,
    this.phoneNumber,
    super.key,
    // this.starWidget,
  });
  final String? phoneNumber;
  // final String? verificationId;
  // final dynamic starWidget;

  @override
  State<OTPPage> createState() => _OTPPageState();
}

class _OTPPageState extends State<OTPPage> {
  final otpController = TextEditingController();
  bool showLoading = false;
  String verificationFailedMessage = "";
  final FirebaseAuth auth = FirebaseAuth.instance;

  String myVerificationId = "";
  bool isTimeOut = false;

  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    // myVerificationId = SocialRegisterCubit.get(context).verificationId!;
    super.initState();
  }

  @override
  void dispose() {
    errorController!.isClosed;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialRegisterCubit, SocialRegisterState>(
      listener: (context, state) {},
      builder: (context, state) {
        // String? phoneNumber = SocialRegisterCubit.get(context).phoneNumber;
        return Scaffold(
          body: showLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    children: <Widget>[
                      const SizedBox(height: 30),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset("assets/otp.gif"),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          'Phone Number Verification',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8),
                        child: RichText(
                          text: TextSpan(
                            text: "Enter the code sent to ",
                            children: [
                              TextSpan(
                                  text: "+20 ${widget.phoneNumber}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                            ],
                            style: const TextStyle(
                                color: Colors.black54, fontSize: 15),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Form(
                        key: formKey,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 30),
                            child: PinCodeTextField(
                              appContext: context,
                              length: 6,
                              animationType: AnimationType.fade,
                              validator: (v) {
                                if (v!.length < 6) {
                                  return "you should enter all SMS code";
                                } else {
                                  return null;
                                }
                              },
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(5),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeFillColor: Colors.white,
                                inactiveFillColor: Colors.white,
                              ),
                              cursorColor: Colors.black,
                              animationDuration:
                                  const Duration(milliseconds: 300),
                              errorAnimationController: errorController,
                              controller: otpController,
                              keyboardType: TextInputType.number,
                              boxShadows: const [
                                BoxShadow(
                                  offset: Offset(0, 1),
                                  color: Colors.white,
                                  blurRadius: 10,
                                )
                              ],
                              onCompleted: (v) {
                                print("Completed");
                              },
                              onChanged: (value) {
                                print(value);
                                setState(() {
                                  currentText = value;
                                });
                              },
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          hasError ? "please resend the code!" : "",
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          const Text(
                            "Didn't receive the code? ",
                            style:
                                TextStyle(color: Colors.black54, fontSize: 15),
                          ),
                          // TextButton(
                          //     onPressed: isTimeOut
                          //         ? () async {
                          //             setState(() {
                          //               isTimeOut = false;
                          //             });
                          //             await FirebaseAuth.instance
                          //                 .verifyPhoneNumber(
                          //               phoneNumber:
                          //                   SocialRegisterCubit.get(context)
                          //                       .phoneNumber,
                          //               verificationCompleted:
                          //                   (PhoneAuthCredential credential) {},
                          //               verificationFailed:
                          //                   (FirebaseAuthException e) {
                          //                 setState(() {
                          //                   showLoading = false;
                          //                 });
                          //                 setState(() {
                          //                   verificationFailedMessage =
                          //                       e.message ?? "error!";
                          //                 });
                          //               },
                          //               codeSent: (String verificationId,
                          //                   int? resendToken) {
                          //                 setState(() {
                          //                   showLoading = false;
                          //                   myVerificationId = verificationId;
                          //                 });
                          //               },
                          //               timeout: const Duration(seconds: 10),
                          //               codeAutoRetrievalTimeout:
                          //                   (String verificationId) {
                          //                 setState(() {
                          //                   isTimeOut = true;
                          //                 });
                          //               },
                          //             );
                          //           }
                          //         : null,
                          //     child: const Text(
                          //       "RESEND",
                          //       style: TextStyle(
                          //           color: Color(0xFF91D3B3),
                          //           fontWeight: FontWeight.bold,
                          //           fontSize: 16),
                          //     ))
                        ],
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 30),
                        decoration: BoxDecoration(
                            color: Colors.green.shade300,
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.green.shade200,
                                  offset: const Offset(1, -2),
                                  blurRadius: 5),
                              BoxShadow(
                                  color: Colors.green.shade200,
                                  offset: const Offset(-1, 2),
                                  blurRadius: 5)
                            ]),
                        child: ButtonTheme(
                          height: 50,
                          child: TextButton(
                            onPressed: isTimeOut
                                ? null
                                : () async {
                                    formKey.currentState!.validate();
                                    // conditions for validatingRr
                                    // if (currentText.length != 6 ||
                                    //     currentText != "123456") {
                                    //   errorController!.add(ErrorAnimationType
                                    //       .shake); // Triggering error shake animation
                                    //   setState(() => hasError = true);
                                    // } else {
                                    //   setState(
                                    //     () {
                                    //       hasError = false;
                                    //     },
                                    //   );
                                    //   setState(() {
                                    //     showLoading = true;
                                    //   });
                                    // try {
                                    //   SocialRegisterCubit.get(context)
                                    //       .checkIsVerified(
                                    //           otpController.text);
                                    // if (SocialRegisterCubit.get(context)
                                    //         .verification ==
                                    //     true) {
                                    //   navigateTo(context, LoginScreen());
                                    // }
                                    // } on FirebaseAuthException catch (e) {
                                    //   showToaster(
                                    //       message: verificationFailedMessage,
                                    //       state: ToasterState.error);
                                    // }
                                    //   setState(() {
                                    //     showLoading = false;
                                    //   });
                                    // }
                                  },
                            child: Center(
                                child: TextButton(
                                    onPressed: () async {
                                      try {
                                        // if (formKey.currentState!.validate()) {
                                        //   SocialRegisterCubit.get(context)
                                        //       .userRegister(
                                        //     email: emailController.text,
                                        //     password: passwordController.text,
                                        //     name: nameController.text,
                                        //     phone: phoneController.text,
                                        //   );
                                        // }
                                        await SocialRegisterCubit.get(context)
                                            .checkIsVerified(
                                          otpController.text,
                                          email: emailControllerOtp!,
                                          password: passwordControllerOtp!,
                                          name: nameControllerOtp!,
                                          phone: phoneControllerOtp!,
                                        );
                                        if (SocialRegisterCubit.get(context)
                                                .verification ==
                                            true) {
                                          print(
                                              '-------------------------------------------');
                                          print(SocialRegisterCubit.get(context)
                                              .verification);
                                          print(
                                              '-------------------------------------------');
                                          navigateTo(context, LoginScreen());
                                        }
                                      } on FirebaseAuthException catch (e) {
                                        showToaster(
                                            message: e.message!,
                                            state: ToasterState.error);
                                      }
                                    },
                                    child: Text(
                                      "VERIFY".toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ))),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        verificationFailedMessage,
                        style: const TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
