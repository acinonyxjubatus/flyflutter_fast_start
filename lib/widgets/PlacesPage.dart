import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyflutter_fast_start/blocs/places/places_bloc.dart';
import 'package:flyflutter_fast_start/model/placemark_local.dart';
import 'package:flyflutter_fast_start/widgets/MapPage.dart';
import 'package:flyflutter_fast_start/widgets/WeatherForecastPage.dart';
import 'package:flyflutter_fast_start/widgets/tools.dart';
import 'package:geolocator/geolocator.dart';

class PlacesPage extends StatefulWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  PlacesPage({Key key}) : super(key: key);

  _PlacesPageState createState() => _PlacesPageState(_scaffoldKey);
}

class _PlacesPageState extends State<PlacesPage> {
  _PlacesPageState(GlobalKey scaffoldKey) {
    this._scaffoldKey = scaffoldKey;
  }

  List<PlacemarkLocal> _placemarksList;

  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PlacesBloc>(context).add(FetchPlaces());
  }

  Widget get _contentView {
    return BlocBuilder<PlacesBloc, PlacesState>(builder: (context, state) {
      if (state is EmptyPlacesState) {
        return errorView(
            context, 'No places  yet. Tap Add button to create one');
      }
      if (state is LoadingPlacesState) {
        return loadingView();
      }
      if (state is ErrorPlacesState) {
        return errorView(context, "Exception while reading places");
      }
      if (state is ErrorAddingPlaceState) {
        showSnackBar(context, _scaffoldKey, "Exception while adding place");
      }
      if (state is LoadedPlacesState) {
        _placemarksList = state.placemarks;
      }
      if (state is RemovedPlaceState) {
        var index = -1;
        for (int i = 0; i < _placemarksList.length; i++) {
          if (_placemarksList[i].id == state.id) {
            index = i;
            break;
          }
        }
        if (index > 0) {
          _placemarksList.removeAt(index);
        }
      }
      if (state is ErrorRemovingPlaceState) {
        showSnackBar(context, _scaffoldKey, "Exception while deleting place");
      }
      return _placesListView;
    });
  }

  Widget get _placesListView {
    return Column(children: <Widget>[
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
                  _onRemoveItem(index);
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text("$place removed")));
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
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Places"),
      ),
      body: _contentView,
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

    BlocProvider.of<PlacesBloc>(context).add(AddPlaceEvent(placemark: result));
  }

  /// обработчик удаления элемента из списка
  void _onRemoveItem(int index) {
    BlocProvider.of<PlacesBloc>(context)
        .add(RemovePlaceEvent(placemarkLocal: _placemarksList[index]));
  }
}
