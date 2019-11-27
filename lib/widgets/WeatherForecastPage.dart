import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyflutter_fast_start/LocationInfo.dart';
import 'package:flyflutter_fast_start/blocs/weather/weather_bloc.dart';
import 'package:flyflutter_fast_start/model/ForecastResponse.dart';
import 'package:flyflutter_fast_start/widgets/WeatherWidget.dart';
import 'package:timezone/standalone.dart';

import 'tools.dart';
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

  GlobalKey<ScaffoldState> _scaffoldKey;

  /// локальная переменная местоположения
  Placemark _placemark;

  Completer<void> _refreshCompleter;

  List<ListItem> _weatherForecast;

  @override
  void initState() {
    super.initState();
    _refreshCompleter = Completer<void>();
  }

  /// метод вызывается, когда состояние объектов, от которых зависит этот виджет, меняется
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // загружаем прогноз погоды
    _getWeather();
  }

  void _getWeather() {
    _initPlaceMark();
    if (_placemark != null) {
      BlocProvider.of<WeatherBloc>(context)
          .add(FetchWeather(placemark: _placemark)); // добавляем в блок событие загрузки погоды
    }
  }

  void _initPlaceMark() {
    if (_placemark == null || _placemark?.position == null) {
      //получем инстанс InheritedWidget-a
      var locationInfo = LocationInfo.of(context);
      //читаем оттуда мстоположение
      _placemark = locationInfo?.placemark;
    }
  }

  Widget get _weatherListView {
    return RefreshIndicator(
        onRefresh: () {
          BlocProvider.of<WeatherBloc>(context).add(
            RefreshWeather(placemark: _placemark), // добавляем в блок событие обновления погоды
          );
          return _refreshCompleter.future;
        },
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

  Widget get _refreshWrapper {
    return BlocListener<WeatherBloc, WeatherState>(
        listener: (context, state) {
          if (state is WeatherLoaded) {
            _refreshCompleter?.complete();
            _refreshCompleter = Completer();
          } else if (state is WeatherError && state.errorCause != null){
            // в случае ошибки показываем ошибку
            Scaffold.of(context).showSnackBar(SnackBar(
              content:
              Text("Error ${state.errorCause}"),
            ));
          }
        },
        child: _contentView);
  }

  Widget get _contentView {
    return BlocBuilder<WeatherBloc, WeatherState>(builder: (context, state) {
      if (state is WeatherEmpty) {
        return errorView(context, 'No data received. Pull to refresh');
      }
      if (state is WeatherLoading) {
        return loadingView();
      }
      if (state is WeatherError) {
        return errorView(context, state.errorMessage);
      }
      if (state is WeatherLoaded) {
        final weatherResponse = state.forecastResponse;
        initWeatherWithData(weatherResponse.list);
        return _weatherListView;
      }
      return null;
    });
  }

  void initWeatherWithData(List<ListItem> weatherData) {
    var itCurrentDay = DateTime.now();

    var deviceTimeZoneOffset = itCurrentDay.timeZoneOffset;
    var placeTimeZoneOffset = itCurrentDay.timeZoneOffset;

    try {
      var locationZone =
          "${_placemark.country}/${_placemark.administrativeArea?.replaceAll(" ", "_")}";
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
        DateTime(itNextDay.year, itNextDay.month, itNextDay.day, 0, 0, 0, 0, 1);
    var iterator = weatherData.iterator;
    while (iterator.moveNext()) {
      var weatherItem = iterator.current as WeatherListBean;
      weatherItem.timeZoneOffset = placeTimeZoneOffset;
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
    _weatherForecast = weatherForecastLocal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(getPlaceTitle()),
        ),
        body: _refreshWrapper);
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
