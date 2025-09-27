import 'package:get/get.dart';
import '../view/home/home_view.dart';

part 'app_routes.dart'; // Importante: enlaza con app_routes.dart

class AppPages {
  ///
  static const home = Routes.HOME; // Ruta inicial

  static final routes = [
    GetPage(
      name: Routes.HOME,
      page: () => HomeView(),

    ),

  ];
}