import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyflutter_fast_start/LocationInfo.dart';
import 'package:flyflutter_fast_start/repositories/repositories.dart';
import 'package:flyflutter_fast_start/widgets/PlacesPage.dart';
import 'package:timezone/timezone.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

import 'blocs/blocs.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
}

void main() async {
  // initialize timezone
  WidgetsFlutterBinding.ensureInitialized();
  var byteData = await rootBundle.load('packages/timezone/data/2019b.tzf');
  initializeDatabase(byteData.buffer.asUint8List());

  BlocSupervisor.delegate = SimpleBlocDelegate();

  final WeatherRepository weatherRepository = WeatherRepository(
    weatherApiClient: WeatherApiClient(
      httpClient: http.Client(),
    ),
  );

  final PlacesRepository placesRepository = PlacesRepository();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<WeatherBloc>(
        builder: (context) => WeatherBloc(weatherRepository: weatherRepository),
      ),
      BlocProvider<PlacesBloc>(
        builder: (context) => PlacesBloc(placesRepository: placesRepository),
      ),
    ],
    child: MyApp(),
  ));
//  runApp(MyApp(weatherRepository: weatherRepository, placesRepository: placesRepository));
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