// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class AlertWidget extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onPressed;
  const AlertWidget({
    super.key,
    required this.title,
    required this.content,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      content: Text(content, style: Theme.of(context).textTheme.bodyLarge),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: Text('Yes', style: Theme.of(context).textTheme.bodyMedium),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('No', style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
