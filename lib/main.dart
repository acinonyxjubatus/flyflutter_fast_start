import 'package:flutter/material.dart';
import 'package:flyflutter_fast_start/counter_bloc.dart';
import 'package:flyflutter_fast_start/counter_event.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StatelessWidget sample',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: Scaffold(
          backgroundColor: Colors.amber[300],
          appBar: AppBar(
            title: Text('Labels'),
          ),
          body: Center(child: CounterWidget())),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  final _bloc = CounterBloc();

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          color: Colors.amber[600],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    _bloc.counterEventSink.add(DecrementEvent());
                  },
                  child: Icon(Icons.remove)),
            ),
            StreamBuilder(
              stream: _bloc.counter,
              initialData: 0,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return Text('${snapshot.data}',
                    style: TextStyle(fontSize: 20.0));
              },
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () {
                    _bloc.counterEventSink.add(IncrementEvent());
                  },
                  child: Icon(Icons.add)),
            ),
          ],
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.dispose();
  }
}
