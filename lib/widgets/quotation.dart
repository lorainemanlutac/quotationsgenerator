import 'package:flutter/material.dart';
import 'package:quotationsgenerator/states/quotationstate.dart';

class Quotation extends StatefulWidget {
  final title;

  Quotation({Key key, @required this.title}) : super(key: key);

  @override
  QuotationState createState() => QuotationState();
}
