import 'package:intl/intl.dart';
import 'log_utils.dart';

class DateTimeUtils {
  const DateTimeUtils._internal();

  static String? format(String pattern, DateTime? dateTime) {
    String? formattedDate;
    try {
      if (dateTime != null) {
        formattedDate = DateFormat(pattern).format(dateTime);
      }
    } on Exception catch (e) {
      LogUtils.error('DateUtils', 'format', e.toString());
    }
    return formattedDate;
  }

  static DateTime? parse(String? formattedDate) {
    DateTime? dateTime;
    try {
      if (formattedDate != null) {
        dateTime = DateTime.tryParse(formattedDate);
      }
    } on Exception catch (e) {
      LogUtils.error('DateUtils', 'parse', e.toString());
    }
    return dateTime;
  }
}
