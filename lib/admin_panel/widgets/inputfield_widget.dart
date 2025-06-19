import 'package:flutter/material.dart';

Widget buildInputField(
  String label,
  TextEditingController controller, {
  int maxLines = 1,
  TextInputType? keyboardType,
}) {
  return TextField(
    style: TextStyle(color: Colors.white),
    controller: controller,
    keyboardType: keyboardType,
    maxLines: maxLines,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      filled: true,
      fillColor: const Color.fromARGB(0, 245, 245, 245),

      // Default border
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(
          color: Colors.grey,
        ), // Default border color
      ),

      // When TextField is not focused
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 255, 255, 255),
        ), // Change this
      ),

      // When TextField is focused (clicked)
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 119, 40, 255),
          width: 2,
        ), // Change this
      ),
    ),
  );
}
