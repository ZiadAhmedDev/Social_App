part of 'social_cubit.dart';

@immutable
abstract class SocialState {}

class SocialInitial extends SocialState {}

class SocialLoadingGetUserData extends SocialState {}

class SocialSuccessGetUserData extends SocialState {}

class SocialErrorGetUserData extends SocialState {
  final String error;

  SocialErrorGetUserData(this.error);
}

class SocialLoadingGetNewPosts extends SocialState {}

class SocialSuccessGetNewPosts extends SocialState {}

class SocialErrorGetNewPosts extends SocialState {
  final String error;

  SocialErrorGetNewPosts(this.error);
}

class SocialSuccessGetAllUsers extends SocialState {}

class SocialErrorGetAllUsers extends SocialState {
  final String error;

  SocialErrorGetAllUsers(this.error);
}

class SocialSuccessLikePosts extends SocialState {}

class SocialErrorLikePosts extends SocialState {
  final String error;

  SocialErrorLikePosts(this.error);
}

class SocialSuccessCommentPosts extends SocialState {}

class SocialErrorCommentPosts extends SocialState {
  final String error;

  SocialErrorCommentPosts(this.error);
}

class SocialNewPost extends SocialState {}

class SocialChangeScreen extends SocialState {}

class SocialProfileImagePickedSuccessState extends SocialState {}

class SocialProfileImagePickedErrorState extends SocialState {}

class SocialCoverImagePickedSuccessState extends SocialState {}

class SocialCoverImagePickedErrorState extends SocialState {}

class SocialProfileImageUploadSuccessState extends SocialState {}

class SocialProfileImageUploadErrorState extends SocialState {}

class SocialCoverImageUploadSuccessState extends SocialState {}

class SocialCoverImageUploadErrorState extends SocialState {}

class SocialUpdateUserSettingLoadingState extends SocialState {}

class SocialUpdateUserSettingErrorState extends SocialState {}

class SocialUploadPostImageSuccessState extends SocialState {}

class SocialUploadPostImageErrorState extends SocialState {}

class SocialRemovePostImageSuccessState extends SocialState {}

class SocialPostImageUploadLoadingState extends SocialState {}

class SocialPostImageUploadErrorState extends SocialState {}

class SocialCreateNewPostLoadingState extends SocialState {}

class SocialCreateNewPostSuccessState extends SocialState {}

class SocialCreateNewPostErrorState extends SocialState {}

class SocialCreateNewCommentSuccessState extends SocialState {}

class SocialCreateNewCommentErrorState extends SocialState {}

class SocialSendMessageSuccessState extends SocialState {}

class SocialSendMessageErrorState extends SocialState {}

class SocialGetMessageSuccessState extends SocialState {}

class ThemeChange extends SocialState {}
