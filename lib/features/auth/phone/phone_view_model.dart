import 'package:bid_bazaar/config/routes/app_routes.dart';
import 'package:bid_bazaar/features/auth/otp/otp_view.dart';
import 'package:bid_bazaar/features/auth/phone/phone_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/navigation/navigation_service.dart';
import '../../../core/common/messages/snackbar.dart';

final phoneViewModelProvider =
    StateNotifierProvider.autoDispose<PhoneViewModel, PhoneState>(
  (ref) => PhoneViewModel(ref),
);

class PhoneViewModel extends StateNotifier<PhoneState> {
  final StateNotifierProviderRef ref;

  PhoneViewModel(this.ref) : super(PhoneState.initialState());

  void sendOTP(String phone, Purpose purpose) async {
    state = state.copyWith(isLoading: true);

    String? verId;
    FirebaseAuth auth = FirebaseAuth.instance;
    final phoneNumber = phone.trim();

    if (phoneNumber.isEmpty) {
      state = state.copyWith(isLoading: false);
      return null;
    }

    final querySnapshot = await FirebaseFirestore.instance.collection('users').where('phone', isEqualTo: '+977$phone').get();
    if ((purpose == Purpose.signup && querySnapshot.docs.isEmpty) ||
        (purpose == Purpose.reset && querySnapshot.docs.isNotEmpty)) {
      await auth.verifyPhoneNumber(
        phoneNumber: '+977$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) async {},
        verificationFailed: (FirebaseAuthException e) {
          showSnackBar(
              error: true,
              context: ref
                  .read(navigationServiceProvider)
                  .navigatorKey
                  .currentContext!,
              message: 'An Error Occurred!');
        },
        timeout: const Duration(seconds: 60),
        codeSent: (String verificationId, int? resendToken) {
          verId = verificationId;
          state = state.copyWith(isLoading: false);
          ref.read(navigationServiceProvider).navigateTo(
              page: OTPView(
                  phone: phone, verificationId: verId, purpose: purpose));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } else {
      state = state.copyWith(isLoading: false);
      if (purpose == Purpose.signup && querySnapshot.docs.isNotEmpty) {
        showSnackBar(
            error: true,
            context: ref
                .read(navigationServiceProvider)
                .navigatorKey
                .currentContext!,
            message: 'User already exists!');
      } else if (purpose == Purpose.reset && querySnapshot.docs.isEmpty) {
        showSnackBar(
            error: true,
            context: ref
                .read(navigationServiceProvider)
                .navigatorKey
                .currentContext!,
            message: 'This number is not associated with any account!');
      }
    }
  }
}
