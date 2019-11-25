import 'package:flutter/material.dart';

import 'weather_widget.dart';

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
    return _WeatherForecastPageState();
  }
}

class _WeatherForecastPageState extends State<WeatherForecastPage> {
  List<ListItem> weatherForecast = List<ListItem>();

  @override
  void initState() {
    var itCurrentDay = DateTime.now();
    weatherForecast.add(DayHeading(itCurrentDay)); // first heading
    List<ListItem> weatherData = [
      Weather(itCurrentDay, 20, 90, "04d"),
      Weather(itCurrentDay.add(Duration(hours: 3)), 23, 50, "03d"),
      Weather(itCurrentDay.add(Duration(hours: 6)), 25, 50, "02d"),
      Weather(itCurrentDay.add(Duration(hours: 9)), 28, 50, "01d"),
      Weather(itCurrentDay.add(Duration(hours: 12)), 28, 60, "04d"),
      Weather(itCurrentDay.add(Duration(hours: 15)), 28, 60, "03d"),
      Weather(itCurrentDay.add(Duration(hours: 18)), 28, 60, "10d"),
      Weather(itCurrentDay.add(Duration(hours: 21)), 28, 60, "01d"),
      Weather(itCurrentDay.add(Duration(hours: 24)), 28, 60, "04d"),
      Weather(itCurrentDay.add(Duration(hours: 27)), 28, 60, "03d"),
      Weather(itCurrentDay.add(Duration(hours: 30)), 28, 60, "10d"),
      Weather(itCurrentDay.add(Duration(hours: 33)), 28, 60, "02d"),
      Weather(itCurrentDay.add(Duration(hours: 36)), 28, 60, "03d"),
      Weather(itCurrentDay.add(Duration(hours: 39)), 28, 60, "10d"),
      Weather(itCurrentDay.add(Duration(hours: 42)), 28, 60, "02d"),
      Weather(itCurrentDay.add(Duration(hours: 45)), 28, 60, "02d")
    ];
    var itNextDay = DateTime.now().add(Duration(days: 1));
    itNextDay = DateTime(
        itNextDay.year, itNextDay.month, itNextDay.day, 0, 0, 0, 0, 1);
    var iterator = weatherData.iterator;
    while (iterator.moveNext()) {
      var weatherDateTime = iterator.current as Weather;
      if (weatherDateTime.dateTime.isAfter(itNextDay)) {
        itCurrentDay = itNextDay;
        itNextDay = itCurrentDay.add(Duration(days: 1));
        itNextDay = DateTime(
            itNextDay.year, itNextDay.month, itNextDay.day, 0, 0, 0, 0, 1);
        weatherForecast.add(DayHeading(itCurrentDay)); // next heading
      } else {
        weatherForecast.add(iterator.current);
      }
    }
    super.initState();
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
                itemCount: weatherForecast.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = weatherForecast[index];
                  if (item is Weather) {
                    return WeatherListItem(item);
                  } else if (item is DayHeading) {
                    return HeadingListItem(item);
                  } else
                    throw Exception("wrong type");
                })));
  }
}
