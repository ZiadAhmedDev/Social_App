import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/models/message_mode.dart';
import 'package:news_app/models/social_create_user.dart';
import 'package:news_app/shared/styles/colors.dart';
import 'package:news_app/shared/styles/icon_broken.dart';
import '../../layout/social_layout/cubit/social_cubit.dart';
import '../../models/message_mode.dart';
import '../../shared/components/components.dart';
import '../../shared/components/constants.dart';

class ChatDetailsLayout extends StatelessWidget {
  ChatDetailsLayout({
    this.model,
    super.key,
  });
  SocialUserModel? model;
  TextEditingController messageControl = TextEditingController();
  final ScrollController _scrollControl = ScrollController();
  GlobalKey formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getMessages(receiverUid: model!.uId!);

      return BlocConsumer<SocialCubit, SocialState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
              appBar: zAppBar(
                  title: const Text(
                    'Chatting with',
                  ),
                  context),
              body: ConditionalBuilder(
                  condition: SocialCubit.get(context).message.isNotEmpty,
                  builder: (context) {
                    if (state is SocialGetMessageSuccessState) {
                      Future.delayed(const Duration(milliseconds: 300))
                          .then((value) {
                        _scrollControl.animateTo(
                            _scrollControl.positions.last.maxScrollExtent,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.easeIn);
                      });
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                                controller: _scrollControl,
                                itemBuilder: (context, index) {
                                  var message =
                                      SocialCubit.get(context).message[index];
                                  if (SocialCubit.get(context)
                                          .socialModel!
                                          .uId ==
                                      message.senderUid) {
                                    return receiverMessageBuilder(message);
                                  } else {
                                    return messageBuilder(message);
                                  }
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: 20,
                                    ),
                                itemCount:
                                    SocialCubit.get(context).message.length),
                          ),
                          sendBarBuilder(
                            messageControl,
                            context,
                            model,
                          )
                        ],
                      ),
                    );
                  },
                  fallback: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(
                                controller: _scrollControl,
                                itemBuilder: (context, index) {
                                  var message =
                                      SocialCubit.get(context).message[index];
                                  if (SocialCubit.get(context)
                                          .socialModel!
                                          .uId ==
                                      message.senderUid) {
                                    return receiverMessageBuilder(message);
                                  } else {
                                    return messageBuilder(message);
                                  }
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: 20,
                                    ),
                                itemCount:
                                    SocialCubit.get(context).message.length),
                          ),
                          sendBarBuilder(
                            messageControl,
                            context,
                            model,
                          )
                        ],
                      ),
                    );
                  }));
        },
      );
    });
  }
}

Widget messageBuilder(MessageModel model) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Align(
      alignment: Alignment.topLeft,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 250),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: const BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(36),
              topRight: Radius.circular(36),
              bottomRight: Radius.circular(36),
            )),
        child: Text(
          model.text!,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    ),
  );
}

Widget receiverMessageBuilder(MessageModel model) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 250),
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: const BoxDecoration(
            color: Color(0xff006D84),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(36),
              topRight: Radius.circular(36),
              bottomLeft: Radius.circular(36),
            )),
        child: Text(
          model.text!,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    ),
  );
}

Widget sendBarBuilder(
    TextEditingController messageControl, context, SocialUserModel? model) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.grey,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(20),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    child: Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: messageControl,
              validator: (String? value) {
                if (value!.isEmpty) {
                  return 'Write Any Message';
                }
                return null;
              },
              style: const TextStyle(fontSize: 18),
              decoration: const InputDecoration(
                  hintText: 'Send a Message',
                  labelStyle: TextStyle(fontSize: 20),
                  border: InputBorder.none),
            ),
          ),
        ),
        Container(
          height: 70,
          color: defaultColor,
          child: MaterialButton(
            onPressed: () {
              try {
                if (messageControl.text.isNotEmpty) {
                  SocialCubit.get(context).sendMessage(
                      receiverUid: model!.uId!,
                      date: DateTime.now().toString(),
                      text: messageControl.text);
                }
                messageControl.text = '';
                // _scrollControl.animateTo(
                //     _scrollControl
                //             .position.maxScrollExtent +
                //         1,
                //     duration:
                //         const Duration(milliseconds: 500),
                //     curve: Curves.easeIn);
              } on Exception catch (e) {
                printFullText(e.toString());
              }
            },
            minWidth: 1,
            child: const Icon(
              IconBroken.Send,
              color: Colors.white,
            ),
          ),
        )
      ],
    ),
  );
}
