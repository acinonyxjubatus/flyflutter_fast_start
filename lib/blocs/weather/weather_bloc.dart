import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flyflutter_fast_start/model/forecast_response.dart';
import 'package:flyflutter_fast_start/repositories/weather/weather_api_client.dart';
import 'package:flyflutter_fast_start/repositories/weather/weather_repository.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';

part 'weather_event.dart';

part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc({@required this.weatherRepository})
      : assert(weatherRepository != null);

  @override
  WeatherState get initialState => WeatherEmpty();

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is FetchWeather) {
      yield WeatherLoading();
      try {
        final ResponseWrapper response =
            await weatherRepository.getWeather(event.placemark);
        if (response.success) {
          yield WeatherLoaded(forecastResponse: response.forecastResponse);
        } else {
          var message = "${response.errorResponse?.cod} ${response.errorResponse?.message}";
          yield WeatherError(errorMessage: errorMessage, errorCause: message);
        }
      } catch (_) {
        yield WeatherError(errorMessage: errorMessage, errorCause: _.toString());
      }
    }
    if (event is RefreshWeather) {
      try {
        final ResponseWrapper response =
        await weatherRepository.getWeather(event.placemark);
        if (response.success) {
          yield WeatherLoaded(forecastResponse: response.forecastResponse);
        } else {
          var message = "${response.errorResponse?.cod} ${response.errorResponse?.message}";
          yield WeatherError(errorMessage: errorMessage, errorCause: message);
        }
      } catch (_) {
        yield WeatherError(errorMessage: errorMessage, errorCause: _.toString());
      }
    }
  }

  static const String errorMessage = "Error while fetching weather";
}
