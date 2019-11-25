import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class ListItemWidget {}

class WeatherListItem extends StatelessWidget implements ListItemWidget {
  static var _dateFormat = DateFormat('yyyy-MM-dd – HH:mm');

  final Weather weather;

  WeatherListItem(this.weather);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(children: [
          Expanded(flex: 3, child: Text(_dateFormat.format(weather.dateTime))),
          Expanded(
            flex: 1,
            child: Text(weather.degree.toString() + " C"),
          ),
          Expanded(flex: 1, child: Image.network(weather.getIconUrl()))
        ]));
  }
}

class HeadingListItem extends StatelessWidget implements ListItemWidget {
  static var _dateFormatWeekDay = DateFormat('EEEE');
  final DayHeading dayHeading;

  HeadingListItem(this.dayHeading);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(children: [
        Text(
          "${_dateFormatWeekDay.format(dayHeading.dateTime)} ${dayHeading.dateTime.day}.${dayHeading.dateTime.month}",
          style: Theme.of(context).textTheme.headline,
        ),
        Divider()
      ]),
    );
  }
}

abstract class ListItem {}

class Weather extends ListItem {
  static const String weatherURL = "http://openweathermap.org/img/w/";

  DateTime dateTime;
  num degree;
  int clouds;
  String iconURL;

  String getIconUrl() {
    return weatherURL + iconURL + ".png";
  }

  Weather(this.dateTime, this.degree, this.clouds, this.iconURL);
}

class DayHeading extends ListItem {
  final DateTime dateTime;

  DayHeading(this.dateTime);
}
