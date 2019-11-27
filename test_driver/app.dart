import 'package:flutter_driver/driver_extension.dart';
import 'package:flyflutter_fast_start/main.dart' as app;

void main() {
  // Подключаем driver_extension
  enableFlutterDriverExtension();

  // Вызываем функцию `main()` нашего приложения
  app.main();
}