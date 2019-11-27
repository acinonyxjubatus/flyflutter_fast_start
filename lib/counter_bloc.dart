import 'dart:async';

import 'package:flyflutter_fast_start/counter_event.dart';


class CounterBloc {
  int _counter = 0;

  final _counterStateController = StreamController<int>();

  StreamSink<int> get _inCounter => _counterStateController.sink;

  Stream<int> get counter => _counterStateController.stream;

  final _counterEventController = StreamController<CounterEvent>();

  Sink<CounterEvent> get counterEventSink => _counterEventController.sink;

  CounterBloc() {
    _counterEventController.stream.listen(_eventToState);
  }

  void _eventToState(CounterEvent event) {
    if (event is IncrementEvent) {
      _counter++;
    } else if (event is DecrementEvent) {
      _counter--;
    } else {
      throw Exception('wrong Event type');
    }
    _inCounter.add(_counter);
  }

  void dispose() {
    _counterStateController.close();
    _counterEventController.close();
  }
}
