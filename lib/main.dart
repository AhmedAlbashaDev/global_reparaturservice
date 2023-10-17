import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'core/globals.dart';
import 'firebase_options.dart';
import 'view/screens/splash.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {

  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {

    var body = notification.body as Map<String , dynamic>;

    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      'Route id #${body['id']}',
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          // TODO add a proper drawable resource to android, for now using
          //      one that already exists in example app.
          icon: 'notification_icon',
        ),
      ),
    );
  }
}

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),EasyLocalization.ensureInitialized()]);
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await setupFlutterNotifications();

  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/.env");

  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISH'] ?? '';


  //dotenv.env['STRIPE_SECRET']


  runApp(
      ProviderScope(
        child: EasyLocalization(
            supportedLocales: const [Locale('en'), Locale('de')],
            path: 'assets/translations',
            fallbackLocale: const Locale('en'),
            startLocale: const Locale('en'),
            child: const MyApp()),
      )
    );

  // runApp(
  //     ProviderScope(child: DevicePreview(
  //       enabled: true,
  //       builder: (context) => EasyLocalization(
  //           supportedLocales: const [Locale('en'), Locale('de')],
  //           path: 'assets/translations',
  //           fallbackLocale: const Locale('en', 'US'),
  //           child: const MyApp()),
  //     ))
  // );

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();


    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // showFlutterNotification(message);
      // Navigator.pushNamed(
      //   context,
      //   '/message',
      //   arguments: MessageArguments(message, true),
      // );
    });
  }
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
            fontFamily: 'Poppins',
            inputDecorationTheme: InputDecorationTheme(
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(color: Colors.grey.shade300 , width: 1.5)
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(color: Theme.of(context).primaryColor , width: 1.5)
                ),
                focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: BorderSide(color: Colors.red , width: 1.5)
                ),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(color: Colors.red , width: 1.5)
                ),
                errorStyle: const TextStyle(height: .7)
            )
        ),
        home: const Splash());
  }
}
