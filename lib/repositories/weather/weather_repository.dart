import 'dart:async';

import 'package:flyflutter_fast_start/repositories/weather/weather_api_client.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

class WeatherRepository {
  final WeatherApiClient weatherApiClient;

  WeatherRepository({@required this.weatherApiClient})
      : assert(weatherApiClient != null);

  Future<ResponseWrapper> getWeather(Placemark placeMark) async {
    return await weatherApiClient.fetchWeather(placeMark);
  }

}