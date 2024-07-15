import 'dart:io';

import 'package:bid_bazaar/features/auth/password/password_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/navigation/navigation_service.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/common/messages/snackbar.dart';

final passwordViewModelProvider =
    StateNotifierProvider<PasswordViewModel, PasswordState>((ref) {
  return PasswordViewModel(ref);
});

class PasswordViewModel extends StateNotifier<PasswordState> {
  final StateNotifierProviderRef ref;

  PasswordViewModel(this.ref) : super(PasswordState.initial());

  Future<void> register({
    required User user,
    String? firstName,
    String? lastName,
    String? email,
    required String password,
    File? img,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final AuthCredential credential = EmailAuthProvider.credential(
        email: '${user.phoneNumber!}@bidbazaar.com',
        password: password,
      );
      await user.linkWithCredential(credential);

      String uid = user.uid;

      String? imageUrl;
      if (img != null) {
        final storageRef = FirebaseStorage.instance.ref().child('uploads/profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = storageRef.putFile(img);

        await uploadTask.whenComplete(() async {
          final downloadUrl = await storageRef.getDownloadURL();
          imageUrl = downloadUrl;
        });
      }

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'phone': user.phoneNumber!,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'profileImageUrl': imageUrl,
      });

      state = state.copyWith(isLoading: false);
      ref.read(navigationServiceProvider).popUntil(AppRoutes.loginRoute);
      showSnackBar(
          context:
              ref.read(navigationServiceProvider).navigatorKey.currentContext!,
          message: 'Registration Successful!');
    } catch (e) {
      state = state.copyWith(isLoading: false);
      showSnackBar(
          context:
              ref.read(navigationServiceProvider).navigatorKey.currentContext!,
          message: 'Registration Failed: $e');
    }
  }

  Future<void> reset({required User user, required String password}) async {
    state = state.copyWith(isLoading: true);

    try {
      await user.updatePassword(password);
      state = state.copyWith(isLoading: false);
        ref.read(navigationServiceProvider).popUntil(AppRoutes.loginRoute);
        showSnackBar(
            context:
                ref.read(navigationServiceProvider).navigatorKey.currentContext!,
            message: 'Password Reset Successfully!');
    } catch (e) {
      debugPrint('Failed to update password: $e');
    }

    state = state.copyWith(isLoading: false);
  }
}
