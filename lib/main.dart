import 'package:flutter/material.dart';

// Stateful Widgets
import 'package:quotesgenerator/widgets/quotations.dart';

void main() => runApp(QuotesGenerator());

class QuotesGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('MLKJ Sash and Upholstery Furniture Shop'),
        ),
        body: Center(
          child: Quotations(),
        ),
      ),
    );
  }
}
