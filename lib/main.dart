import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flyflutter_fast_start/LocationInfo.dart';
import 'package:flyflutter_fast_start/widgets/PlacesPage.dart';
import 'package:timezone/timezone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var byteData = await rootBundle
      .load('packages/timezone/data/2019b.tzf');
  initializeDatabase(byteData.buffer.asUint8List());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LocationInheritedWidget(
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Weather report',
            theme: ThemeData(
              primarySwatch: Colors.amber,
            ),
            home: PlacesPage()));
  }
}
