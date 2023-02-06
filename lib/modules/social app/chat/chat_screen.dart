import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/models/social_create_user.dart';
import 'package:news_app/modules/chat_details/chat_details.dart';
import 'package:news_app/shared/components/components.dart';
import 'package:news_app/shared/styles/colors.dart';

import '../../../layout/social_layout/cubit/social_cubit.dart';

class ChatLayout extends StatelessWidget {
  const ChatLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: SocialCubit.get(context).userList.isNotEmpty,
          builder: (context) => ListView.separated(
              itemBuilder: (context, index) => allUserBuilder(
                  context, SocialCubit.get(context).userList[index]),
              separatorBuilder: (context, index) => listDivider(),
              itemCount: SocialCubit.get(context).userList.length),
          fallback: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

Widget allUserBuilder(context, SocialUserModel model) {
  return InkWell(
    onTap: () {
      navigateTo(
          context,
          ChatDetailsLayout(
            model: model,
          ));
    },
    child: Row(
      children: [
        Padding(
          padding: EdgeInsets.all(20.0),
          child: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              model.image != null && model.image!.isNotEmpty
                  ? '${model.image}'
                  : 'https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg?w=826&t=st=1674657751~exp=1674658351~hmac=2dd02bc2588474b028451a4fb84192c789d286bbc8af955a7091cb2d65ce3d4d',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '${model.name}',
            style: TextStyle(fontSize: 17, color: defaultColor),
          ),
        ),
      ],
    ),
  );
}
