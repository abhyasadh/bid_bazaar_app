import 'package:bid_bazaar/config/navigation/navigation_service.dart';
import 'package:bid_bazaar/core/shared_preferences/app_prefs.dart';
import 'package:bid_bazaar/core/utils/connectivity_notifier.dart';
import 'package:bid_bazaar/core/utils/theme_pref.dart';
import 'package:bid_bazaar/features/bottom_navigation/nav_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../config/routes/app_routes.dart';
import '../config/themes/app_theme.dart';

class App extends ConsumerWidget {
  final String? token;
  const App({super.key, required this.token,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(connectivityProvider) == ConnectivityStatus.isConnected) {
      ref.read(navViewModelProvider.notifier).updateUser();
    }
    final theme = ref.watch(getThemeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: ref.read(navigationServiceProvider).navigatorKey,
      theme: AppTheme.getApplicationTheme(theme == AppThemePref.system ? MediaQuery.of(context).platformBrightness == Brightness.dark : theme == AppThemePref.dark ? true : false),
      initialRoute: token == null ? AppRoutes.loginRoute : AppRoutes.homeRoute,
      routes: AppRoutes.getApplicationRoute(),
    );
  }
}
