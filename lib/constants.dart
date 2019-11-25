class Constants {
  static const String WEATHER_BASE_SCHEME = 'https://';
  static const String WEATHER_BASE_URL = 'api.openweathermap.org';
  static const String WEATHER_IMAGES_PATH = "/img/w/";
  static const String WEATHER_IMAGES_URL =
      WEATHER_BASE_SCHEME + WEATHER_BASE_URL + WEATHER_IMAGES_PATH;
  static const String WEATHER_FORECAST_URL = "/data/2.5/forecast";
  static const String WEATHER_APP_ID = "<INSERT YOUR API KEY HERE>"; // fixme use another key
}
