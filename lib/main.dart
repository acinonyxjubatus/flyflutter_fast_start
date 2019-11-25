import 'dart:convert';

import 'package:flutter/material.dart';

import 'Constants.dart';
import 'WeatherWidget.dart';
import 'model/ForecastResponse.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WeatherForecastPage("Moscow");
  }
}

class WeatherForecastPage extends StatefulWidget {
  WeatherForecastPage(this.cityName);

  final String cityName;

  @override
  State<StatefulWidget> createState() {
    return _WeatherForecastPageState(55.75, 37.61);
  }
}

class _WeatherForecastPageState extends State<WeatherForecastPage> {
  final double latitude;
  final double longitude;

  List<ListItem> weatherForecast;

  _WeatherForecastPageState(this.latitude, this.longitude);

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

  @override
  void initState() {
    super.initState();
    var itCurrentDay = DateTime.now();
    var dataFuture = getWeather(latitude, longitude);
    dataFuture.then((val) {
      var weatherForecastLocal = List<ListItem>();
      weatherForecastLocal.add(DayHeading(itCurrentDay)); // first heading
      List<ListItem> weatherData = val;
      var itNextDay = DateTime.now().add(Duration(days: 1));
      itNextDay = DateTime(
          itNextDay.year, itNextDay.month, itNextDay.day, 0, 0, 0, 0, 1);
      var iterator = weatherData.iterator;
      while (iterator.moveNext()) {
        var weatherDateTime = iterator.current as WeatherListBean;
        if (weatherDateTime.getDateTime().isAfter(itNextDay)) {
          itCurrentDay = itNextDay;
          itNextDay = itCurrentDay.add(Duration(days: 1));
          itNextDay = DateTime(
              itNextDay.year, itNextDay.month, itNextDay.day, 0, 0, 0, 0, 1);
          weatherForecastLocal.add(DayHeading(itCurrentDay)); // next heading
        } else {
          weatherForecastLocal.add(iterator.current);
        }
      }
      setState(() {
        weatherForecast = weatherForecastLocal;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ListView sample',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: Scaffold(
            appBar: AppBar(
              title: Text('Weather forecast'),
            ),
            body: ListView.builder(
                itemCount: weatherForecast == null ? 0 : weatherForecast.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = weatherForecast[index];
                  if (item is WeatherListBean) {
                    return WeatherListItem(item);
                  } else if (item is DayHeading) {
                    return HeadingListItem(item);
                  } else
                    throw Exception("wrong type");
                })));
  }
}
