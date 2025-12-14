import 'package:firebase_auth_1/presentation/bloc/authBloc/auth_bloc.dart';
import 'package:firebase_auth_1/presentation/pages/auth_pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text('Email Sign Up'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthInitial) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LogInPage()),
                (route) => false,
              );
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Sign Up Successful')));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(101, 217, 209, 217),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 169, 168, 169),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 169, 168, 169),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 221, 219, 221),
                        width: 2,
                      ),
                    ),
                    hintText: 'Email',
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 221, 219, 221),
                    ),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: const Color.fromARGB(255, 221, 219, 221),
                    ),
                  ),
                  cursorColor: Colors.white,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(101, 217, 209, 217),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 169, 168, 169),
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 169, 168, 169),
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: const Color.fromARGB(255, 221, 219, 221),
                        width: 2,
                      ),
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: const Color.fromARGB(255, 221, 219, 221),
                    ),
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: const Color.fromARGB(255, 221, 219, 221),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: const Color.fromARGB(255, 221, 219, 221),
                      ),
                      onPressed: () {
                        setState(() {
                          isObscure = !isObscure;
                        });
                      },
                    ),
                  ),
                  obscureText: isObscure,
                  cursorColor: Colors.white,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(101, 217, 209, 217),
                    ),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      RealSignUpButtonClickedEvent(
                        email: emailController.text,
                        password: passwordController.text,
                      ),
                    );
                  },
                  child: Text('Sign Up', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
