import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/social_layout/cubit/social_cubit.dart';
import 'package:news_app/modules/social%20app/edit_profile/edit_profile.dart';
import 'package:news_app/shared/components/components.dart';
import 'package:news_app/shared/styles/icon_broken.dart';

class SettingLayout extends StatelessWidget {
  const SettingLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialState>(
      listener: (context, state) {},
      builder: (context, state) {
        var model = SocialCubit.get(context).socialModel;
        return Column(children: [
          SizedBox(
            height: 180,
            child: Stack(alignment: Alignment.bottomCenter, children: [
              Align(
                alignment: Alignment.topCenter,
                child: Card(
                  elevation: 5.0,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: Image.network(
                    '${model!.cover}',
                    fit: BoxFit.cover,
                    height: 160,
                    width: double.infinity,
                  ),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 50,
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage(
                    '${model.image}',
                  ),
                ),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              '${model.name}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Text(
            '${model.bio}',
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.grey[700]),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    child: Column(
                      children: [
                        Text(
                          '100',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Friends',
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Column(
                      children: [
                        Text(
                          '1 K',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Posts',
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Column(
                      children: [
                        Text(
                          '10 K',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Followers',
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    child: Column(
                      children: [
                        Text(
                          '350',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Followings',
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 15),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Edit Profile'),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                  onPressed: () {
                    navigateTo(context, const EditLayout());
                  },
                  child: const Icon(IconBroken.Edit),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Spacer(
                  flex: 1,
                ),
                OutlinedButton(
                    onPressed: () {
                      FirebaseMessaging.instance.subscribeToTopic('AllUsers');
                    },
                    child: const Text(
                      'Subscribe',
                      style: TextStyle(fontSize: 17),
                    )),
                const Spacer(
                  flex: 2,
                ),
                OutlinedButton(
                  onPressed: () {
                    FirebaseMessaging.instance.unsubscribeFromTopic('AllUsers');
                  },
                  child: const Text(
                    'UnSubscribe',
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                const Spacer(
                  flex: 1,
                )
              ],
            ),
          )
        ]);
      },
    );
  }
}
