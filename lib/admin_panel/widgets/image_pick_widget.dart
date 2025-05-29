import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SimpleImagePicker extends StatefulWidget {
  final void Function(List<String> imagePaths)? onImagesPicked;

  const SimpleImagePicker({super.key, this.onImagesPicked});

  @override
  SimpleImagePickerState createState() => SimpleImagePickerState();
}

class SimpleImagePickerState extends State<SimpleImagePicker> {
  List<File> _pickedImages = [];

  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      if (!mounted) return; // exit if widget is no longer mounted

      setState(() {
        _pickedImages = pickedFiles.map((file) => File(file.path)).toList();
      });

      if (widget.onImagesPicked != null) {
        widget.onImagesPicked?.call(_pickedImages.map((f) => f.path).toList());
      }
    }
  }

  // New: method to clear images from outside
  void clear() {
    setState(() {
      _pickedImages.clear();
    });
    widget.onImagesPicked?.call([]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _pickImages,
          child: Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Add photo"),
                Icon(
                  Icons.image,
                  size: 40,
                  color: const Color.fromARGB(255, 12, 17, 162),
                ),
              ],
            ),
          ),
        ),
        if (_pickedImages.isNotEmpty)
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _pickedImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Image.file(
                    _pickedImages[index],
                    height: 120,
                    width: 120,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
