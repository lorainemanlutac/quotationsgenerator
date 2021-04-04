import 'package:flutter/material.dart';

/// Common styles.
final addIcon = const Icon(Icons.add);
final biggerFont = TextStyle(fontSize: 18.0);
final boxing = EdgeInsets.only(top: 24.0, right: 8.0, bottom: 8.0, left: 8.0);
final fieldBorder = OutlineInputBorder(
  borderSide: const BorderSide(color: Colors.white, width: 2.0),
);
final formAppBarBackground = Color(0xffC7A288);
final formPadding = EdgeInsets.all(8.0);
final fullFormWidth = (context) => MediaQuery.of(context).size.width - 16.0;
final iconSize = 40.0;
final padding = EdgeInsets.all(16.0);
final primarySwatch = Colors.red;
final secondarySwatch = Color(0xffAC6464);
final textTheme = TextTheme(
  bodyText2: biggerFont,
  subtitle1: biggerFont,
);
