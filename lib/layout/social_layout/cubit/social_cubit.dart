import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:news_app/modules/social%20app/chat/chat_screen.dart';
import 'package:news_app/modules/social%20app/users/users_screen.dart';
import 'package:news_app/modules/social%20app/new_post/new_post_screen.dart';
import 'package:news_app/modules/social%20app/setting/setting_screen.dart';
import 'package:news_app/modules/social%20app/feeds/feeds_screen.dart';
import '../../../models/message_mode.dart';
import '../../../models/new_post.dart';
import '../../../models/social_create_user.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/local/cache_helper.dart';

part 'social_state.dart';

class SocialCubit extends Cubit<SocialState> {
  SocialCubit() : super(SocialInitial());

  static SocialCubit get(context) => BlocProvider.of(context);

  SocialUserModel? socialModel;

  Future<void> getUserData() async {
    emit(SocialLoadingGetUserData());
    if (uId != null) {
      DocumentSnapshot<Map<String, dynamic>> res = await FirebaseFirestore
          .instance
          .collection(userCollection)
          .doc(uId)
          .get()
          .catchError((error) {
        printFullText(error.toString());
        emit(SocialErrorGetUserData(error.toString()));
      });
      socialModel = SocialUserModel.fromJson(res.data()!);
      printFullText('-------------------------------');
      printFullText(socialModel!.email.toString());
      printFullText('-------------------------------');
      printFullText(res.id.toString());
      printFullText('-------------------------------');
      emit(SocialSuccessGetUserData());
    }
  }

  int currentIndex = 0;

  List<Widget> screen = [
    FeedsLayout(),
    const ChatLayout(),
    NewPostLayout(),
    const UsersLayout(),
    const SettingLayout(),
  ];
  List<String> titles = [
    'Home',
    'Chats',
    'New Post',
    'Users',
    'Setting',
  ];

  void changeScreenIndex(int index) {
    if (index == 1) {
      getAllUsers();
    }
    if (index == 2) {
      emit(SocialNewPost());
    } else {
      currentIndex = index;
      emit(SocialChangeScreen());
    }
  }

  bool isDark = false;

