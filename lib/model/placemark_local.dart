import 'package:geolocator/geolocator.dart';

class PlacemarkLocal {
  int id;
  Placemark placemark;

  PlacemarkLocal({
    this.id,
    this.placemark,
  });

  factory PlacemarkLocal.fromMap(Map<String, dynamic> mapStr) =>
      new PlacemarkLocal(
          id: mapStr["id"],
          placemark: Placemark(
            name: mapStr["name"],
            isoCountryCode: mapStr["isoCountryCode"],
            country: mapStr["country"],
            administrativeArea: mapStr["administrativeArea"],
            subAdministrativeArea: mapStr["subAdministrativeArea"],
            position: Position(
              longitude: mapStr["longitude"],
              latitude: mapStr["latitude"],
              timestamp: mapStr["timestamp"],
            ),
          ));

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": placemark.name,
        "isoCountryCode": placemark.isoCountryCode,
        "country": placemark.country,
        "administrativeArea": placemark.administrativeArea,
        "subAdministrativeArea": placemark.subAdministrativeArea,
        "longitude": placemark.position?.longitude,
        "latitude": placemark.position?.latitude,
        "timestamp": placemark.position?.timestamp?.millisecondsSinceEpoch,
      };
}
