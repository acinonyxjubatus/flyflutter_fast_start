import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: Text('This is Flutter'),
        ),
        body: Center(
          child: Text('Hello World!',
              style: TextStyle(
                fontSize: 42.0, // делаем текст большим
                fontWeight: FontWeight.bold,  // жирным
                color: Colors.white, // белым
              )
          ),
        ),
      ),
    );
  }
}
