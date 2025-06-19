// ignore_for_file: unnecessary_import

import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Widget buildImagePickerField(
  String label,
  Uint8List? imageBytes, // Updated from File? to Uint8List?
  VoidCallback onPickImage,
  VoidCallback onDeleteImage,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: onPickImage,
        child: Stack(
          children: [
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white24),
              ),
              child:
                  imageBytes != null
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          imageBytes,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                      : const Center(
                        child: Icon(
                          Icons.add_photo_alternate,
                          color: Colors.white70,
                          size: 40,
                        ),
                      ),
            ),
            if (imageBytes != null)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onDeleteImage,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(6),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  );
}
