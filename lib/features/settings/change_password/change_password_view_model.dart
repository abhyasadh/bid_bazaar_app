import 'package:bid_bazaar/config/navigation/navigation_service.dart';
import 'package:bid_bazaar/core/common/messages/snackbar.dart';
import 'package:bid_bazaar/features/bottom_navigation/nav_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'change_password_state.dart';

final changePasswordViewModelProvider =
StateNotifierProvider.autoDispose<ChangePasswordViewModel, ChangePasswordState>(
      (ref) => ChangePasswordViewModel(ref),
);

class ChangePasswordViewModel extends StateNotifier<ChangePasswordState> {
  final AutoDisposeStateNotifierProviderRef<ChangePasswordViewModel, ChangePasswordState> ref;

  ChangePasswordViewModel(this.ref) : super(ChangePasswordState.initialState());

  Future<void> changePassword(String oldPassword, String newPassword) async {
    state = state.copyWith(isLoading: true);

    if (oldPassword.length >= 8 &&
        RegExp(r'[A-Z]').hasMatch(oldPassword) &&
        RegExp(r'[a-z]').hasMatch(oldPassword) &&
        RegExp(r'[0-9]').hasMatch(oldPassword) &&
        RegExp(r'[@$!%*?&]').hasMatch(oldPassword)) {
      FirebaseAuth auth = FirebaseAuth.instance;
      User currentUser = auth.currentUser!;

      try {
        final userCredential = EmailAuthProvider.credential(
          email: '${ref.read(navViewModelProvider).userData?['phone']}@bidbazaar.com',
          password: oldPassword,
        );

        await currentUser.reauthenticateWithCredential(userCredential).then((value){
          currentUser.updatePassword(newPassword).then((value) {
            showSnackBar(
              context: ref.read(navigationServiceProvider).navigatorKey.currentContext!,
              message: 'Password Changed Successfully!',
            );
            ref.read(navigationServiceProvider).goBack();
          });
        });
        
      } on FirebaseAuthException catch (e) {
        String? message;

        if (e.code=='invalid-credential'){
          message = 'Incorrect Password!';
        } else if (e.code == 'network-request-failed'){
          message = 'No Internet Connection!';
        } else if (e.code == 'too-many-requests'){
          message = 'All requests from this device are blocked due to unusual activity. Please try again later!';
        }

        showSnackBar(
            context:
            ref.read(navigationServiceProvider).navigatorKey.currentContext!,
            error: true,
            message: message ?? e.message ?? 'An Unexpected Error Occurred!'
        );
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
            message: 'Incorrect Password!',
          );
        },
      );
    }
    state = state.copyWith(isLoading: false);
  }
}
