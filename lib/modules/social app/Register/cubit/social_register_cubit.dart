import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/social_create_user.dart';
import '../../../../shared/components/components.dart';
import '../../../../shared/components/constants.dart';
import 'social_register_state.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterState> {
  SocialRegisterCubit() : super(SocialRegisterInitial());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);
  // void userRegister(
  //     {required String email,
  //     required String password,
  //     required String name,
  //     required String phone}) {
  //   emit(SocialRegisterLoading());
  // }

  bool? verification;
  Future<void> checkIsVerified(String otp,
      {required String email,
      required String password,
      required String name,
      required String phone}) async {
    emit(SocialRegisterLoading());
    verification = false;
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(
      PhoneAuthProvider.credential(
        verificationId: verificationId!,
        smsCode: otp,
      ),
    );
    emit(SocialCheckVerifiedLoading());

    verification = (userCredential.user != null);
    print('------------------------------');
    print(verification);
    print('------------------------------');
    emit(SocialRegisterLoading());
    if (verification!) {
      UserCredential user =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //     .catchError((error) {
      //   printFullText(error.toString());
      //   emit(SocialRegisterError());
      // });
      print(user.user);
      emit(SocialCheckVerifiedLoading());
      if (user.user != null) {
        await createUser(
          email: email,
          name: name,
          phone: phone,
          password: password,
          uId: phone,
          // isEmailVerified: user.user!.emailVerified,
        );
        await createUser(
          email: email,
          name: name,
          password: password,
          phone: phone,
          uId: email,
          // isEmailVerified: user.user!.emailVerified,
        );
      }
      emit(SocialRegisterLoading());

      uId = user.user!.uid;
      print('----------------------------------');
      print('uId:${uId}');
      print("user.phoneNumber:{user.user!.phoneNumber!}");
      print('----------------------------------');

      emit(SocialRegisterSuccess(uId));
    }
    emit(OtpPhoneCheckIsVerifiedSuccess());
  }

  Future<void> createUser({
    required String email,
    required String name,
    required String uId,
    required String phone,
    required String password,
    String? bio,
    String? image,
    String? cover,
    // bool? isEmailVerified,
  }) async {
    emit(SocialCreateUserLoading());
    var modelUser = SocialUserModel(
      email: email,
      name: name,
      password: password,
      phone: phone,
      uId: uId,
      bio: 'Write bio here.....',
      image:
          'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?w=826&t=st=1674657751~exp=1674658351~hmac=2dd02bc2588474b028451a4fb84192c789d286bbc8af955a7091cb2d65ce3d4d',
      cover:
          'https://img.freepik.com/free-vector/designer-collection-concept_23-2148508641.jpg?w=1380&t=st=1674657679~exp=1674658279~hmac=52a6850b6e005a42118bfe146b77783461a29015dcb4c92f54eebd4974af02a7',
      // isEmailVerified: isEmailVerified ?? false,
    );
    await FirebaseFirestore.instance
        .collection(userCollection)
        .doc(uId)
        .set(modelUser.toMap());
    //     .catchError((onError) {
    //   printFullText(onError.toString());
    //   emit(SocialRegisterError());
    // });
    emit(SocialCreateUserSuccess());
  }

  bool isPassword = true;
  IconData iconSuffix = Icons.visibility_outlined;

  void passwordVisibility() {
    isPassword = !isPassword;
    iconSuffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibility());
  }

  String? phoneNumber;
  String? otp, authStatus = "";
  Future<void> verifyPhoneNumber(
      BuildContext context, String? phoneNumber) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+20${phoneNumber}',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (AuthCredential authCredential) {
        emit(OtpPhoneVerificationCompletedSuccess());
      },
      verificationFailed: (FirebaseAuthException authException) {
        showToaster(message: authException.message!, state: ToasterState.error);
        emit(OtpPhoneVerificationCompletedError());
      },
      codeSent: (String? verId, [int? forceCodeResent]) {
        log('verificationId.toString()verificationId.toString()verificationId.toString()verificationId.toString()verificationId.toString()');
        verificationId = verId;
        print(
            'verificationId.toString()verificationId.toString()verificationId.toString()verificationId.toString()verificationId.toString()');
        print(verId.toString());
        print(
            'verificationId.toString()verificationId.toString()verificationId.toString()verificationId.toString()verificationId.toString()');
        emit(OtpPhoneVerificationCompletedSuccess());
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  // bool? verification;
  // Future<void> checkIsVerified(String otp) async {
  //   verification = false;
  //   UserCredential userCredential =
  //       await FirebaseAuth.instance.signInWithCredential(
  //     PhoneAuthProvider.credential(
  //       verificationId: verificationId!,
  //       smsCode: otp,
  //     ),
  //   );
  //   verification = (userCredential.user != null);
  //   emit(OtpPhoneCheckIsVerifiedSuccess());
  // }
}
