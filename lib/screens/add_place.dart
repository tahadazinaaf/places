import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/models/place.dart';
import 'package:places/provider/user_places.dart';
import 'package:places/widgets/image_input.dart';
import 'package:places/widgets/location_input.dart';

class AddPlace extends ConsumerStatefulWidget {
  const AddPlace({super.key});

  @override
  _AddPlaceState createState() => _AddPlaceState();
}

class _AddPlaceState extends ConsumerState<AddPlace> {
  final _titlecontroller = TextEditingController();
  File? _selectImage;
  PlaceLocation? _selectLocation;

  void _saveplace() {
    final entertitle = _titlecontroller.text;
    if (entertitle.isEmpty || _selectImage == null || _selectLocation == null) {
      return;
    }
    ref.read(userPlecesProvide.notifier).addplace(
          entertitle,
          _selectImage!,
          _selectLocation!,
        );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titlecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Place"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsetsDirectional.only(
          start: 16,
        ),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
              style: const TextStyle(color: Colors.white),
              controller: _titlecontroller,
            ),
            const SizedBox(
              height: 8,
            ),
            ImageInput(
              onSelectImage: (File image) {
                _selectImage = image;
              },
            ),
            SizedBox(
              height: 16,
            ),
            LocationInput(
              onSelectLocation: (PlaceLocation location) {
                _selectLocation = location;
              },
            ),
            const SizedBox(
              height: 16,
            ),
            ElevatedButton.icon(
              onPressed: _saveplace, // Ca
              label: const Text('Add Place'),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
