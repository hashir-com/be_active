import 'package:flutter/material.dart';

Widget infoRow(IconData icon, String label, String value, ThemeData theme) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 12),
        Text("$label:", style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: const Color.fromARGB(255, 196, 209, 255),
              fontSize: 16,
            ),
          ),
        ),
      ],
    ),
  );
}
