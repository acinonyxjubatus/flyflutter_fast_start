import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget errorView(BuildContext context, String text) {
  return Center(
    child:
        Text(text, style: Theme.of(context).textTheme.caption), // виджет ошибки
  );
}

Widget loadingView() {
  return Center(
    child: CircularProgressIndicator(), // виджет прогресса
  );
}

showSnackBar(GlobalKey<ScaffoldState> scaffoldKey,
    String errorText) {
  final snackBar = SnackBar(content: Text(errorText));
  scaffoldKey.currentState.showSnackBar(snackBar);
}
