import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:rate_my_match_v2/data/providers/api/api_client.dart';
///
class InitializeApi{
  ///
  static final Logger _logg = Logger();
  
  static Future<void> initServices() async{
    _logg.i('Inicializando servicios...');

    ///ApiClient
    await Get.putAsync<ApiClient>(() => ApiClient(logger: _logg).init(), permanent: true);


  }
}