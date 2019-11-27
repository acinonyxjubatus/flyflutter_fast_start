import 'dart:io';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Weather app test', () {
    // С помощью Finder-ов and находим виджет Text с ключом 'сurrent_position'
    final currentPositionTextFinder = find.byValueKey('сurrent_position');

    FlutterDriver driver;

    // Подключаемся к Flutter driver-у
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // После выполения теста отключаемся
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Текущее местоположение', () async {

      // ждем 3 секунды пока загрузится список мест
      sleep(Duration(seconds: 3));

      // Убеждаемся, что виджет содержит соответствующий текст
      expect(await driver.getText(currentPositionTextFinder), "Current position");
    });

    test('Загрузка погоды для текущего места', () async {
      // Нажимаем по виджету текущей погоды
      await driver.tap(currentPositionTextFinder);

      // ждем 5 секунд пока погода и экран загрузятся
      sleep(Duration(seconds: 5));

      // Находим список с погодой
      final listView = find.byValueKey('weather_listview');
      // Поскольку у нас прогноз состоит из 5 дней по 7 элементов в каждом,
      // то в списке будет как миниму 30 строк, и 30-ая строка будет в конце
      final thirtyElement = find.byValueKey('weatherListItem_30');

      // убеждаемся, что список прокручивается до третьего дня с погодой
      await driver.scrollUntilVisible(
        // Указываем список в качестве параметра
        listView,
        // И элемент, который мы ищем
        thirtyElement,
        // С помощью отрицательного значения dyScroll скроллим список вниз
        dyScroll: -200.0,
      );

      sleep(Duration(seconds: 2)); // просто ждем, чтобы осознать свой успех
    });
  });
}