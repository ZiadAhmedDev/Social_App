part of 'social_login_cubit.dart';

@immutable
abstract class SocialLoginState {}

class SocialLoginInitial extends SocialLoginState {}

class SocialLoginLoading extends SocialLoginState {}

class SocialLoginSuccess extends SocialLoginState {
  final String? uId;

  SocialLoginSuccess(this.uId);
}

class SocialLoginError extends SocialLoginState {
  final String error;

  SocialLoginError(this.error);
}

class ChangePasswordVisibility extends SocialLoginState {}

class SignInGoogleSuccess extends SocialLoginState {}
