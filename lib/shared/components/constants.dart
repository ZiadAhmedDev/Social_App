// // api

// base api= https://newsapi.org/
// Method = v2/top-headlines
// query = ?country=eg&category=business&apiKey=aeccb357c25543fda5223023554ad8e3

import 'dart:ui';

import 'package:news_app/main.dart';

import '../../modules/social app/login/login_screen.dart';
import '../network/local/cache_helper.dart';
import 'components.dart';

// void signOut(context) {
//   CacheHelper.sharedPreferences?.remove('token').then((value) {
//     if (value) {
//       token = '';
//       ShopCubit.get(context).currentIndex = 0;
//       bool? isDark = CacheHelper.getData(key: 'isDark');
//       return navigateAndReplacement(
//           context, SocialApp(isDark: isDark!, startWidget: LoginScreen()));
//     }
//   });
// }

void signOut(context) {
  CacheHelper.sharedPreferences?.remove('uId').then((value) {
    if (value) {
      uId = '';
      return navigateAndReplacement(context, LoginScreen());
    }
  });
}

void printFullText(String? text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text!).forEach((match) => print(match.group(0)));
}

String? token = '';
String? uId = '';

const kPrimaryColor = Color(0xff2B475E);

String userCollection = 'users';
String postCollection = 'posts';
String likesCollection = 'likes';
String commentsCollection = 'Comment';
String chatsCollection = 'chats';
String messageCollection = 'message';
