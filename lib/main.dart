import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flyflutter_fast_start/location_info.dart';
import 'package:flyflutter_fast_start/repositories/repositories.dart';
import 'package:flyflutter_fast_start/widgets/places_page.dart';
import 'package:injector/injector.dart';
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
  initInjector();

  BlocSupervisor.delegate = SimpleBlocDelegate();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<WeatherBloc>(
        builder: (context) => WeatherBloc(),
      ),
      BlocProvider<PlacesBloc>(
        builder: (context) => PlacesBloc(),
      ),
    ],
    child: MyApp(),
  ));
//  runApp(MyApp(weatherRepository: weatherRepository, placesRepository: placesRepository));
}

void initInjector() {
  // получаем статический инстанс инжектора
  Injector injector = Injector.appInstance;
  // регистрируем объект http.Client-а в дереве зависимостей
  injector.registerSingleton<http.Client>((injector) {
    return http.Client();
  });
  // регистрируем объект WeatherApiClient-а в дереве зависимостей
  injector.registerSingleton<WeatherApiClient>((injector) {
    var httpClient = injector.getDependency<http.Client>();
    return WeatherApiClient(httpClient: httpClient);
  });
  // регистрируем объект WeatherRepository-а в дереве зависимостей
  injector.registerSingleton<WeatherRepository>((injector) {
    var webApiClient = injector.getDependency<WeatherApiClient>();
    return WeatherRepository(weatherApiClient: webApiClient);
  });
  // регистрируем объект PlacesRepository-а в дереве зависимостей
  injector.registerSingleton<PlacesRepository>((injector) {
    return PlacesRepository();
  });
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
