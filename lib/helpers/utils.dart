import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quotationsgenerator/assets/translations/en.dart';

// ignore: top_level_function_literal_block
Function convertDate = (timestamp) {
  DateTime parsedDateTime = DateTime.parse(timestamp).toLocal();

  return DateFormat.yMMMd().format(parsedDateTime);
};

// ignore: top_level_function_literal_block
Function convertDateTime = (timestamp) {
  DateTime parsedDateTime = DateTime.parse(timestamp).toLocal();

  return '${convertDate(timestamp)} ${DateFormat.jm().format(parsedDateTime)}';
};

// ignore: top_level_function_literal_block
Function showSnackBar = (context, onPressed) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      action: SnackBarAction(
        label: undo,
        onPressed: onPressed,
        textColor: Colors.yellow,
      ),
      content: Text(deleted),
      duration: Duration(seconds: 5),
    ),
  );
};

// ignore: top_level_function_literal_block
Function validator = (val, {defaultVal = '', min = 0, max = 0}) {
  if (val == defaultVal || val == null || val == '0.00') {
    return 'Required';
  }
  if (min != 0 && val.trim().length < min) {
    return 'Min $min';
  }
  if (max != 0 && val.trim().length > max) {
    return 'Max $max';
  }

  return null;
};
