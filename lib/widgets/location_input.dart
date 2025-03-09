import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:places/models/place.dart';
import 'package:places/screens/MapScreen.dart';

class LocationInput extends StatefulWidget {
  final void Function(PlaceLocation location) onSelectLocation;

  const LocationInput({super.key, required this.onSelectLocation});

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  PlaceLocation? _pickedLocation;
  bool _isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }
    final latitude = _pickedLocation!.latitude;
    final longitude = _pickedLocation!.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$latitude,$longitude&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:L%7C$latitude,$longitude&key=AIzaSyDcNj3t6CLoykKCbtrkQT8cXI3hWKG5oXY';
  }

  Future _savePlace(double latitude, double longitude) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=AIzaSyDcNj3t6CLoykKCbtrkQT8cXI3hWKG5oXY',
    );
    final response = await http.get(url);
    final responseData = json.decode(response.body);

    if (responseData['status'] == 'OK') {
      final address = responseData['results'][0]['formatted_address'];
      setState(() {
        _pickedLocation = PlaceLocation(
          latitude: latitude,
          longitude: longitude,
          address: address,
        );
        _isGettingLocation = false;
      });
      widget.onSelectLocation(_pickedLocation!);
    } else {
      setState(() => _isGettingLocation = false);
      print('API Error: ${responseData["status"]}');
    }
  }

  Future<void> _getLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    setState(() => _isGettingLocation = true);

    try {
      locationData = await location.getLocation();
      final latitude = locationData.latitude;
      final longitude = locationData.longitude;

      print('Latitude: $latitude');
      print('Longitude: $longitude');

      if (latitude == null || longitude == null) {
        setState(() => _isGettingLocation = false);
        return;
      }
      _savePlace(latitude, longitude);
    } catch (e) {
      setState(() => _isGettingLocation = false);
      print('Error: $e');
    }
  }

  void _selectonmap() async {
    final LatLng? _savedlocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        builder: (ctx) => const MapScreen(), // Lowercase 'places'
      ),
    );
    if (_savedlocation == null) {
      return;
    }
    _savePlace(_savedlocation.latitude, _savedlocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = const Text(
      'No location selected',
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.fill,
        height: double.infinity,
        width: double.infinity,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) {
          return const Text(
            'Failed to load map',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          );
        },
      );
    }

    if (_isGettingLocation) {
      previewContent = const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Column(
      children: [
        Container(
          height: 164,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getLocation,
              label: const Text('Get Current Location'),
              icon: const Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: _selectonmap,
              label: const Text('Select on Map'),
              icon: const Icon(Icons.map_rounded),
            ),
          ],
        ),
      ],
    );
  }
}
