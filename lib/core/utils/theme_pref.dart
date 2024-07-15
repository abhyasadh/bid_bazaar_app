import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared_preferences/app_prefs.dart';

final getThemeProvider = StateNotifierProvider<GetTheme, AppThemePref>(
      (ref) => GetTheme(
    ref.watch(appPrefsProvider),
  ),
);

class GetTheme extends StateNotifier<AppThemePref> {
  final AppPrefs appThemePrefs;

  GetTheme(this.appThemePrefs) : super(AppThemePref.system) {
    onInit();
  }

  onInit() async {
    final isDarkTheme = await appThemePrefs.getTheme();
    isDarkTheme.fold(
            (l) => state = AppThemePref.system,
            (r) => state = r
    );
  }

  updateTheme(String theme) {
    appThemePrefs.setTheme(theme);
    state = theme == 'Dark' ? AppThemePref.dark : theme == 'Light' ? AppThemePref.light : AppThemePref.system;
  }
}
