import 'package:logger/logger.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
class InitializeLanguagues{


  ///
  static Future<void> initializeTimeZones() async {
    tz.initializeTimeZones();
     }
}