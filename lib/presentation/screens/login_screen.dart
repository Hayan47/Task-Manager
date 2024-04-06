import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:task_manager/constants/my_colors.dart';
import 'package:task_manager/logic/auth_bloc/auth_bloc.dart';
import 'package:task_manager/presentation/widgets/button.dart';
import 'package:task_manager/presentation/widgets/curve_cliper.dart';
import 'package:task_manager/presentation/widgets/snackbar.dart';
import 'package:task_manager/presentation/widgets/text_field.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool hidePassword = true;

  final _emailcontroller = TextEditingController();
  final _passwordcontroller = TextEditingController();
  final formKey2 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ClipPath(
            clipper: CurveClipper(),
            child: Container(
              height: MediaQuery.sizeOf(context).height * 0.6,
              decoration: const BoxDecoration(
                color: MyColors.myred,
              ),
            ),
          ),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthLoginErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  MySnackBar(
                    icon: const Icon(Icons.error,
                        color: MyColors.myred, size: 18),
                    message: state.message,
                    margin: 5,
                  ),
                );
              } else if (state is AuthLoggedInState) {
                Navigator.pushReplacementNamed(context, 'home');
                ScaffoldMessenger.of(context).showSnackBar(
                  MySnackBar(
                    icon: const Icon(Icons.done, color: Colors.green, size: 18),
                    message: 'welcome back',
                    margin: 5,
                  ),
                );
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CustomScrollView(
                        scrollDirection: Axis.vertical,
                        slivers: [
                          SliverFillRemaining(
                            hasScrollBody: false,
                            //?main column
                            child: Form(
                              key: formKey2,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.2),
                                    SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.41,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //!first message
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Login',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 30,
                                                    ),
                                              ),
                                              //!second message
                                              Text(
                                                'welcome back, you have been missed!',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          //!email
                                          MyTextField(
                                            controller: _emailcontroller,
                                            hint: 'Email...',
                                            obscureText: false,
                                            textInputType:
                                                TextInputType.emailAddress,
                                            validator: (value) {
                                              if (value == null ||
                                                  !EmailValidator.validate(
                                                      value)) {
                                                return 'Enter a valid email';
                                              }
                                              return null;
                                            },
                                          ),
                                          //!password
                                          MyTextField(
                                            controller: _passwordcontroller,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.length < 8) {
                                                return 'password is short';
                                              }
                                              return null;
                                            },
                                            textInputType:
                                                TextInputType.visiblePassword,
                                            hint: 'Password...',
                                            obscureText: hidePassword,
                                            suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  hidePassword = !hidePassword;
                                                });
                                              },
                                              icon: Icon(
                                                hidePassword
                                                    ? Icons.visibility_off
                                                    : Icons.visibility,
                                                color: MyColors.mywhite,
                                              ),
                                            ),
                                          ),
                                          //!forget password
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () =>
                                                    Navigator.pushNamed(context,
                                                        'forgetpasswordscreen'),
                                                child: Text(
                                                  'Forget password?',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodySmall!
                                                      .copyWith(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                      ),
                                                ),
                                              )
                                            ],
                                          ),
                                          //!login Button
                                          state is AuthLoadingState
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 70,
                                                      height: 40,
                                                      child: Lottie.asset(
                                                          'assets/lottie/SplashyLoader.json'),
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    //!signup
                                                    MyButton(
                                                      color: MyColors.mywhite,
                                                      textColor: Colors.black,
                                                      text: 'SIGNUP',
                                                      onpressed: () {},
                                                    ),
                                                    //!login
                                                    MyButton(
                                                      color: Colors.black,
                                                      textColor: Colors.white,
                                                      text: 'LOGIN',
                                                      onpressed: () async {
                                                        final isValid = formKey2
                                                            .currentState!
                                                            .validate();
                                                        if (!isValid) return;
                                                        context
                                                            .read<AuthBloc>()
                                                            .add(LoginEvent(
                                                                email:
                                                                    _emailcontroller
                                                                        .text,
                                                                password:
                                                                    _passwordcontroller
                                                                        .text));
                                                      },
                                                    ),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.3,
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            'or continue with',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Container(
                                                width: 40,
                                                height: 40,
                                                child: Image.asset(
                                                    'assets/images/google.png'),
                                              ),
                                              Container(
                                                width: 50,
                                                height: 50,
                                                child: Image.asset(
                                                    'assets/images/facebook.png'),
                                              ),
                                              Container(
                                                width: 40,
                                                height: 40,
                                                child: Image.asset(
                                                    'assets/images/twitter.png'),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
