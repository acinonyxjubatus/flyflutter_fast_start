import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flyflutter_fast_start/location_info.dart';

import 'constants.dart';
import 'weather_widget.dart';
import 'model/forecast_response.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';

class WeatherForecastPage extends StatefulWidget {
  WeatherForecastPage();

  @override
  State<StatefulWidget> createState() {
    return _WeatherForecastPageState();
  }
}

class _WeatherForecastPageState extends State<WeatherForecastPage> {
  // локальная переменная местоположения
  Placemark _placemark;

  bool _isLoading = false;

  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
    _loadData();
  }

  Future<void> _onRefresh() async {
    var weatherFuture =
        getWeather(_placemark.position.latitude, _placemark.position.longitude);
    weatherFuture.then((_weatherForecast) {
      initWeatherWithData(_weatherForecast, _placemark);
    });
    return _refreshCompleter.future;
  }

  // метод вызывается, когда состояние объектов, от которых зависит этот виджет, меняется
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    //получем инстанс InheritedWidget-a
    var locationInfo = LocationInfo.of(context);
    //читаем оттуда местоположение
    _placemark = locationInfo?.placemark;
    // загружаем прогноз погоды
    _loadData();
  }

  void _loadData() {
    // если местоположения нет, то показываем progressBar
    _isLoading = true;
    if (_placemark == null) {
      return;
    }
    var weatherFuture = getWeather(_placemark?.position?.latitude,
        _placemark?.position?.longitude); // делаем запрос на получение погоды
    weatherFuture.then((weatherData) {
      // берем value response из future погоды
      initWeatherWithData(weatherData, _placemark);
      _isLoading = false;
    });
  }

  Widget get _pageToDisplay {
    if (_isLoading) {
      return _loadingView;
    } else {
      return _contentView;
    }
  }

  Widget get _loadingView {
    return Center(
      child: CircularProgressIndicator(), // виджет прогресса
    );
  }

  List<ListItem> _weatherForecast;

  _WeatherForecastPageState();

  Widget get _contentView {
    return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
            itemCount: _weatherForecast == null ? 0 : _weatherForecast.length,
            itemBuilder: (BuildContext context, int index) {
              final item = _weatherForecast[index];
              if (item is WeatherListBean) {
                return WeatherListItem(item);
              } else if (item is DayHeading) {
                return HeadingListItem(item);
              } else
                throw Exception("wrong type");
            }));
  }

  Future<List<ListItem>> getWeather(double lat, double lng) async {
    var queryParameters = {
      // подготавливаем параметры запроса
      'APPID': Constants.WEATHER_APP_ID,
      'units': 'metric',
      'lat': lat.toString(),
      'lon': lng.toString(),
    };

    var uri = Uri.https(Constants.WEATHER_BASE_URL,
        Constants.WEATHER_FORECAST_URL, queryParameters);
    var response = await http.get(uri); // выполняем запрос и ждем результата

    if (response.statusCode == 200) {
      var forecastResponse =
          ForecastResponse.fromMap(json.decode(response.body));
      if (forecastResponse.cod == "200") {
        // в случае успешного ответа парсим JSON и возвращаем список с прогнозом
        return forecastResponse.list;
      } else {
        // в случае ошибки показываем ошибку
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("Error ${forecastResponse.cod}"),
        ));
      }
    } else {
      // в случае ошибки показываем ошибку
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Error occured while loading data from server"),
      ));
    }
    return List<ListItem>();
  }

  void initWeatherWithData(List<ListItem> weatherData, Placemark placemark) {
    var itCurrentDay = DateTime.now();
    var timeZoneOffset = itCurrentDay.timeZoneOffset;
    var weatherForecastLocal = List<ListItem>();
    weatherForecastLocal.add(DayHeading(itCurrentDay)); // first heading
    var itNextDay = DateTime.now().add(Duration(days: 1));
    itNextDay =
        DateTime(itNextDay.year, itNextDay.month, itNextDay.day, 0, 0, 0, 0, 1);
    var iterator = weatherData.iterator;
    while (iterator.moveNext()) {
      var weatherItem = iterator.current as WeatherListBean;
      weatherItem.timeZoneOffset = timeZoneOffset;
      if (weatherItem.getDateTime().isAfter(itNextDay)) {
        itCurrentDay = itNextDay;
        itNextDay = itCurrentDay.add(Duration(days: 1));
        itNextDay = DateTime(
            itNextDay.year, itNextDay.month, itNextDay.day, 0, 0, 0, 0, 1);
        weatherForecastLocal.add(DayHeading(itCurrentDay)); // next heading
      } else {
        weatherForecastLocal.add(weatherItem);
      }
    }
    setState(() {
      _weatherForecast = weatherForecastLocal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Weather report',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text(getPlaceTitle()),
            ),
            body: _pageToDisplay));
  }

  String getPlaceTitle() {
    var placeTitle = _placemark?.subAdministrativeArea;
    if (placeTitle?.isEmpty == true) {
      placeTitle = _placemark?.administrativeArea;
    }
    return placeTitle ?? "";
  }
}
