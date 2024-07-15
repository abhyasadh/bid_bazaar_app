import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();
  static const int primaryColorValue = 0xFFFF6C44;
  static const Color primaryColor = Color(primaryColorValue);
  static const MaterialColor materialColor = MaterialColor(0xffff6c44, {
    50: Color(0xFFffb6a2),
    100: Color(0xFFffa78f),
    200: Color(0xFFff987c),
    300: Color(0xFFff8969),
    400: Color(0xFFff7b57),
    500: Color(0xFFff6c44),
    600: Color(0xFFe6613d),
    700: Color(0xFFcc5636),
    800: Color(0xFFb34c30),
    900: Color(0xFF994129),
  });
  static const Color darkScaffoldBackgroundColor = Color(0xFF000000);
  static const Color lightScaffoldBackgroundColor = Color(0xFFFFFFFF);
  
  static const Color errorColor = Color(0xFFE94D4D);
  static const Color successColor = Color(0xFF71CC35);
  static const Color linkColor = Color(0xFF37B5DF);

  static const String fontFamily = 'Blinker';

  static getApplicationTheme(bool isDark) {
    return ThemeData(
        useMaterial3: true,
        fontFamily: fontFamily,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primaryColor: primaryColor,
        primarySwatch: materialColor,
        scaffoldBackgroundColor: isDark ? darkScaffoldBackgroundColor : lightScaffoldBackgroundColor,
        colorScheme: isDark
            ? const ColorScheme.dark(
                primary: Color(0xff303030),
                secondary: Color(0xff101010),
                tertiary: Color(0xfff3f3f3))
            : const ColorScheme.light(
                primary: Color(0xfff3f3f3),
                secondary: Color(0xfffefefe),
                tertiary: Color(0xff303030),
              ),
        appBarTheme: AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: isDark ? Colors.black : Colors.white,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: isDark ? const Color(0xff303030) : const Color(0xfff3f3f3),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          prefixIconColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return const Color(0xffff6c44);
            }
            return Colors.grey;
          }),
          suffixIconColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return const Color(0xffff6c44);
            }
            return Colors.grey;
          }),
          errorStyle: const TextStyle(color: errorColor),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: errorColor,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: errorColor,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: primaryColor,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xffff6c44),
          ),
          labelMedium: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: ButtonStyle(
            shape: WidgetStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            padding:
                WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.all(0)),
            backgroundColor: WidgetStateProperty.all<Color>(
              const Color(0xffff6c44),
            ),
            fixedSize: WidgetStateProperty.all<Size>(
              const Size(double.infinity, 50),
            ),
          ),
        ),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent);
  }
}
