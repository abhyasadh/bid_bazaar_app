import 'dart:async';
import 'package:bid_bazaar/config/routes/app_routes.dart';
import 'package:bid_bazaar/features/auth/details/details_view.dart';
import 'package:bid_bazaar/features/auth/password/password_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/navigation/navigation_service.dart';
import '../../../core/common/messages/snackbar.dart';
import 'otp_state.dart';

final otpViewModelProvider = StateNotifierProvider.autoDispose<OTPViewModel, OTPState>(
  (ref) => OTPViewModel(ref),
);

class OTPViewModel extends StateNotifier<OTPState> {
  final AutoDisposeStateNotifierProviderRef ref;
  Timer? _countdownTimer;

  OTPViewModel(this.ref) : super(OTPState.initialState());

  void startCountdownTimer() {
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (state.timerCountDown > 1) {
        state = state.copyWith(timerCountDown: state.timerCountDown - 1);
      } else {
        timer.cancel();
        state = state.copyWith(isResendButtonDisabled: false);
      }
    });
  }

  void resetTimer() {
    _countdownTimer?.cancel();

    state = state.copyWith(
      timerCountDown: 60,
      isResendButtonDisabled: true,
    );

    startCountdownTimer();
  }

  Future<bool?> verifyOTP(String phone, String verificationId, String otp, Purpose purpose) async {
    state = state.copyWith(isLoading: true);

    if (RegExp(r'^[0-9]{6}').hasMatch(otp)) {
      try {
        FirebaseAuth auth = FirebaseAuth.instance;

        PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otp,
        );

        UserCredential userCredential = await auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          state = state.copyWith(isLoading: false);
          ref.read(navigationServiceProvider).replaceWith(page: purpose == Purpose.signup ? DetailsView(user: userCredential.user!,) : PasswordView(purpose: purpose, user: userCredential.user!,));
        } else {
          showSnackBar(
              error: true,
              context: ref
                  .read(navigationServiceProvider)
                  .navigatorKey
                  .currentContext!,
              message: 'Invalid OTP!');
          return false;
        }
      } catch (e) {
        state = state.copyWith(isLoading: false);
        showSnackBar(
            error: true,
            context: ref
                .read(navigationServiceProvider)
                .navigatorKey
                .currentContext!,
            message: 'Invalid OTP!');
        return false;
      }
    }
    return null;
  }
}
