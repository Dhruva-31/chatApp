// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:firebase_auth_1/data/services/firebase_methods.dart';
import 'package:firebase_auth_1/presentation/bloc/authBloc/auth_bloc.dart';
import 'package:firebase_auth_1/presentation/pages/auth_pages/login_page.dart';
import 'package:firebase_auth_1/presentation/widgets/textfield_widget.dart';

class DeleteAccPage extends StatefulWidget {
  const DeleteAccPage({super.key});

  @override
  State<DeleteAccPage> createState() => _DeleteAccPageState();
}

class _DeleteAccPageState extends State<DeleteAccPage> {
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    final provider = FirebaseMethods().getLoginProvider();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Delete Account',
          style: TextStyle(fontSize: 26, color: Colors.white),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailureState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          } else if (state is AccountDeletedState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LogInPage()),
              (route) => false,
            );
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
                if (provider == "password") ...[
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
                  SizedBox(height: 40),
                ],
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      DeleteAccountButtonClickedEvent(
                        provider: provider,
                        password: provider == 'password'
                            ? passwordController.text.trim()
                            : null,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    "Delete Account \n($provider)",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
