import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_reparaturservice/utils/globals.dart';

import 'ui/screens/splash.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
  
  runApp(
      ProviderScope(
        child: EasyLocalization(
            supportedLocales: const [Locale('en'), Locale('de')],
            path: 'assets/translations',
            fallbackLocale: const Locale('en', 'US'),
            child: const MyApp()),
      )
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height / 100;
    screenWidth = MediaQuery.of(context).size.width / 100;

    return MaterialApp(
        title: 'Global Reparaturservice',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
            primaryColor: const Color(0xff224D6F),
            useMaterial3: true,
            fontFamily: 'Poppins'),
        home: const Splash());
  }
}
