import 'package:flutter/material.dart';
import 'package:places/models/place.dart';
import 'package:places/screens/MapScreen.dart';

class PlacesDetails extends StatelessWidget {
  const PlacesDetails({super.key, required this.place});
  final Place place;
  String get locationImage {
    final latitude = place.location.latitude;
    final longitude = place.location.longitude;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C$latitude,$longitude&key=AIzaSyD0KnKT9bI41k1b79mHprdrPfO_1RabO5s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.fill,
            height: double.infinity,
            width: double.infinity,
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              top: 0,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => MapScreen(
                            location: place.location,
                            isSelecting: false,
                          ),
                        ),
                      );
                    },
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage(locationImage),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
