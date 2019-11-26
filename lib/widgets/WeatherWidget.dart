import 'package:flutter/material.dart';
import 'package:flyflutter_fast_start/model/ForecastResponse.dart';
import 'package:intl/intl.dart';

abstract class ListItemWidget {}

class WeatherListItem extends StatelessWidget implements ListItemWidget {
  static var _dateFormatTime = DateFormat('HH:mm');

  final WeatherListBean weather;

  WeatherListItem(this.weather);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(_dateFormatTime.format(weather.getDateTime()),
                  style: Theme.of(context).textTheme.subhead)),
          Image.network(weather.getIconUrl()),
          Text((weather.main.temp.toInt()).toString() + " \u00B0C",
              style: Theme.of(context).textTheme.subhead)
        ]));
  }
}

class HeadingListItem extends StatelessWidget implements ListItemWidget {
  static var _dateFormatWeekDay = DateFormat('EEEE, MMM dd');
  final DayHeading dayHeading;

  HeadingListItem(this.dayHeading);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: ListTile(
          title: Column(children: [
            Text(
              "${_dateFormatWeekDay.format(dayHeading.dateTime)}",
              style: Theme.of(context).textTheme.headline,
            ),
            Divider()
          ]),
        ));
  }
}

class DayHeading extends ListItem {
  final DateTime dateTime;

  DayHeading(this.dateTime);
}
