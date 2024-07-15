import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared_preferences/app_prefs.dart';

final getBiometricSettingProvider = StateNotifierProvider<GetBiometricSetting, bool>(
      (ref) => GetBiometricSetting(
    ref.watch(appPrefsProvider),
  ),
);

class GetBiometricSetting extends StateNotifier<bool> {
  final AppPrefs appSensorPrefs;

  GetBiometricSetting(this.appSensorPrefs) : super(false) {
    onInit();
  }

  onInit() async {
    final canUseSensor = await appSensorPrefs.getBiometricUnlock();
    canUseSensor.fold((l) => state = false, (r) => state = r[0] == 'true');
  }

  updateBiometricSetting(List<String> data) {
    appSensorPrefs.setBiometricUnlock(data);
    state = data[0] == 'true' ? true : false;
  }
}
