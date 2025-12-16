// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:firebase_auth_1/presentation/widgets/textfield_widget.dart';

class EditNameWidget extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;

  const EditNameWidget({
    super.key,
    required this.controller,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Name', style: Theme.of(context).textTheme.titleMedium),
      content: TextfieldWidget(controller: controller),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel', style: Theme.of(context).textTheme.bodyMedium),
        ),
        TextButton(
          onPressed: onSave,
          child: Text('Save', style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
