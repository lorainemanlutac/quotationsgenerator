import 'package:flutter/material.dart';

final biggerFont = TextStyle(fontSize: 18.0);
final iconSize = 40.0;
final padding = 16.0;
final secondarySwatch = Color(0xffAC6464);
final formAppBarBackground = Color(0xffC7A288);
final primarySwatch = Colors.red;
final textTheme = TextTheme(
  bodyText2: biggerFont,
  subtitle1: biggerFont,
);
final addIcon = const Icon(Icons.add);
final formPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 8);
final fieldBorder = OutlineInputBorder(
  borderSide: const BorderSide(color: Colors.white, width: 2.0),
);