  void changeThemeMode({bool? fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(ThemeChange());
    } else {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(ThemeChange());
      });
    }
  }

  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      uploadProfileImage();
      emit(SocialProfileImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialProfileImagePickedErrorState());
    }
  }

  File? coverImage;
  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      print(pickedFile.path);
      uploadCoverImage();
      printFullText('-------------------------------------');
      printFullText(coverImage.toString());
      printFullText('-------------------------------------');
      emit(SocialCoverImagePickedSuccessState());
    } else {
      print('No image selected.');
      emit(SocialCoverImagePickedErrorState());
    }
  }

  String? profileImageUrl = '';
  void uploadProfileImage() {
    FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        profileImageUrl = value;
        printFullText(value.toString());
        emit(SocialProfileImageUploadSuccessState());
      }).catchError((onError) {
        printFullText(onError.toString());

        emit(SocialProfileImageUploadErrorState());
      });
    }).catchError((onError) {
      printFullText(onError.toString());

      emit(SocialProfileImageUploadErrorState());
    });
  }

  String? coverImageUrl = '';
  void uploadCoverImage() {
    FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        coverImageUrl = value;
        printFullText('-------------------------------------');
        printFullText(value.toString());
        printFullText('-------------------------------------');
        emit(SocialCoverImageUploadSuccessState());
      }).catchError((onError) {
        emit(SocialCoverImageUploadErrorState());
      });
    }).catchError((onError) {
      emit(SocialCoverImageUploadErrorState());
    });
  }

  void updateUserSetting({
    required String name,
    required String bio,
    required String phone,
  }) {
    emit(SocialUpdateUserSettingLoadingState());
    SocialUserModel modelUser = SocialUserModel(
      name: name,
      bio: bio,
      phone: phone,
      email: socialModel!.email,
      uId: socialModel!.uId,
      image: profileImageUrl!.isEmpty || profileImageUrl == null
          ? socialModel!.image
          : profileImageUrl,
      cover: coverImageUrl!.isEmpty || coverImageUrl == null
          ? socialModel!.cover
          : coverImageUrl,
      isEmailVerified: socialModel!.isEmailVerified ?? false,
    );
    FirebaseFirestore.instance
        .collection(userCollection)
        .doc(modelUser.uId)
        .update(modelUser.toMap())
        .then((value) {
      printFullText(profileImageUrl);
      printFullText(
          'coverImageUrlcoverImageUrlcoverImageUrlcoverImageUrlcoverImageUrl');
      printFullText(coverImageUrl);
      printFullText(
          'coverImageUrlcoverImageUrlcoverImageUrlcoverImageUrlcoverImageUrl');
      getUserData();
    }).catchError((onError) {
      printFullText(onError.toString());
      emit(SocialUpdateUserSettingErrorState());
    });
  }

  File? postImage;
  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(SocialUploadPostImageSuccessState());
    } else {
      print('No image selected.');
      emit(SocialUploadPostImageErrorState());
    }
  }

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageSuccessState());
  }

  void uploadPostImage({
    String? text,
    String? date,
  }) {
    emit(SocialPostImageUploadLoadingState());
    FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createNewPost(date: date, text: text, postImage: value);
        printFullText(value.toString());
      }).catchError((onError) {
        printFullText(onError.toString());
        emit(SocialPostImageUploadErrorState());
      });
    }).catchError((onError) {
      printFullText(onError.toString());
      emit(SocialPostImageUploadErrorState());
    });
  }

  void createNewPost({
    required String? date,
    required String? text,
    String? postImage,
  }) {
    emit(SocialCreateNewPostLoadingState());
    NewPostModel postModel = NewPostModel(
        name: socialModel!.name,
        uId: socialModel!.uId,
        image: profileImageUrl!.isEmpty || profileImageUrl == null
            ? socialModel!.image
            : profileImageUrl,
        postImage: postImage ?? '',
        date: date,
        text: text);
    FirebaseFirestore.instance
        .collection(postCollection)
        .add(postModel.toMap())
        .then((value) {
      printFullText(postImage.toString());
      printFullText(text.toString());
      emit(SocialCreateNewPostSuccessState());
    }).catchError((onError) {
      printFullText(onError.toString());
      emit(SocialCreateNewPostErrorState());
    });
  }

  List<NewPostModel> postList = [];
  List<int> likes = [];
  // List<int> comments = [];
  List<String> postId = [];
  Future<void> getNewPosts() async {
    emit(SocialLoadingGetNewPosts());
    await FirebaseFirestore.instance
        .collection(postCollection)
        .orderBy('date', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        element.reference.collection(likesCollection).get().then((value) {
          print(value.docs.length.toString());
          likes.add(value.docs.length);
          emit(SocialSuccessGetNewPosts());
        }).catchError((onError) {});
        // element.reference.collection(commentsCollection).get().then((value) {
        //   comments.add(value.docs.length);
        // }).catchError((onError) {});
        postId.add(element.id);
        postList.add(NewPostModel.fromJson(element.data()));
        emit(SocialSuccessGetNewPosts());
      });
    }).catchError((onError) {
      emit(SocialErrorGetNewPosts(onError.toString()));
    });
  }

  void addLikes(String postId) {
    FirebaseFirestore.instance
        .collection(postCollection)
        .doc(postId)
        .collection(likesCollection)
        .doc(socialModel!.uId)
        .set({likesCollection: true}).then((value) {
      emit(SocialSuccessLikePosts());
    }).catchError((onError) {
      emit(SocialErrorLikePosts(onError.toString()));
    });
  }

  List<SocialUserModel> userList = [];
  void getAllUsers() {
    if (userList.isEmpty)
      FirebaseFirestore.instance
          .collection(userCollection)
          .orderBy('name', descending: false)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != socialModel!.uId)
            userList.add(SocialUserModel.fromJson(element.data()));
        });
        emit(SocialSuccessGetAllUsers());
      }).catchError((onError) {
        emit(SocialErrorGetAllUsers(onError.toString()));
      });
  }

  void sendMessage(
      {required String receiverUid,
      required String date,
      required String text}) {
    MessageModel messageModel = MessageModel(
        date: date,
        receiverUid: receiverUid,
        senderUid: socialModel!.uId,
        text: text);
    //set my chat
    FirebaseFirestore.instance
        .collection(userCollection)
        .doc(socialModel!.uId)
        .collection(chatsCollection)
        .doc(receiverUid)
        .collection(messageCollection)
        .add(messageModel.toMap())
        .then((value) {
      // printFullText(socialModel!.uId.toString());
      emit(SocialSendMessageSuccessState());
    }).catchError((onError) {
      emit(SocialSendMessageErrorState());
    });
    //set Friend chat
    FirebaseFirestore.instance
        .collection(userCollection)
        .doc(receiverUid)
        .collection(chatsCollection)
        .doc(socialModel!.uId)
        .collection(messageCollection)
        .add(messageModel.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessState());
    }).catchError((onError) {
      emit(SocialSendMessageErrorState());
    });
  }

  List<MessageModel> message = [];

  void getMessages({
    required String receiverUid,
  }) {
    FirebaseFirestore.instance
        .collection(userCollection)
        .doc(socialModel!.uId)
        .collection(chatsCollection)
        .doc(receiverUid)
        .collection(messageCollection)
        .orderBy('date')
        .snapshots()
        .listen((event) {
      message = [];
      event.docs.forEach((element) {
        message.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessageSuccessState());
    });
  }
}
