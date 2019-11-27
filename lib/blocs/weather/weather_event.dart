part of 'weather_bloc.dart';

@immutable
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

/// запрос получения погоды
class FetchWeather extends WeatherEvent {
  final Placemark placemark;

  const FetchWeather({@required this.placemark}) : assert(placemark != null);

  @override
  List<Object> get props => [placemark];
}

/// обновление погоды
class RefreshWeather extends WeatherEvent {
  final Placemark placemark;

  const RefreshWeather({@required this.placemark}) : assert(placemark != null);

  @override
  List<Object> get props => [placemark];
}
