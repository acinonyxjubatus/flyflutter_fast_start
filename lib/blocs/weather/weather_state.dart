part of 'weather_bloc.dart';

@immutable
abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

/// пустой список
class WeatherEmpty extends WeatherState {}

/// в процессе загрузки
class WeatherLoading extends WeatherState {}

/// погода успешно загружена
class WeatherLoaded extends WeatherState {
  final ForecastResponse forecastResponse;

  const WeatherLoaded({@required this.forecastResponse}) : assert(forecastResponse != null);

  @override
  List<Object> get props => [forecastResponse];
}

/// ошибка
class WeatherError extends WeatherState {

  final dynamic errorMessage;
  final dynamic errorCause;

  const WeatherError({this.errorCause, this.errorMessage});

  @override
  List<Object> get props => [errorCause, errorMessage];
}