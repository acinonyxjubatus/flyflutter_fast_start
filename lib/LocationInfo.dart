import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';

class LocationInfo extends InheritedWidget {
  final Placemark placemark;

  LocationInfo(this.placemark, Widget child)
      : super(
          child: child,
        );

  // статичный метод для получения инстанса класса
  static LocationInfo of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(LocationInfo);

  @override
  bool updateShouldNotify(LocationInfo oldLocationInfo) {
    var oldLocationTime = oldLocationInfo
            ?.placemark?.position?.timestamp?.millisecondsSinceEpoch ??
        0;
    var newLocationTime =
        placemark?.position?.timestamp?.millisecondsSinceEpoch ?? 0;

    // сравниваем время в объектах местоположения, чтобы определить, нужно ли обновлять виджеты
    if (oldLocationTime == 0 && newLocationTime == 0) {
      // для случая первой загрузки
      return true;
    }
    return oldLocationTime < newLocationTime;
  }
}

class LocationInheritedWidget extends StatefulWidget {
  static LocationInfo of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(LocationInfo) as LocationInfo;

  const LocationInheritedWidget({this.child, Key key}) : super(key: key);

  final Widget child;

  @override
  _LocationInheritedState createState() => _LocationInheritedState();
}

class _LocationInheritedState extends State<LocationInheritedWidget> {
  // локальная переменная
  Placemark _placemark;

  // вся логика получения местоположения инкапсулируется в этом виджете-обертке
  void _loadData() {
    var locationFuture = getLocation(); // получаем future на геопозицию
    locationFuture.then((newPosition) {
      // берем value из результат future
      var placeFuture = getPlacemark(newPosition);
      placeFuture.then((newPlaceMark) {
        onPositionChange(newPlaceMark);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void onPositionChange(Placemark newPlacemark) {
    setState(() {
      // обновляем локальную переменную
      // после чего произойдет вызов метода [build]
      _placemark = newPlacemark;
    });
  }

  @override
  Widget build(BuildContext context) {
    // в методе build происходит создание нового инстанса [LocationInfo]
    return LocationInfo(_placemark, widget.child);
  }

  Future<Position> getLocation() async {
    Geolocator geoLocator = Geolocator()..forceAndroidLocationManager = true;
    Position position = await geoLocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low); // получаем геопозицию
    return position;
  }

  Future<Placemark> getPlacemark(Position position) async {
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(
        position.latitude,
        position.longitude); // определяем название места по геопозиции
    if (placemark.isNotEmpty) {
      return placemark[
          0]; // возвращаем первый элемент из списка полученных вариантов
    }
    return null;
  }
}
