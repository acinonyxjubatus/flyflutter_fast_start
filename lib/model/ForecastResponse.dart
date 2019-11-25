import '../constants.dart';

class ErrorResponse {
  num cod;
  String message;
  ErrorResponse();

  ErrorResponse.withMessage(String _message) {
    this.message = _message;
  }

  static ErrorResponse fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ErrorResponse errorResponseBean = ErrorResponse();
    errorResponseBean.cod = map['cod'];
    errorResponseBean.message = map['message'].toString();
    return errorResponseBean;
  }

  Map toJson() => {"cod": cod, "message": message};
}

class ForecastResponse {
  String cod;
  String message;
  int cnt;
  List<WeatherListBean> list;
  CityBean city;

  static ForecastResponse fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    ForecastResponse forecastResponseBean = ForecastResponse();
    forecastResponseBean.cod = map['cod'];
    forecastResponseBean.message = map['message'].toString();
    forecastResponseBean.cnt = map['cnt'];
    forecastResponseBean.list = List()
      ..addAll(
          (map['list'] as List ?? []).map((o) => WeatherListBean.fromMap(o)));
    forecastResponseBean.city = CityBean.fromMap(map['city']);
    return forecastResponseBean;
  }

  Map toJson() => {
    "cod": cod,
    "message": message,
    "cnt": cnt,
    "list": list,
    "city": city,
  };
}

/// id : 1907296
/// name : "Tawarano"
/// coord : {"lat":35.0164,"lon":139.0077}
/// country : "none"

class CityBean {
  int id;
  String name;
  CoordBean coord;
  String country;

  static CityBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CityBean cityBean = CityBean();
    cityBean.id = map['id'];
    cityBean.name = map['name'];
    cityBean.coord = CoordBean.fromMap(map['coord']);
    cityBean.country = map['country'];
    return cityBean;
  }

  Map toJson() => {
    "id": id,
    "name": name,
    "coord": coord,
    "country": country,
  };
}

/// lat : 35.0164
/// lon : 139.0077

class CoordBean {
  double lat;
  double lon;

  static CoordBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CoordBean coordBean = CoordBean();
    coordBean.lat = map['lat'];
    coordBean.lon = map['lon'];
    return coordBean;
  }

  Map toJson() => {
    "lat": lat,
    "lon": lon,
  };
}

/// dt : 1485799200
/// main : {"temp":283.76,"temp_min":283.76,"temp_max":283.761,"pressure":1017.24,"sea_level":1026.83,"grnd_level":1017.24,"humidity":100,"temp_kf":0}
/// weather : [{"id":800,"main":"Clear","description":"clear sky","icon":"01n"}]
/// clouds : {"all":0}
/// wind : {"speed":7.27,"deg":15.0048}
/// rain : {}
/// sys : {"pod":"n"}
/// dt_txt : "2017-01-30 18:00:00"

class WeatherListBean extends ListItem {
  Duration timeZoneOffset;
  int dt;
  MainBean main;
  List<WeatherBean> weather;
  CloudsBean clouds;
  WindBean wind;
  RainBean rain;
  SysBean sys;
  String dtTxt;

  DateTime getDateTime() {
    var dateTime = DateTime.parse(dtTxt);
    if (timeZoneOffset != null) {
      return dateTime.add(timeZoneOffset);

      /// учитываем часовой пояс
    } else {
      return dateTime;
    }
  }

  String getIconUrl() {
    return Constants.WEATHER_IMAGES_URL + weather[0].icon + ".png";
  }

  static WeatherListBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    WeatherListBean listBean = WeatherListBean();
    listBean.dt = map['dt'];
    listBean.main = MainBean.fromMap(map['main']);
    listBean.weather = List()
      ..addAll(
          (map['weather'] as List ?? []).map((o) => WeatherBean.fromMap(o)));
    listBean.clouds = CloudsBean.fromMap(map['clouds']);
    listBean.wind = WindBean.fromMap(map['wind']);
    listBean.rain = RainBean.fromMap(map['rain']);
    listBean.sys = SysBean.fromMap(map['sys']);
    listBean.dtTxt = map['dt_txt'];
    return listBean;
  }

  Map toJson() => {
    "dt": dt,
    "main": main,
    "weather": weather,
    "clouds": clouds,
    "wind": wind,
    "rain": rain,
    "sys": sys,
    "dt_txt": dtTxt,
  };
}

/// pod : "n"

class SysBean {
  String pod;

  static SysBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    SysBean sysBean = SysBean();
    sysBean.pod = map['pod'];
    return sysBean;
  }

  Map toJson() => {
    "pod": pod,
  };
}

class RainBean {
  static RainBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    RainBean rainBean = RainBean();
    return rainBean;
  }

  Map toJson() => {};
}

/// speed : 7.27
/// deg : 15.0048

class WindBean {
  num speed;
  num deg;

  static WindBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    WindBean windBean = WindBean();
    windBean.speed = map['speed'];
    windBean.deg = map['deg'] as num;
    return windBean;
  }

  Map toJson() => {
    "speed": speed,
    "deg": deg,
  };
}

/// all : 0

class CloudsBean {
  int all;

  static CloudsBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    CloudsBean cloudsBean = CloudsBean();
    cloudsBean.all = map['all'];
    return cloudsBean;
  }

  Map toJson() => {
    "all": all,
  };
}

/// id : 800
/// main : "Clear"
/// description : "clear sky"
/// icon : "01n"

class WeatherBean {
  int id;
  String main;
  String description;
  String icon;

  static WeatherBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    WeatherBean weatherBean = WeatherBean();
    weatherBean.id = map['id'];
    weatherBean.main = map['main'];
    weatherBean.description = map['description'];
    weatherBean.icon = map['icon'];
    return weatherBean;
  }

  Map toJson() => {
    "id": id,
    "main": main,
    "description": description,
    "icon": icon,
  };
}

/// temp : 283.76
/// temp_min : 283.76
/// temp_max : 283.761
/// pressure : 1017.24
/// sea_level : 1026.83
/// grnd_level : 1017.24
/// humidity : 100
/// temp_kf : 0

class MainBean {
  num temp;
  num tempMin;
  num tempMax;
  num pressure;
  num seaLevel;
  num grndLevel;
  int humidity;
  num tempKf;

  static MainBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    MainBean mainBean = MainBean();
    mainBean.temp = map['temp'];
    mainBean.tempMin = map['temp_min'];
    mainBean.tempMax = map['temp_max'];
    mainBean.pressure = map['pressure'];
    mainBean.seaLevel = map['sea_level'];
    mainBean.grndLevel = map['grnd_level'];
    mainBean.humidity = map['humidity'];
    mainBean.tempKf = map['temp_kf'];
    return mainBean;
  }

  Map toJson() => {
    "temp": temp,
    "temp_min": tempMin,
    "temp_max": tempMax,
    "pressure": pressure,
    "sea_level": seaLevel,
    "grnd_level": grndLevel,
    "humidity": humidity,
    "temp_kf": tempKf,
  };
}

abstract class ListItem {}