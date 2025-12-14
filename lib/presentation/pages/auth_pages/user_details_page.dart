import 'package:firebase_auth_1/presentation/bloc/authBloc/auth_bloc.dart';
import 'package:firebase_auth_1/presentation/pages/initial_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserDetailsPage extends StatelessWidget {
  UserDetailsPage({super.key});
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailureState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          } else if (state is AuthFinishedState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => InitialPage()),
              (route) => false,
            );
          }
        },
        child: Padding(
          padding: EdgeInsetsGeometry.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
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
                  hintText: 'Name',
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
                    ProceedButtonClickedEvent(name: nameController.text.trim()),
                  );
                },
                child: Text('Proceed', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
