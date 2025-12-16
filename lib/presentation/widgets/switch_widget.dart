// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SwitchWidget extends StatelessWidget {
  final String text;
  final VoidCallback onChanged;
  final bool value;
  const SwitchWidget({
    super.key,
    required this.text,
    required this.onChanged,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: Theme.of(context).textTheme.bodyLarge),
        Switch(
          value: value,
          onChanged: (_) {
            onChanged();
          },
        ),
      ],
    );
  }
}
