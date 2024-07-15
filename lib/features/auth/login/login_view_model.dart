import 'package:bid_bazaar/config/navigation/navigation_service.dart';
import 'package:bid_bazaar/config/routes/app_routes.dart';
import 'package:bid_bazaar/core/common/messages/snackbar.dart';
import 'package:bid_bazaar/core/storage/hive_service.dart';
import 'package:bid_bazaar/core/utils/biometric_setting.dart';
import 'package:bid_bazaar/features/bottom_navigation/nav_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import '../../../core/shared_preferences/app_prefs.dart';
import 'login_state.dart';

final loginViewModelProvider =
    StateNotifierProvider.autoDispose<LoginViewModel, LoginState>(
  (ref) => LoginViewModel(ref),
);

class LoginViewModel extends StateNotifier<LoginState> {
  final AutoDisposeStateNotifierProviderRef<LoginViewModel, LoginState> ref;

  LoginViewModel(this.ref)
      : super(LoginState.initialState(ref.watch(getBiometricSettingProvider)));

  void rememberMe() {
    state = state.copyWith(rememberMe: !state.rememberMe);
  }

  void updateNumber(TextEditingController controller) async {
    String? phone;
    phone = await ref.read(hiveServiceProvider).getPhone();
    controller.text = phone ?? '';
  }

  Future<void> login(String phone, String password) async {
    print(phone);
    print(password);

    state = state.copyWith(isLoading: true);

    if (password.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(password) &&
        RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[0-9]').hasMatch(password) &&
        RegExp(r'[@$!%*?&]').hasMatch(password)) {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore fireStore = FirebaseFirestore.instance;

      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: '+977$phone@bidbazaar.com',
          password: password,
        );

        User? user = userCredential.user;

        if (user != null) {
          DocumentSnapshot userDoc =
              await fireStore.collection('users').doc(user.uid).get();
          if (userDoc.exists) {
            ref
                .read(navViewModelProvider.notifier)
                .updateUser(data: userDoc.data() as Map<String, dynamic>);
            ref.read(navViewModelProvider.notifier).changeIndex(0);
            String? token = await user.getIdToken();
            if (token != null) {
              await ref
                  .read(hiveServiceProvider)
                  .setAccessToken(accessToken: token);
            }
            await ref.read(hiveServiceProvider).removePhone();
            if (state.rememberMe) {
              await ref.read(hiveServiceProvider).setPhone(phone: phone);
            }
            ref
                .read(navigationServiceProvider)
                .replaceWith(routeName: AppRoutes.homeRoute);
          }
        }
      } on FirebaseAuthException catch (e) {
        String? message;

        if (e.code == 'invalid-credential') {
          message = 'Invalid Credential!';
        } else if (e.code == 'network-request-failed') {
          message = 'No Internet Connection!';
        } else if (e.code == 'too-many-requests') {
          message =
              'All requests from this device are blocked due to unusual activity. Please try again later!';
        }

        showSnackBar(
            context: ref
                .read(navigationServiceProvider)
                .navigatorKey
                .currentContext!,
            error: true,
            message: message ?? e.message ?? 'An Unexpected Error Occurred!');
      }
    } else {
      await Future.delayed(
        const Duration(seconds: 2),
        () {
          state = state.copyWith(isLoading: false);
          showSnackBar(
            context: ref
                .read(navigationServiceProvider)
                .navigatorKey
                .currentContext!,
            error: true,
            message: 'Invalid Credentials!',
          );
        },
      );
    }
    state = state.copyWith(isLoading: false);
  }

  Future<void> authenticateWithBiometrics() async {
    LocalAuthentication auth = LocalAuthentication();
    bool authenticated = false;

    try {
      authenticated = await auth.authenticate(
        localizedReason: 'Scan Your Fingerprint to Login!',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {}
    if (!mounted) {
      return;
    }
    if (authenticated) {
      ProviderContainer()
          .read(appPrefsProvider)
          .getBiometricUnlock()
          .then((value) {
        value.fold(
          (l) => null,
          (r) => login(r[1].substring(4), r[2]),
        );
      });
    }
  }
}
