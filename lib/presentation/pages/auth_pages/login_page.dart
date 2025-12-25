// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:firebase_auth_1/presentation/bloc/authBloc/auth_bloc.dart';
import 'package:firebase_auth_1/presentation/pages/auth_pages/email_signUp.dart';
import 'package:firebase_auth_1/presentation/pages/auth_pages/forget_pass.dart';
import 'package:firebase_auth_1/presentation/widgets/icon_widget.dart';
import 'package:firebase_auth_1/presentation/widgets/textfield_widget.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  late List<List<dynamic>> providers = [
    [FontAwesomeIcons.google, GoogleSignInButtonClickedEvent()],
    [FontAwesomeIcons.github, GitHubSignInButtonClickedEvent()],
  ];
  bool isObscure = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailureState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          } else if (state is AuthShowSignUpPageState) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => EmailSignup()));
          } else if (state is AuthShowForgotPasswordPage) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => ForgetPassPage()));
          } else if (state is AuthSuccessState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Sign In Successful')));
          }
        },
        builder: (context, state) {
          if (state is AuthLoadingState) {
            return Center(
              child: const CircularProgressIndicator(color: Colors.white),
            );
          }
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    "Welcome Back!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Sign in to continue your journey",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: const Color.fromARGB(255, 221, 219, 221),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextfieldWidget(
                                hintText: 'Email',
                                controller: emailController,
                                prefixIcon: Icons.email_outlined,
                              ),
                              SizedBox(height: 20),
                              TextfieldWidget(
                                hintText: 'Password',
                                controller: passwordController,
                                prefixIcon: Icons.lock_outline,
                                sufixIcon: isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                onTap: () => setState(() {
                                  isObscure = !isObscure;
                                }),
                                obscureText: isObscure,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      context.read<AuthBloc>().add(
                                        ForgotPasswordButtonClickedEvent(),
                                      );
                                    },
                                    child: Text(
                                      "Forgot Password?",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: () {
                                  context.read<AuthBloc>().add(
                                    SignInButtonClickedEvent(
                                      email: emailController.text.trim(),
                                      password: passwordController.text.trim(),
                                    ),
                                  );
                                },
                                style: Theme.of(
                                  context,
                                ).elevatedButtonTheme.style,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Sign In",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.arrow_forward_outlined,
                                      size: 24,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "---------------",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        221,
                                        219,
                                        221,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "or continue with",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        221,
                                        219,
                                        221,
                                      ),
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    "---------------",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        221,
                                        219,
                                        221,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 10,
                                    ),
                                    child: IconWidget(
                                      icon: providers[0][0],
                                      event: providers[0][1],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 10,
                                    ),
                                    child: IconWidget(
                                      icon: providers[1][0],
                                      event: providers[1][1],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "don't have an account?",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.read<AuthBloc>().add(
                                        HomeSignUpButtonClickedEvent(),
                                      );
                                    },
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        color: Colors.yellow,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
