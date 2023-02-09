import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../layout/social_layout/cubit/social_cubit.dart';
import '../../../layout/social_layout/social_layout.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../Register/register_layout.dart';
import 'cubit/social_login_cubit.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit, SocialLoginState>(
        listener: (context, state) {
          if (state is SocialLoginError) {
            showToaster(
              message: state.error,
              state: ToasterState.error,
            );
          }
          if (state is SocialLoginSuccess) {
            uId = state.uId;
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) async {
              await SocialCubit.get(context).getUserData();
              await SocialCubit.get(context).getNewPosts();
              navigateAndReplacement(
                context,
                SocialLayout(),
              );
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('LOGIN',
                            style: Theme.of(context).textTheme.headlineSmall),
                        Text('login now to communicate with all your friends',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.grey)),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                            controller: emailController,
                            type: TextInputType.emailAddress,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Email field can\'t be empty';
                              }
                              return null;
                            },
                            label: 'Email Address/Phone',
                            prefix: Icons.email_outlined),
                        const SizedBox(
                          height: 25,
                        ),
                        defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                SocialLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text);
                              }
                            },
                            isPassword:
                                SocialLoginCubit.get(context).isPassword,
                            suffix: SocialLoginCubit.get(context).iconSuffix,
                            suffixPressed: () {
                              SocialLoginCubit.get(context)
                                  .passwordVisibility();
                            },
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'password field can\'t be empty';
                              }
                              return null;
                            },
                            label: 'Password',
                            prefix: Icons.lock_outlined),
                        const SizedBox(
                          height: 25,
                        ),
                        ConditionalBuilder(
                          condition: state is! SocialLoginLoading,
                          builder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  SocialLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              },
                              text: 'Login'),
                          fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Divider(
                            thickness: 2,
                            color: Colors.grey[400],
                            endIndent: 1,
                            indent: 1,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Expanded(
                              child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.black,
                                  ),
                                  onPressed: () {
                                    // SocialLoginCubit.get(context)
                                    //     .signInGoogle();
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.google,
                                    color: Colors.orange,
                                  ),
                                  label: const Text(
                                    'Sign in With Google account',
                                  )),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don\'t have an account?',
                              style: TextStyle(fontSize: 16),
                            ),
                            defaultTextButton(
                              function: () {
                                navigateTo(context, RegisterScreen());
                              },
                              text: 'register',
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
