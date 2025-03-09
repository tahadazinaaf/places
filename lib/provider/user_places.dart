import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';
import 'package:places/models/place.dart';

class UserPleces extends StateNotifier<List<Place>> {
  UserPleces() : super([]);
  void addplace(String title, File image, PlaceLocation location) {
    final newplace = Place(title: title, image: image, location: location);
    state = [newplace, ...state];
  }
}

final userPlecesProvide = StateNotifierProvider<UserPleces, List<Place>>(
  (Ref) => UserPleces(),
);
