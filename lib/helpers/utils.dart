import 'package:intl/intl.dart';

// ignore: top_level_function_literal_block
var convertDate = (timestamp) {
  final parsedDateTime = DateTime.parse(timestamp).toLocal();

  return DateFormat.yMMMd().format(parsedDateTime) +
      ' ' +
      DateFormat.jm().format(parsedDateTime);
};

// ignore: top_level_function_literal_block
var validator = (type, val, defaultVal) {
  if (val == null || val == defaultVal) {
    return 'Required';
  }
  return null;
};
