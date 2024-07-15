import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../failure/failure.dart';

final appPrefsProvider = Provider((ref) {
  return AppPrefs();
});

enum AppThemePref { light, dark, system }

class AppPrefs {
  late SharedPreferences _sharedPreferences;

  Future<Either<Failure, bool>> setTheme(String theme) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      _sharedPreferences.setString('Theme', theme);
      return const Right(true);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, AppThemePref>> getTheme() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      final isDark = _sharedPreferences.getString('Theme');
      if (isDark == 'Dark') {
        return const Right(AppThemePref.dark);
      } else if (isDark == 'Light'){
        return const Right(AppThemePref.light);
      } else {
        return const Right(AppThemePref.system);
      }
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, bool>> setBiometricUnlock(List<String> value) async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      if (value[0]=='true') {
        _sharedPreferences.setStringList('useBiometric', value);
      } else {
        _sharedPreferences.remove('useBiometric');
      }
      return const Right(true);
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }

  Future<Either<Failure, List<String>>> getBiometricUnlock() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      final isUsing = _sharedPreferences.getStringList('useBiometric');
      if (isUsing == null) {
        return Left(Failure(error: 'Error'));
      } else if (isUsing[0]=='true'){
        return Right(isUsing);
      } else {
        return Left(Failure(error: 'Error'));
      }
    } catch (e) {
      return Left(Failure(error: e.toString()));
    }
  }
}
