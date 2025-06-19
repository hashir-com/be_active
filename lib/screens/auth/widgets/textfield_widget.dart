import 'package:flutter/material.dart';

class TextfieldWidget extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? Function(String?) validator;
  final TextInputType inputType;

  const TextfieldWidget({
    super.key,

    required this.label,
    required this.controller,
    required this.icon,
    required this.validator,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        cursorColor: Colors.white,
        controller: controller,
        keyboardType: inputType,
        validator: validator,
        style: const TextStyle(color: Colors.white), // white input text
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white), // white label text
          prefixIcon: Icon(icon, color: Colors.white), // white icon
          filled: true,
          fillColor: Colors.transparent, // transparent background
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(color: Colors.white), // white border
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: BorderSide(
              color: theme.primaryColor,
              width: 3,
            ), // focused border color
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(color: Colors.red), // error border
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}
