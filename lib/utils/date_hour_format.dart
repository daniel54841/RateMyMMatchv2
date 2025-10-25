import 'package:logger/logger.dart';
import 'package:rate_my_match_v2/utils/app_string.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

import '../initializer/initialize_languagues.dart';
class DateHoutFormat{
  ///
  static final Logger _logger = Logger();
  ///
  static String formatToHourMinute(String? timeWithSeconds) {
    try {
      if(timeWithSeconds == null){
        return AppString.dateTimeNull;
      }else{
        final DateFormat inputFormat = DateFormat("HH:mm:ss");
        final DateTime parsedTime = inputFormat.parseStrict(timeWithSeconds,);
        final DateFormat outputFormat = DateFormat("HH:mm");
        return outputFormat.format(parsedTime);
      }

    } on FormatException catch (e) {
      _logger.e("Error de formato al parsear '$timeWithSeconds': $e");
      return "Error: Formato inválido";
    } catch (e) {
      _logger.e("Error inesperado al formatear '$timeWithSeconds': $e");
      return "Error inesperado";
    }
  }
  ///
  static String? formatYearMonthDayToDayMonthYear(String? dateStringYMD) {
    try {
     if(dateStringYMD != null){
       final DateFormat inputFormat = DateFormat("yyyy-MM-dd");

       final DateTime parsedDate = inputFormat.parseStrict(dateStringYMD);

       final DateFormat outputFormat = DateFormat("dd-MM-yyyy");

       return outputFormat.format(parsedDate);
     }else{
       return AppString.dateTimeNull;
     }

    } on FormatException catch (e) {
      _logger.e("Error de formato al parsear la fecha '$dateStringYMD': $e");
      return "Error: Formato de fecha inválido";
    } catch (e) {
      _logger.e("Error inesperado al formatear la fecha '$dateStringYMD': $e");
      return "Error inesperado";
    }
  }
  /// Convierte un objeto [DateTime] a un String con el formato 'yyyy-MM-dd'.
  ///
  /// Si la fecha de entrada es nula, devuelve un string vacío.
  static String toYYYYMMDD(DateTime? date) {
    // Si la fecha es nula, retornamos un string vacío para evitar errores.
    if (date == null) {
      return '';
    }

    // Crea el formateador con el patrón deseado.
    final DateFormat formatter = DateFormat('yyyy-MM-dd');

    // Aplica el formato y retorna el string resultante.
    return formatter.format(date);
  }


}