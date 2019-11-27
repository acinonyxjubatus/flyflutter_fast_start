import 'dart:developer';

import 'package:flyflutter_fast_start/model/forecast_response.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:meta/meta.dart';
import 'dart:convert';

import '../../constants.dart';

class WeatherApiClient {
  final http.Client httpClient;

  WeatherApiClient({@required this.httpClient}) : assert(httpClient != null);

  Future<ResponseWrapper> fetchWeather(Placemark placeMark) async {
    if (placeMark == null) {
      return null;
    }

    double lat = placeMark?.position?.latitude;
    double lng = placeMark?.position?.longitude;

    var queryParameters = {
      // подготавливаем параметры запроса
      'APPID': Constants.WEATHER_APP_ID,
//      'APPID': Constants.WEATHER_APP_ID_ERROR_TEST,
      'units': 'metric',
      'lat': lat.toString(),
      'lon': lng.toString(),
    };

    var uri = Uri.https(Constants.WEATHER_BASE_URL_DOMAIN,
        Constants.WEATHER_FORECAST_PATH, queryParameters);

    log('request: ${uri.toString()}');

    // выполняем запрос и ждем результат
    var response = await httpClient.get(uri);

    log('response: ${response?.body}');

    if (response != null) {
      // парсим JSON и возвращаем список с прогнозом
      if (response.statusCode == 200) {
        var forecastResponse =
            ForecastResponse.fromMap(json.decode(response.body));
        return ResponseWrapper(
            success: true, forecastResponse: forecastResponse);
      } else {
        var errorResponse = ErrorResponse.fromMap(json.decode(response.body));
        return ResponseWrapper(success: false, errorResponse: errorResponse);
      }
    } else {
      var error = ErrorResponse.withMessage("http response was null!");
      return ResponseWrapper(success: false, errorResponse: error);
    }
  }
}

class ResponseWrapper {
  ResponseWrapper(
      {bool success: false,
      ErrorResponse errorResponse,
      ForecastResponse forecastResponse}) {
    this.success = success;
    this.errorResponse = errorResponse;
    this.forecastResponse = forecastResponse;
  }

  bool success;
  ErrorResponse errorResponse;
  ForecastResponse forecastResponse;
}
