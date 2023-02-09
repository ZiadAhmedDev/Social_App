import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/layout/social_layout/social_layout.dart';
import 'package:news_app/modules/social%20app/Register/phone_auth/otp_screen.dart';

import '../../../layout/social_layout/cubit/social_cubit.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../login/login_screen.dart';
import 'cubit/social_register_cubit.dart';
import 'cubit/social_register_state.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialRegisterCubit(),
      child: BlocConsumer<SocialRegisterCubit, SocialRegisterState>(
        listener: (context, state) {
          if (state is SocialCreateUserError) {
            showToaster(message: state.error, state: ToasterState.error);
          }
          // if (state is SocialRegisterSuccess) {
          //   CacheHelper.saveData(key: 'uId', value: state.uId)
          //       .then((value) async {
          //     uId = CacheHelper.getData(key: 'uId');
          //     await SocialCubit.get(context).getUserData();
          //   });
          //   navigateAndReplacement(context, SocialLayout());
          // }
          if (state is SocialRegisterSuccess) {
            uId = state.uId;
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value) async {
              await SocialCubit.get(context).getUserData();
              navigateAndReplacement(
                context,
                SocialLayout(),
              );
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('REGISTER',
                            style: Theme.of(context).textTheme.headlineSmall),
                        Text(
                            'REGISTER now to communicate with all your friends',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Colors.grey)),
                        const SizedBox(
                          height: 30,
                        ),
                        defaultFormField(
                            controller: nameController,
                            type: TextInputType.name,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                if (state is SocialRegisterSuccess) {
                                  CacheHelper.saveData(
                                          key: 'uId', value: state.uId)
                                      .then((value) {
                                    uId = CacheHelper.getData(key: 'uId');
                                    navigateAndReplacement(
                                        context, SocialLayout());
                                  });
                                }
                                return 'Name field can\'t be empty';
                              }
                              return null;
                            },
                            label: 'Full Name',
                            prefix: Icons.person),
                        const SizedBox(
                          height: 25,
                        ),
                        defaultFormField(
                            controller: phoneController,
                            type: TextInputType.phone,
                            validate: (String? value) {
                              if (value!.isEmpty) {
                                return 'Phone field can\'t be empty';
                              }
                              return null;
                            },
                            label: 'Phone',
                            prefix: Icons.phone_android_rounded),
                        const SizedBox(
                          height: 25,
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
                            label: 'Email Address',
                            prefix: Icons.email_outlined),
                        const SizedBox(
                          height: 25,
                        ),
                        defaultFormField(
                            controller: passwordController,
                            type: TextInputType.visiblePassword,
                            onSubmit: (value) {
                              if (formKey.currentState!.validate()) {
                                SocialRegisterCubit.get(context)
                                    .verifyPhoneNumber(
                                        context, phoneController.text
                                        // email: emailController.text,
                                        // password: passwordController.text,
                                        // name: nameController.text,
                                        // phone: phoneController.text,
                                        );
                                emailControllerOtp = emailController.text;
                                phoneControllerOtp = phoneController.text;
                                passwordControllerOtp = passwordController.text;
                                nameControllerOtp = nameController.text;
                                navigateTo(context, OTPPage());
                              }
                            },
                            isPassword:
                                SocialRegisterCubit.get(context).isPassword,
                            suffix: SocialRegisterCubit.get(context).iconSuffix,
                            suffixPressed: () {
                              SocialRegisterCubit.get(context)
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
                          condition: state is! SocialRegisterLoading,
                          builder: (context) => defaultButton(
                              function: () {
                                if (formKey.currentState!.validate()) {
                                  SocialRegisterCubit.get(context)
                                      .verifyPhoneNumber(
                                          context, phoneController.text
                                          // email: emailController.text,

                                          // password: passwordController.text,
                                          // name: nameController.text,
                                          // phone: phoneController.text,
                                          );
                                  emailControllerOtp = emailController.text;
                                  phoneControllerOtp = phoneController.text;
                                  passwordControllerOtp =
                                      passwordController.text;
                                  nameControllerOtp = nameController.text;
                                  navigateTo(context, OTPPage());
                                }
                              },
                              text: 'register'),
                          fallback: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'I already have an account  ',
                              style: TextStyle(fontSize: 16),
                            ),
                            defaultTextButton(
                              function: () {
                                navigateTo(context, LoginScreen());
                              },
                              text: 'LOGIN',
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
