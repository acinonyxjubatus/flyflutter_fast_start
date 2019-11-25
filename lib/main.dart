import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Counter',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: Scaffold(
        backgroundColor: Colors.amber[300],
        appBar: AppBar(
          title: Text('Counter on Flutter'),
        ),
        body: Center(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  HintLabel('tap - to decrement'),
                  SizedBox(height: 8.0),
                  CounterWidget(),
                  SizedBox(height: 8.0),
                  HintLabel('tap + to increment')
                ])),
      ),
    );
  }
}

class CounterWidget extends StatefulWidget {
  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 42;

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
            IconButton(
                onPressed: () {
                  _decrement();
                },
                icon: Icon(Icons.remove)),
            Text('$_count', style: TextStyle(fontSize: 20.0)),
            IconButton(
                onPressed: () {
                  _increment();
                },
                icon: Icon(Icons.add)),
          ],
        ));
  }

  void _increment() {
    setState(() {
      _count++;
    });
  }

  void _decrement() {
    setState(() {
      _count--;
    });
  }
}

class HintLabel extends StatelessWidget {
  final String text;

  const HintLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: Colors.amber[200]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text,
            style: TextStyle(color: Colors.grey[700])),
      ),
    );
  }
}
