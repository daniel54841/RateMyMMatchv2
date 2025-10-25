import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:rate_my_match_v2/initializer/initialize_api.dart';
import 'package:rate_my_match_v2/initializer/initialize_languagues.dart';
import 'package:rate_my_match_v2/theme/app_theme.dart';

import 'navigation/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitializeApi.initServices();
  await InitializeLanguagues.initializeTimeZones();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
     /* themeMode: ThemeMode.light,
      theme: AppTheme.lightTheme,*/
      initialRoute: AppPages.home,
      getPages: AppPages.routes,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // Inglés
        Locale('es', ''), // Español
      ],
      locale: const Locale('es'),

    );
  }
}
