import 'package:bid_bazaar/config/routes/app_routes.dart';
import 'package:bid_bazaar/core/storage/hive_service.dart';
import 'package:bid_bazaar/features/bottom_navigation/nav_view_model.dart';
import 'package:bid_bazaar/features/settings/settings_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/navigation/navigation_service.dart';
import '../../core/common/messages/snackbar.dart';

final settingsViewModelProvider =
StateNotifierProvider<SettingsViewModel, SettingsState>(
      (ref) => SettingsViewModel(ref),
);

class SettingsViewModel extends StateNotifier<SettingsState> {
  final StateNotifierProviderRef ref;

  SettingsViewModel(this.ref) : super(SettingsState.initialState());

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await FirebaseAuth.instance.signOut();
      await ref.read(hiveServiceProvider).removeAccessToken();
      ref.read(navViewModelProvider.notifier).updateUser(data: null);
    } on FirebaseAuthException catch (e) {
      showSnackBar(
          context:
          ref.read(navigationServiceProvider).navigatorKey.currentContext!,
          error: true,
          message: e.message!
      );
    }

    await Future.delayed(const Duration(seconds: 2), () {
      state = state.copyWith(isLoading: false);
      ref.read(navigationServiceProvider).replaceWith(routeName: AppRoutes.loginRoute);
    });
  }
}
