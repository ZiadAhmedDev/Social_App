import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/shared/components/components.dart';
import 'package:news_app/shared/components/constants.dart';
import 'package:news_app/shared/styles/colors.dart';
import 'package:news_app/shared/styles/icon_broken.dart';
import '../../../layout/social_layout/cubit/social_cubit.dart';

class EditLayout extends StatelessWidget {
  const EditLayout({super.key});

  @override
  Widget build(BuildContext context) {
    var nameController = TextEditingController();
    var bioController = TextEditingController();
    var phoneController = TextEditingController();
    return BlocConsumer<SocialCubit, SocialState>(
        listener: (context, state) {},
        builder: (context, state) {
          var model = SocialCubit.get(context).socialModel;
          printFullText(
              'profileImageprofileImageprofileImageprofileImageprofileImage');
          var profileImage = SocialCubit.get(context).profileImage;
          printFullText(
              'profileImageprofileImageprofileImageprofileImageprofileImage');
          var coverImage = SocialCubit.get(context).coverImage;
          print('coverImagecoverImagecoverImagecoverImagecoverImagecoverImage');
          print(coverImage);
          print('coverImagecoverImagecoverImagecoverImagecoverImagecoverImage');
          nameController.text = model!.name!;
          bioController.text = model.bio!;
          phoneController.text = model.phone!;
          return Scaffold(
            appBar: zAppBar(
              context,
              action: [
                TextButton(
                  onPressed: () {
                    SocialCubit.get(context).updateUserSetting(
                      name: nameController.text,
                      bio: bioController.text,
                      phone: phoneController.text,
                    );
                  },
                  child: Text(
                    'Update',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: defaultColor),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
              title: const Text('Edit Profile'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  if (state is SocialUpdateUserSettingLoadingState)
                    LinearProgressIndicator(),
                  if (state is SocialUpdateUserSettingLoadingState)
                    SizedBox(height: 10),
                  SizedBox(
                    height: 180,
                    child: Stack(alignment: Alignment.bottomCenter, children: [
                      Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Card(
                              elevation: 5.0,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: coverImage == null &&
                                      SocialCubit.get(context)
                                          .coverImageUrl!
                                          .isEmpty
                                  ? Image.network(
                                      '${model.cover}',
                                      fit: BoxFit.cover,
                                      height: 160,
                                      width: double.infinity,
                                    )
                                  : Image.file(
                                      File((coverImage!.path)),
                                      fit: BoxFit.cover,
                                      height: 120,
                                      width: double.infinity,
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: defaultColor,
                              child: IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).getCoverImage();
                                },
                                icon: const Icon(
                                  IconBroken.Camera,
                                  // color: defaultColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 50,
                            child: CircleAvatar(
                              radius: 45,
                              backgroundImage: profileImage == null
                                  ? NetworkImage(
                                      '${model.image}',
                                    )
                                  : FileImage(File(profileImage.path))
                                      as ImageProvider,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 17,
                              backgroundColor: defaultColor,
                              child: IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).getProfileImage();
                                },
                                icon: const Icon(
                                  IconBroken.Camera,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                      controller: nameController,
                      type: TextInputType.name,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'The name field can\'t be Empty';
                        }
                        return null;
                      },
                      label: 'Name',
                      prefix: IconBroken.User),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                      controller: bioController,
                      type: TextInputType.text,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'The bio field can\'t be Empty';
                        }
                        return null;
                      },
                      label: 'Bio',
                      prefix: IconBroken.Info_Circle),
                  const SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                      controller: phoneController,
                      type: TextInputType.phone,
                      validate: (String? value) {
                        if (value!.isEmpty) {
                          return 'The phone field can\'t be Empty';
                        }
                        return null;
                      },
                      label: 'Phone',
                      prefix: IconBroken.Call),
                ],
              ),
            ),
          );
        });
  }
}
