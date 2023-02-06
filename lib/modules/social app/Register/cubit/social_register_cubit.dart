import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shared/components/constants.dart';
import '../../../../models/social_create_user.dart';
import 'social_register_state.dart';

class SocialRegisterCubit extends Cubit<SocialRegisterState> {
  SocialRegisterCubit() : super(SocialRegisterInitial());

  static SocialRegisterCubit get(context) => BlocProvider.of(context);
  void userRegister(
      {required String email,
      required String password,
      required String name,
      required String phone}) {
    emit(SocialRegisterLoading());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((value) {
      // printFullText(value.user!.email.toString());
      // printFullText(value.user!.uid.toString());
      createUser(
        email: email,
        name: name,
        phone: phone,
        uId: value.user!.uid,
        isEmailVerified: value.user!.emailVerified,
      );
      uId = value.user!.uid;

      emit(SocialRegisterSuccess(uId));
    }).catchError((error) {
      printFullText(error.toString());
      emit(SocialRegisterError(error.toString()));
    });
  }

  void createUser({
    required String email,
    required String name,
    required String uId,
    required String phone,
    String? bio,
    String? image,
    String? cover,
    bool? isEmailVerified,
  }) {
    emit(SocialCreateUserLoading());
    var modelUser = SocialUserModel(
      email: email,
      name: name,
      phone: phone,
      uId: uId,
      bio: 'Write bio here.....',
      image:
          'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?w=826&t=st=1674657751~exp=1674658351~hmac=2dd02bc2588474b028451a4fb84192c789d286bbc8af955a7091cb2d65ce3d4d',
      cover:
          'https://img.freepik.com/free-vector/designer-collection-concept_23-2148508641.jpg?w=1380&t=st=1674657679~exp=1674658279~hmac=52a6850b6e005a42118bfe146b77783461a29015dcb4c92f54eebd4974af02a7',
      isEmailVerified: isEmailVerified ?? false,
    );
    FirebaseFirestore.instance
        .collection(userCollection)
        .doc(uId)
        .set(modelUser.toMap())
        .then((value) {
      emit(SocialCreateUserSuccess());
    }).catchError((onError) {
      printFullText(onError.toString());
      emit(SocialRegisterError(onError.toString()));
    });
  }

  bool isPassword = true;
  IconData iconSuffix = Icons.visibility_outlined;

  void passwordVisibility() {
    isPassword = !isPassword;
    iconSuffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangePasswordVisibility());
  }
}
