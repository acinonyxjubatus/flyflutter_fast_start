import 'package:flutter_test/flutter_test.dart';
import 'package:flyflutter_fast_start/counter_bloc.dart';
import 'package:flyflutter_fast_start/counter_event.dart';

void main() {
  CounterBloc counterBloc;

  /// вызывается до начала тестов
  setUp(() {
    counterBloc = CounterBloc();
  });

  test('Counter test', () {
    counterBloc.counterEventSink.add(IncrementEvent());
    expect(counterBloc.counter, emits(1));
  });

  /// вызывается после окончания тестов
  tearDown(() {
    counterBloc.dispose();
  });
}
