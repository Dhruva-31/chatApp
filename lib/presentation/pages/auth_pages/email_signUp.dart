// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_auth_1/presentation/bloc/authBloc/auth_bloc.dart';
import 'package:firebase_auth_1/presentation/widgets/textfield_widget.dart';

class EmailSignup extends StatefulWidget {
  const EmailSignup({super.key});

  @override
  State<EmailSignup> createState() => _EmailSignupState();
}

class _EmailSignupState extends State<EmailSignup> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Email Sign Up',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Center(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSignUpSuccessState) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Sign Up Successful')));
              Navigator.pop(context);
            }
          },
          builder: (context, state) {
            if (state is AuthLoadingState) {
              return Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        RealSignUpButtonClickedEvent(
                          email: emailController.text,
                          password: passwordController.text,
                        ),
                      );
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
