abstract class SocialRegisterState {}

class SocialRegisterInitial extends SocialRegisterState {}

class SocialRegisterLoading extends SocialRegisterState {}

class SocialCheckVerifiedLoading extends SocialRegisterState {}

class SocialRegisterSuccess extends SocialRegisterState {
  final String? uId;

  SocialRegisterSuccess(this.uId);
}

class SocialRegisterError extends SocialRegisterState {}

class SocialCreateUserLoading extends SocialRegisterState {}

class SocialCreateUserSuccess extends SocialRegisterState {}

class SocialCreateUserError extends SocialRegisterState {
  final String error;

  SocialCreateUserError(this.error);
}

class ChangePasswordVisibility extends SocialRegisterState {}

class OtpPhoneVerificationCompletedSuccess extends SocialRegisterState {}

class OtpPhoneVerificationCompletedError extends SocialRegisterState {}

class OtpPhoneCheckIsVerifiedSuccess extends SocialRegisterState {}
