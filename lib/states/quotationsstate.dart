import 'package:flutter/material.dart';

// Stateful Widgets
import 'package:quotesgenerator/widgets/quotations.dart';

// Styles
import 'package:quotesgenerator/styles/css.dart';

class QuotationsState extends State<Quotations> {
  final _quotations = ['Music Box'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildQuotations(),
    );
  }

  Widget _buildQuotations() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _quotations.length,
        itemBuilder: (context, i) {
          final index = i == 0 ? 0 : i ~/ 2;

          if (i.isOdd) {
            return Divider();
          }

          return _buildRow(_quotations[index]);
        });
  }

  Widget _buildRow(quotation) {
    return ListTile(
      title: Text(quotation, style: biggerFont),
    );
  }
}
