import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class PhoneVerificationService {
  String? phoneNumber, verificationId;
  String? otp, authStatus = "";
  Future<void> verifyPhoneNumber(BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 15),
      verificationCompleted: (AuthCredential authCredential) {},
      verificationFailed: (FirebaseAuthException authException) {},
      codeSent: (String? verId, [int? forceCodeResent]) {
        verificationId = verId;
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  bool? verification;
  Future<void> checkIsVerified(String otp) async {
    verification = false;
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otp,
      ),
    );
    verification = (userCredential.user != null);
  }
}
