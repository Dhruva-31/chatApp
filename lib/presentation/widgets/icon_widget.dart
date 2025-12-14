import 'package:firebase_auth_1/presentation/bloc/authBloc/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IconWidget extends StatelessWidget {
  final IconData icon;
  final AuthEvent event;
  const IconWidget({super.key, required this.icon, required this.event});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(101, 217, 209, 217),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 35),
        onPressed: () {
          context.read<AuthBloc>().add(event);
        },
      ),
    );
  }
}
