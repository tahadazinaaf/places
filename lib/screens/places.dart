import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/models/place.dart';
import 'package:places/provider/user_places.dart';
import 'package:places/screens/add_place.dart';
import 'package:places/widgets/places_list.dart';

class Places extends ConsumerWidget {
  const Places({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Place> userplace = ref.watch(userPlecesProvide);
    return Scaffold(
      appBar: AppBar(
        title: Text("your place"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const AddPlace(),
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: PlacesList(
          places: userplace,
        ),
      ),
    );
  }
}
