import 'dart:async';

import 'package:bid_bazaar/core/storage/hive_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/app.dart';

void main() async {
  runZonedGuarded(() async {
    FlutterNativeSplash.preserve(
        widgetsBinding: WidgetsFlutterBinding.ensureInitialized());

    await Firebase.initializeApp();

    await HiveService().init();
    String? token = await HiveService().getAccessToken();
    FlutterNativeSplash.remove();

    // Initialize Awesome Notifications
    // AwesomeNotifications().initialize(
    //   null, // Replace with your app icon or set it to null
    //   [
    //     NotificationChannel(
    //       channelKey: 'basic_channel',
    //       channelName: 'Basic notifications',
    //       channelDescription: 'Notification channel for basic tests',
    //       defaultColor: Color(0xFF9D50DD),
    //       ledColor: Colors.white,
    //     ),
    //   ],
    // );

    // Set preferred orientations
    // await SystemChrome.setPreferredOrientations(
    //   [DeviceOrientation.portraitUp],
    // );
    runApp(
      ProviderScope(
        child: App(
          token: token,
        ),
      ),
    );
    // FlutterNativeSplash.remove();
  }, (error, stackTrace) {});
}
