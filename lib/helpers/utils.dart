import 'package:intl/intl.dart';

// ignore: top_level_function_literal_block
var convertDate = (timestamp) {
  var parsedDateTime = DateTime.parse(timestamp).toLocal();

  return DateFormat.yMMMd().format(parsedDateTime) +
      ' ' +
      DateFormat.jm().format(parsedDateTime);
};

// ignore: top_level_function_literal_block
var validator = (type, value) {
  if (value == null || value.isEmpty) {
    return 'Please ' + (type == 'text' ? 'enter' : 'select') + ' some text';
  }
  return null;
};
