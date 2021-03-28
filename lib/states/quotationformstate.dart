import 'package:flutter/material.dart';
import 'package:quotationsgenerator/helpers/constants.dart';
import 'package:quotationsgenerator/styles/css.dart';
import 'package:quotationsgenerator/widgets/quotationform.dart';

class QuotationFormState extends State<QuotationForm> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: formAppBarBackground,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: secondarySwatch,
        title: formTitle,
      ),
      body: Text('Quotation'),
    );
  }
}
