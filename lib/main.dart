import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shared/bloc_observer.dart';
import 'package:news_app/shared/components/constants.dart';
import 'package:news_app/shared/network/local/cache_helper.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';
import 'package:news_app/shared/styles/themes.dart';
import 'layout/social_layout/cubit/social_cubit.dart';
import 'layout/social_layout/social_layout.dart';
import 'modules/social app/Register/cubit/social_register_cubit.dart';
import 'modules/social app/Register/phone_auth/otp_screen.dart';
import 'modules/social app/login/cubit/social_login_cubit.dart';
import 'modules/social app/login/login_screen.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool? isDark = CacheHelper.getData(key: 'isDark') ?? false;
  Widget? widget;
  uId = CacheHelper.getData(key: 'uId');
  var token = await FirebaseMessaging.instance.getToken();
  print(token.toString());
  print(
      'uId.toString()uId.toString()uId.toString()uId.toString()uId.toString()uId.toString()uId.toString()');
  print(uId.toString());
  print(
      'uId.toString()uId.toString()uId.toString()uId.toString()uId.toString()uId.toString()uId.toString()');

  await FirebaseMessaging.instance.subscribeToTopic('allDevices');

  FirebaseMessaging.onMessage.listen((event) {
    print(event.data);
    print('from out side');
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print(event.data);
    print('open notification');
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  if (uId != null) {
    widget = SocialLayout();
  } else {
    widget = LoginScreen();
  }

  runApp(
    SocialApp(isDark: isDark!, startWidget: widget), // Wrap your app
  );
}

class SocialApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;
  const SocialApp({super.key, required this.isDark, required this.startWidget});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SocialCubit()..getNewPosts(),
        ),
        BlocProvider(
          create: (context) => SocialLoginCubit(),
        ),
      ],
      child: BlocBuilder<SocialCubit, SocialState>(
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: SocialCubit.get(context).isDark
                ? ThemeMode.dark
                : ThemeMode.light,
            home: startWidget,
          );
        },
      ),
    );
  }
}
