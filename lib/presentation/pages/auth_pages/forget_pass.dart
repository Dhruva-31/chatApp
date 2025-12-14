import 'package:firebase_auth_1/presentation/bloc/authBloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPassPage extends StatelessWidget {
  ForgetPassPage({super.key});
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Forget Password')),
      body: Center(
        child: Column(
          children: [
            Text('Forget Password Page'),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<AuthBloc>().add(
                  ResetButtonClickedEvent(email: emailController.text.trim()),
                );
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
