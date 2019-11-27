import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:flyflutter_fast_start/constants.dart';
import 'package:flyflutter_fast_start/model/forecast_response.dart';
import 'package:flyflutter_fast_start/repositories/weather/weather_api_client.dart';
import 'package:flyflutter_fast_start/repositories/weather/weather_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockHttpClient extends Mock implements http.Client {}

main() {
  WeatherApiClient apiClient;
  WeatherRepository weatherRepository;
  MockHttpClient mockClient;

  var testPlacemark = Placemark(
      name: 'test',
      country: 'test',
      position: Position(longitude: 0, latitude: 0));

  var uri;

  const String successJson =
      '{"city":{"id":1851632,"name":"Shuzenji","coord":{"lon":138.933334,"lat":34.966671},"country":"JP","timezone": 32400, "cod":"200","message":0.0045,"cnt":38,"list":[{"dt":1406106000,"main":{"temp":298.77,"temp_min":298.77,"temp_max":298.774,"pressure":1005.93,"sea_level":1018.18,"grnd_level":1005.93,"humidity":87,"temp_kf":0.26},"weather":[{"id":804,"main":"Clouds","description":"overcast clouds","icon":"04d"}],"clouds":{"all":88},"wind":{"speed":5.71,"deg":229.501},"sys":{"pod":"d"},"dt_txt":"2014-07-23 09:00:00"}]}}';

  setUp(() {
    mockClient = MockHttpClient();
    apiClient = WeatherApiClient(httpClient: mockClient);
    weatherRepository = WeatherRepository(weatherApiClient: apiClient);

    double lat = testPlacemark?.position?.latitude;
    double lng = testPlacemark?.position?.longitude;

    var queryParameters = {
      // подготавливаем параметры запроса
      'APPID': Constants.WEATHER_APP_ID,
      'units': 'metric',
      'lat': lat.toString(),
      'lon': lng.toString(),
    };

    uri = Uri.https(Constants.WEATHER_BASE_URL_DOMAIN,
        Constants.WEATHER_FORECAST_PATH, queryParameters);
  });

  group('fetchWeather', () {
    test('success response test', () async {

      // Возвращаем успешный результат
      when(mockClient.get(uri)).thenAnswer(
          (_) async => http.Response(successJson, 200, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              }));

      var response = await weatherRepository.getWeather(testPlacemark);
      // проверяем, что ответ пришел в виде [ResponseWrapper]
      expect(response, isInstanceOf<ResponseWrapper>());
      // и содержит корректный [ForecastResponse]
      expect(response.forecastResponse, isInstanceOf<ForecastResponse>());
      expect(response.errorResponse, null);
      expect(response.forecastResponse.city.name, "Shuzenji");
    });

    test('returns error message', () async {

      // Возвращаем неуспешный результат
      when(mockClient.get(uri)).thenAnswer(
          (_) async => http.Response('{"message":"Not Found"}', 404, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              }));

      var response = await weatherRepository.getWeather(testPlacemark);
      // проверяем, что ответ пришел в виде [ResponseWrapper]
      expect(response, isInstanceOf<ResponseWrapper>());
      // и содержит корректный [ErrorResponse]
      expect(response.errorResponse, isInstanceOf<ErrorResponse>());
      expect(response.forecastResponse, null);
      expect(response.errorResponse.message, "Not Found");
    });
  });

  tearDown(() {
    mockClient.close();
  });
}
