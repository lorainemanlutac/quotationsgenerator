import 'package:flutter/material.dart';
import 'package:quotationsgenerator/assets/translations/en.dart';
import 'package:quotationsgenerator/styles/css.dart';
import 'package:quotationsgenerator/features/quotations/quotations.dart';

void main() => runApp(QuotationsGenerator());

class QuotationsGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: Quotations(),
      ),
      theme: ThemeData(
        primarySwatch: primarySwatch,
        textTheme: textTheme,
      ),
    );
  }
}
