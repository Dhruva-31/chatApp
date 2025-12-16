// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TextfieldWidget extends StatelessWidget {
  final String? hintText;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final IconData? sufixIcon;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final bool? obscureText;
  final int? minLines;
  final int? maxLines;
  final double? borderRaidus;
  const TextfieldWidget({
    super.key,
    this.hintText,
    required this.controller,
    this.prefixIcon,
    this.sufixIcon,
    this.onTap,
    this.onChanged,
    this.obscureText,
    this.minLines,
    this.maxLines,
    this.borderRaidus,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      maxLines: maxLines ?? 1,
      minLines: minLines ?? 1,
      decoration: InputDecoration(
        fillColor: const Color.fromARGB(101, 217, 209, 217),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRaidus ?? 10),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 169, 168, 169),
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRaidus ?? 10),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 169, 168, 169),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRaidus ?? 10),
          borderSide: BorderSide(
            color: const Color.fromARGB(255, 221, 219, 221),
            width: 2,
          ),
        ),
        hintText: hintText ?? '',
        hintStyle: TextStyle(color: const Color.fromARGB(255, 221, 219, 221)),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: const Color.fromARGB(255, 221, 219, 221))
            : null,
        suffixIcon: sufixIcon != null
            ? IconButton(
                icon: Icon(
                  sufixIcon,
                  color: const Color.fromARGB(255, 221, 219, 221),
                ),
                onPressed: onTap,
              )
            : null,
      ),
      cursorColor: Colors.white,
      obscureText: obscureText ?? false,
      onChanged: onChanged,
    );
  }
}
