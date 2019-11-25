import 'package:flutter/material.dart';
import 'package:flyflutter_fast_start/map_page.dart';
import 'package:flyflutter_fast_start/weather_forecast_page.dart';
import 'package:geolocator/geolocator.dart';

class PlacesPage extends StatefulWidget {
  PlacesPage({Key key}) : super(key: key);

  _PlacesPageState createState() => _PlacesPageState();
}

class _PlacesPageState extends State<PlacesPage> {

  // первоначальный тестовый список
  List<Placemark> _places = [
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Places"),
      ),
      body: Column(children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Expanded(
            child: InkWell(
              onTap: () => _onItemTapped(null),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("Current position",
                    textAlign: TextAlign.left,
                    style: new TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                    )),
              ),
            ),
          )
        ]),
        Divider(
          height: 4,
          thickness: 2,
        ),
        Expanded(
            child: ListView.builder(
          itemCount: _places.length,
          itemBuilder: (context, index) {
            final place = _places[index];
            return Dismissible(
              key: Key(place.name),
              onDismissed: (direction) {
                setState(() {
                  _places.removeAt(index);
                });
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("$place removed")));
              },
              background: Container(
                color: Colors.red,
              ),
              child: ListTile(
                title: Text(_preparePlaceTitle(place)),
                onTap: () => _onItemTapped(place),
              ),
            );
          },
        )),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _onAddNew();
        },
        label: Text('Add place'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
    );
  }

  /// генерирует название места на основе объекта [Placemark]
  String _preparePlaceTitle(Placemark placemark) {
    var placeTitle = "";
    if (placemark.country != null) {
      placeTitle = placemark.country;
    }
    if (placemark.administrativeArea != null) {
      placeTitle = placeTitle +", " + placemark.administrativeArea;
    } else if (placemark.name != null) {
      placeTitle = placeTitle + ", " + placemark.name;
    }
    return placeTitle;
  }

  /// Обработчик нажатия на элемент списка - переход на экран погоды
  void _onItemTapped(Placemark place) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WeatherForecastPage(place)),
    );
  }

  /// Обработчик нажатия на плавающую кнопку - добавление нового места
  void _onAddNew() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapPage()),
    ); // ждем добавленное место

    setState(() {
      if (result != null) {
        _places.add(result);
      }
    });
  }
}
