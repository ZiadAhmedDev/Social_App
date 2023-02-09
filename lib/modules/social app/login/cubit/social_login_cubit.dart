import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../models/social_create_user.dart';
import '../../../../shared/components/components.dart';
import '../../../../shared/components/constants.dart';

part 'social_login_state.dart';

class SocialLoginCubit extends Cubit<SocialLoginState> {
  SocialLoginCubit() : super(SocialLoginInitial());
  static SocialLoginCubit get(context) => BlocProvider.of(context);

  void userLogin({required String email, required String password}) async {
    emit(SocialLoginLoading());
    // UserCredential userCredential = await FirebaseAuth.instance
    //     .signInWithEmailAndPassword(email: email, password: password)
    //     .catchError((onError) {
    //   emit(SocialLoginError(onError.toString()));
    // });
    DocumentSnapshot<Map<String, dynamic>> user = await FirebaseFirestore
        .instance
        .collection(userCollection)
        .doc(email)
        .get();
    SocialUserModel userModel = SocialUserModel.fromJson(user.data()!);
    emit(SocialLoginSuccess(userModel.uId));
  }

  bool isPassword = true;
  IconData iconSuffix = Icons.visibility_outlined;

  void passwordVisibility() {
    isPassword = !isPassword;
    iconSuffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibility());
  }

  // GoogleSignInAccount? user;
  // Future signInGoogle() async {
  //   final googleUser = await GoogleSignIn().signIn();
  //   if (googleUser == null) {
  //     return showToaster(
  //         message: 'Error in Google Sign In', state: ToasterState.error);
  //   } else {
  //     user = googleUser;
  //   }
  //   final googleAuth = await googleUser.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
  //   await FirebaseAuth.instance.signInWithCredential(credential);
  //   emit(SignInGoogleSuccess());
  // }
}
