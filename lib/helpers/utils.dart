import 'package:intl/intl.dart';

var convertDate = (timestamp) {
  var parsedDateTime = DateTime.parse(timestamp).toLocal();

  return DateFormat.yMMMd().format(parsedDateTime) +
      ' ' +
      DateFormat.jm().format(parsedDateTime);
};
