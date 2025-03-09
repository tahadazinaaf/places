import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location, // Make it optional
    this.isSelecting = true,
  });

  final PlaceLocation? location; // Nullable type
  final bool isSelecting;

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    LatLng initialLatLng = widget.location != null
        ? LatLng(widget.location!.latitude, widget.location!.longitude)
        : const LatLng(37.7749, -122.4194); // Default location (San Francisco)

    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isSelecting ? 'Pick your location' : 'Your location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: initialLatLng,
          zoom: 16,
        ),
        markers: {
          if (widget.location != null)
            Marker(
              markerId: const MarkerId('x1'),
              position: initialLatLng,
            )
        },
      ),
    );
  }
}
