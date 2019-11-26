import 'package:flutter/material.dart';
import 'package:flyflutter_fast_start/widgets/map_page.dart';
import 'package:flyflutter_fast_start/widgets/weather_forecast_page.dart';
import 'package:flyflutter_fast_start/model/placemark_local.dart';
import 'package:flyflutter_fast_start/repositories/places/places_repository.dart';
import 'package:geolocator/geolocator.dart';

class PlacesPage extends StatefulWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  PlacesPage({Key key}) : super(key: key);

  _PlacesPageState createState() => _PlacesPageState(_scaffoldKey);
}

class _PlacesPageState extends State<PlacesPage> {
  GlobalKey<ScaffoldState> _scaffoldKey;

  PlacesRepository placesRepository;

  _PlacesPageState(GlobalKey scaffoldKey) {
    this._scaffoldKey = scaffoldKey;
  }

  List<PlacemarkLocal> _placemarksList = List<PlacemarkLocal>();

  @override
  void initState() {
    super.initState();
    placesRepository = PlacesRepository();
    _getPlaces();
  }

  void _getPlaces() {
    var placesFuture = placesRepository.getPlaces();
    placesFuture.then((places) {
      setState(() {
        _placemarksList = places;
      });
    });
  }

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
              itemCount: _placemarksList.length,
              itemBuilder: (context, index) {
                final place = _placemarksList[index];
                return Dismissible(
                  key: Key(place.placemark.name),
                  onDismissed: (direction) {
                    _onItemRemove(place);
                  },
                  background: Container(
                    color: Colors.red,
                  ),
                  child: ListTile(
                    title: Text(_preparePlaceTitle(place.placemark)),
                    onTap: () => _onItemTapped(place.placemark),
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
      placeTitle = placeTitle + ", " + placemark.administrativeArea;
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

    if (result != null) {
      await placesRepository.addPlace(result);
      _getPlaces();
    }
  }

  void _onItemRemove(PlacemarkLocal placemarkLocal) async {
    await placesRepository.deletePlacemark(placemarkLocal.id);
    setState(() {
      _placemarksList.remove(placemarkLocal);
    });
    Scaffold.of(context).showSnackBar(
        SnackBar(content: Text("${placemarkLocal.placemark.name} removed")));
  }
}
