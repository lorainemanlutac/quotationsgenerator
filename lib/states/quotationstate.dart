import 'package:flutter/material.dart';
import 'package:quotationsgenerator/widgets/quotation.dart';

class QuotationState extends State<Quotation> {
  final _quotations = ['Music Box'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildQuotations(),
    );
  }

  Widget _buildQuotations() {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: _quotations.length,
        itemBuilder: (context, i) {
          if (i.isOdd) {
            return Divider();
          }

          return _buildRow(_quotations[i]);
        });
  }

  Widget _buildRow(quotation) {
    return ListTile(
      leading: Icon(
        Icons.article_outlined,
        color: Colors.red,
      ),
      title: Text(quotation),
    );
  }
}
