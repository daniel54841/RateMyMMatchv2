import 'package:logger/logger.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

import '../initializer/initialize_languagues.dart';
class DateHoutFormat{
  ///
  static final Logger _logger = Logger();
  ///
  static String formatToHourMinute(String timeWithSeconds) {
    try {
      final DateFormat inputFormat = DateFormat("HH:mm:ss");
      final DateTime parsedTime = inputFormat.parseStrict(timeWithSeconds,);

      final DateFormat outputFormat = DateFormat("HH:mm");


      return outputFormat.format(parsedTime);

    } on FormatException catch (e) {
      _logger.e("Error de formato al parsear '$timeWithSeconds': $e");
      return "Error: Formato inválido";
    } catch (e) {
      _logger.e("Error inesperado al formatear '$timeWithSeconds': $e");
      return "Error inesperado";
    }
  }
  ///
  static String formatYearMonthDayToDayMonthYear(String dateStringYMD) {
    try {
      final DateFormat inputFormat = DateFormat("yyyy-MM-dd");

      final DateTime parsedDate = inputFormat.parseStrict(dateStringYMD);

     final DateFormat outputFormat = DateFormat("dd-MM-yyyy");

      return outputFormat.format(parsedDate);

    } on FormatException catch (e) {
      _logger.e("Error de formato al parsear la fecha '$dateStringYMD': $e");
      return "Error: Formato de fecha inválido";
    } catch (e) {
      _logger.e("Error inesperado al formatear la fecha '$dateStringYMD': $e");
      return "Error inesperado";
    }
  }
}