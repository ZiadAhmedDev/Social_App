import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/social_layout/cubit/social_cubit.dart';
import 'package:news_app/modules/social%20app/Register/cubit/social_register_cubit.dart';
import 'package:news_app/modules/social%20app/Register/cubit/social_register_state.dart';
import 'package:news_app/modules/social%20app/new_post/new_post_screen.dart';
import 'package:news_app/shared/components/components.dart';
import 'package:news_app/shared/styles/icon_broken.dart';
import '../../shared/components/constants.dart';

class SocialLayout extends StatelessWidget {
  SocialLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {
        if (state is SocialNewPost) {
          navigateTo(context, NewPostLayout());
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () async {
                  if (state is SignInGoogleSuccess) {
                    await SocialRegisterCubit().signOutGoogle(context);
                  } else {
                    signOut(context);
                  }
                },
                icon: const Icon(IconBroken.Logout),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(IconBroken.Notification),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(IconBroken.Search),
              ),
            ],
            title: Text(
              cubit.titles[cubit.currentIndex],
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontSize: 25),
            ),
          ),
          body: cubit.screen[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
              onTap: (index) => cubit.changeScreenIndex(index),
              currentIndex: cubit.currentIndex,
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Chat), label: 'Chat'),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Paper_Upload), label: 'Post'),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.User), label: 'User'),
                BottomNavigationBarItem(
                    icon: Icon(IconBroken.Setting), label: 'Setting'),
              ]),
        );
      },
    );
  }
}
