import 'package:intl/intl.dart';

class DateTimeService {
  // ignore: strict_top_level_inference
  static formateDate(DateTime? dateTime) {
    final dateFormat = DateFormat.yMd();
    if (dateTime != null) return dateFormat.format(dateTime);
  }
}
