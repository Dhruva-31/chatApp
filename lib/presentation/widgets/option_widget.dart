import 'package:flutter/material.dart';

class OptionWidget extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const OptionWidget({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 25, color: Colors.white),
            SizedBox(width: 20),
            Text(label, style: TextStyle(fontSize: 17, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
