import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageInput extends StatefulWidget {
  // ignore: use_super_parameters
  const ImageInput({key, required this.onSelectImage}) : super(key: key);
  final void Function(File image) onSelectImage;

  @override
  // ignore: library_private_types_in_public_api
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _selectImage;

  _takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(
      source: ImageSource.camera, // Use ImageSource.gallery for gallery
      maxWidth: 600, // Optional: Limit image width
    );

    if (imageFile == null) {
      return;
    }
    setState(() {
      _selectImage = File(imageFile.path);
    });
    widget.onSelectImage(_selectImage!);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = TextButton.icon(
      onPressed: _takePicture,
      icon: const Icon(Icons.camera),
      label: const Text('add picture'),
    );
    if (_selectImage != null) {
      content = GestureDetector(
        onTap: _takePicture,
        child: Image.file(
          _selectImage!,
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity,
        ),
      );
    }
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1,
          color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        ),
      ),
      alignment: Alignment.center,
      child: content,
    );
  }
}
