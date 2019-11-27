import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flyflutter_fast_start/main.dart';

void main() {

  // функция testWidgets будет запускать тесты и предоставляет объект WidgetTester,
  // который позволяет создавать виджеты
  testWidgets('CounterWidget test', (WidgetTester tester) async {

    await tester.pumpWidget(MyApp());

    // Убедимся, что значение счетчика на старте равно 0, а не единице
    expect(find.text("0"), findsOneWidget);
    expect(find.text("1"), findsNothing);

    // Убедимся, что присутствует кнопка "плюса"
    expect(find.byIcon(Icons.add), findsOneWidget);

    // жмем на кнопку добавить
    await tester.tap(find.byIcon(Icons.add));
    // ждем отрисовки виджета после нажатия кнопки
    await tester.pump();

    // Убедимся, что значение счетчика увеличилось до единицы
    expect(find.text("1"), findsOneWidget);


  });
}