import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shared/components/components.dart';
import 'package:news_app/shared/styles/colors.dart';
import 'package:news_app/shared/styles/icon_broken.dart';

import '../../../layout/social_layout/cubit/social_cubit.dart';

class NewPostLayout extends StatelessWidget {
  NewPostLayout({super.key});
  var textControl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: zAppBar(context,
              action: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: defaultTextButton(
                      function: () {
                        if (SocialCubit.get(context).postImage == null) {
                          SocialCubit.get(context).createNewPost(
                              date: DateTime.now().toString(),
                              text: textControl.text);
                        } else {
                          SocialCubit.get(context).uploadPostImage(
                            date: DateTime.now().toString(),
                            text: textControl.text,
                          );
                        }
                      },
                      text: 'Post',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: defaultColor)),
                )
              ],
              title: const Text('New Post')),
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .88,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state is SocialCreateNewPostLoadingState)
                    const LinearProgressIndicator(),
                  if (state is SocialCreateNewPostLoadingState)
                    const SizedBox(
                      height: 20,
                    ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            '${SocialCubit.get(context).socialModel!.image}',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(
                          'Ziad Ahmed   ',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: defaultFormField(
                          controller: textControl,
                          type: TextInputType.text,
                          hasBorder: false,
                          style: const TextStyle(fontSize: 17),
                          hint: 'What is going into your mind.....'),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  if (state is SocialUploadPostImageSuccessState)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Card(
                            elevation: 5.0,
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Image.file(
                              File(SocialCubit.get(context).postImage!.path),
                              fit: BoxFit.cover,
                              height: 160,
                              width: double.infinity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: defaultColor,
                              child: IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).removePostImage();
                                },
                                icon: const Icon(
                                  Icons.close,
                                  size: 18,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              const Icon(
                                IconBroken.Camera,
                                color: defaultColor,
                              ),
                              TextButton(
                                onPressed: () {
                                  SocialCubit.get(context).getPostImage();
                                },
                                child: Text(
                                  'Add Photo',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: defaultColor),
                                ),
                              ),
                              const Spacer(),
                              Expanded(
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    '#tags',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(color: defaultColor),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
