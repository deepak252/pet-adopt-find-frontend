

import 'package:intl/intl.dart';

abstract class DateTimeUtils{

  /// Eg. Jan 17, 2023
  static String formatMMMDDYYYY(DateTime date){
    return DateFormat.yMMMd().format(date);
  }

  /// Eg. 10:23 AM
  static String formatHHMM(DateTime date){
    return DateFormat('hh:mm a').format(date);
  }
}