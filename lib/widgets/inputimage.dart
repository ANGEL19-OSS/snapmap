import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class inputimage extends StatefulWidget {
  const inputimage({super.key, required this.onpickimage});

  final void Function(File image) onpickimage;

  @override
  State<inputimage> createState() {
    return _inputimageState();
  }
}

class _inputimageState extends State<inputimage> {
  File? _selectedimage; // using dart:io
  bool _isLoading = false;

  void takepicture() async {
    try {
      final imagePicker = ImagePicker();
      final pickedimage = await imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 600,
      );

      if (pickedimage == null) {
        return;
      }

      final imageFile = File(pickedimage.path);
      final fileSize = await imageFile.length();

      // ✅ Prevent decoding invalid or empty image
      if (fileSize == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid image data. Please try again.'),
          ),
        );
        return;
      }

      setState(() {
        _selectedimage = imageFile; // convert XFile to File
      });

      widget.onpickimage(_selectedimage!);
    } catch (e) {
      debugPrint('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: takepicture,
      icon: const Icon(Icons.camera),
      label: const Text('Take Picture'),
    );

    if (_selectedimage != null) {
      content = GestureDetector(
        onTap: takepicture,
        child: Image.file(
          _selectedimage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          // ✅ Handle invalid image decoding gracefully
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text(
                'Could not load image',
                style: TextStyle(color: Colors.red),
              ),
            );
          },
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      height: 250,
      width: double.infinity,
      alignment: Alignment.center,
      child: content,
    );
  }
}
