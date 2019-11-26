import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flyflutter_fast_start/model/ForecastResponse.dart';
import 'package:flyflutter_fast_start/repositories/repositories.dart';
import 'package:flyflutter_fast_start/widgets/tools.dart';
import 'package:timezone/standalone.dart';
import 'package:http/http.dart' as http;

import '../LocationInfo.dart';
import 'WeatherWidget.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class WeatherForecastPage extends StatefulWidget {
  final Placemark placemark;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  WeatherForecastPage(this.placemark);

  @override
  State<StatefulWidget> createState() {
    return _WeatherForecastPageState(placemark, _scaffoldKey);
  }
}

class _WeatherForecastPageState extends State<WeatherForecastPage> {
  _WeatherForecastPageState(Placemark place, GlobalKey scaffoldKey) {
    this._placemark = place;
    this._scaffoldKey = scaffoldKey;
  }

  WeatherRepository _weatherRepository;
  GlobalKey<ScaffoldState> _scaffoldKey;

  // локальная переменная местоположения
  Placemark _placemark;

  bool _isLoading = false;

  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    var httpClient = http.Client();
    var apiClient = WeatherApiClient(httpClient: httpClient);
    _weatherRepository = WeatherRepository(weatherApiClient: apiClient);
    _refreshCompleter = Completer<void>();
    _getWeather();
  }

  Future<void> _onRefresh() async {
    var weatherFuture = _weatherRepository.getWeather(_placemark);
    weatherFuture.then((_weatherForecast) {
      handleRepositoryResponse(_weatherForecast);
    });
    return _refreshCompleter.future;
  }

  // метод вызывается, когда состояние объектов, от которых зависит этот виджет, меняется
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _initPlaceMark();
    // загружаем прогноз погоды
    _getWeather();
  }


  void _initPlaceMark() {
    if (_placemark == null || _placemark?.position == null) {
      //получем инстанс InheritedWidget-a
      var locationInfo = LocationInfo.of(context);
      //читаем оттуда мстоположение
      _placemark = locationInfo?.placemark;
    }
  }

  void _getWeather() {
    // если местоположения нет, то показываем progressBar
    _isLoading = true;
    if (_placemark == null) {
      return;
    }
    var weatherFuture = _weatherRepository.getWeather(
        _placemark); // делаем запрос на получение погоды
    weatherFuture.then((weatherData) {
      // берем value response из future погоды
      handleRepositoryResponse(weatherData);
      _isLoading = false;
    });
  }

  void handleRepositoryResponse(ResponseWrapper responseWrapper) {
    if (responseWrapper.success) {
      initWeatherWithData(responseWrapper.forecastResponse.list);
    } else {
      showSnackBar(context, _scaffoldKey, responseWrapper.errorResponse.message);
    }
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

  void initWeatherWithData(List<ListItem> weatherData) {
    var itCurrentDay = DateTime.now();

    var deviceTimeZoneOffset = itCurrentDay.timeZoneOffset;
    var placeTimeZoneOffset = itCurrentDay.timeZoneOffset;

    try {
      var locationZone =
          "${_placemark.country}/${_placemark.administrativeArea.replaceAll(
          " ", "_")}";
      final placeTime =
      TZDateTime.from(itCurrentDay, getLocation(locationZone));
      placeTimeZoneOffset = placeTime.timeZoneOffset;
    } on Exception catch (e) {
      placeTimeZoneOffset = deviceTimeZoneOffset;
      debugPrint(e.toString());
    }

    var weatherForecastLocal = List<ListItem>();
    weatherForecastLocal.add(DayHeading(itCurrentDay)); // first heading
    var itNextDay = DateTime.now().add(Duration(days: 1));
    itNextDay =
        DateTime(
            itNextDay.year,
            itNextDay.month,
            itNextDay.day,
            0,
            0,
            0,
            0,
            1);
    var iterator = weatherData.iterator;
    while (iterator.moveNext()) {
      var weatherItem = iterator.current as WeatherListBean;
      weatherItem.timeZoneOffset = placeTimeZoneOffset;
      if (weatherItem.getDateTime().isAfter(itNextDay)) {
        itCurrentDay = itNextDay;
        itNextDay = itCurrentDay.add(Duration(days: 1));
        itNextDay = DateTime(
            itNextDay.year,
            itNextDay.month,
            itNextDay.day,
            0,
            0,
            0,
            0,
            1);
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
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(getPlaceTitle()),
        ),
        body: _pageToDisplay);
  }

  String getPlaceTitle() {
    var placeTitle = _placemark?.subAdministrativeArea;
    if (placeTitle == null || placeTitle?.isEmpty == true) {
      placeTitle = _placemark?.administrativeArea;
    }
    if (placeTitle == null || placeTitle?.isEmpty == true) {
      placeTitle = _placemark?.name;
    }
    return placeTitle ?? "";
  }

}
