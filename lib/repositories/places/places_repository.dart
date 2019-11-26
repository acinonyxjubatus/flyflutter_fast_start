import 'dart:async';
import 'package:flyflutter_fast_start/model/placemark_local.dart';
import 'package:geolocator/geolocator.dart';

import '../db/db_provider.dart';

class PlacesRepository {
  PlacesRepository();

  // первоначальный тестовый список
  List<Placemark> _initPlaces = [
    Placemark(
        name: 'Moscow',
        country: 'Europe',
        administrativeArea: 'Moscow',
        position: Position(longitude: 37.6206, latitude: 55.7532)),
    Placemark(
        name: 'New York',
        country: 'America',
        administrativeArea: 'New York',
        position: Position(longitude: -73.9739, latitude: 40.7715)),
    Placemark(
        name: 'Los Angeles',
        country: 'America',
        administrativeArea: 'Los_Angeles',
        position: Position(longitude: -122.4663, latitude: 37.7705)),
    Placemark(
        name: 'Paris',
        country: 'Europe',
        administrativeArea: 'Paris',
        position: Position(longitude: 2.2950, latitude: 48.8753)),
    Placemark(
        name: 'London',
        country: 'Europe',
        administrativeArea: 'London',
        position: Position(longitude: -0.1254, latitude: 51.5011)),
  ];

  /// получение списка всех мест
  Future<List<PlacemarkLocal>> getPlaces() async {
    var placesFuture = DBProvider.db.getAllPlacemarks();
    var placesList = await placesFuture;
    if (placesList.isEmpty) {
      putPlaces(_initPlaces);
    }
    return await DBProvider.db.getAllPlacemarks();
  }

  /// добавление места
  addPlace(Placemark placemark) async {
    await DBProvider.db.addPlace(placemark);
  }

  /// обновление места
  updatePlacemark(PlacemarkLocal newPlacemark) async {
    await DBProvider.db.updatePlacemark(newPlacemark);
  }

  /// добавление списка мест
  putPlaces(List<Placemark> places) async {
    for (var place in places) {
      await DBProvider.db.addPlace(place);
    }
  }

  /// удаление места
  deletePlacemark(int id) async {
    DBProvider.db.deletePlacemark(id);
  }
}
