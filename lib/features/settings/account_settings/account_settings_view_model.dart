import 'dart:io';

import 'package:bid_bazaar/config/navigation/navigation_service.dart';
import 'package:bid_bazaar/core/common/messages/snackbar.dart';
import 'package:bid_bazaar/features/bottom_navigation/nav_view_model.dart';
import 'package:bid_bazaar/features/settings/account_settings/account_settings_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';

final accountSettingsViewModelProvider =
    StateNotifierProvider<AccountSettingsViewModel, AccountSettingsState>(
        (ref) {
  return AccountSettingsViewModel(ref);
});

class AccountSettingsViewModel extends StateNotifier<AccountSettingsState> {
  final StateNotifierProviderRef ref;

  AccountSettingsViewModel(this.ref)
      : super(AccountSettingsState.initialState()){
    checkBiometrics();
  }

  Future<void> uploadImage(File? file) async {
    state = state.copyWith(imageName: 'Image', isChanged: true);
  }

  void updateUser({
    required Either<File?, String?>? image,
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    state = state.copyWith(isLoading: true);
    if (image!=null) {
      image.fold((l) async {
      if (l != null) {
        final storageRef = FirebaseStorage.instance.ref().child(
            'uploads/profile_pictures/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = storageRef.putFile(l);

        await uploadTask.whenComplete(() async {
          final downloadUrl = await storageRef.getDownloadURL();
          await FirebaseFirestore.instance.collection('users').doc(ref.read(navViewModelProvider).userData!['uid']).set({
            'phone': ref.read(navViewModelProvider).userData?['phone'],
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'profileImageUrl': downloadUrl,
          });
          ref.read(navViewModelProvider.notifier).updateUser();
          showSnackBar(context: ref.read(navigationServiceProvider).navigatorKey.currentContext!, message: 'Details Updated Successfully!');
        });
      }
    }, (r) async {
        await FirebaseFirestore.instance.collection('users').doc(ref.read(navViewModelProvider).userData!['uid']).set({
          'phone': ref.read(navViewModelProvider).userData?['phone'],
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'profileImageUrl': ref.read(navViewModelProvider).userData?['profileImageUrl'],
        });
        ref.read(navViewModelProvider.notifier).updateUser();
        showSnackBar(context: ref.read(navigationServiceProvider).navigatorKey.currentContext!, message: 'Details Updated Successfully!');
      });
    }
    state = state.copyWith(isLoading: false);
  }

  void markAsChanged({String? fName, String? lName, String? email}) {
    final userDataState = ref.read(navViewModelProvider).userData;
    if (fName!=null && fName != userDataState?['firstName']) {
      state = state.copyWith(isChanged: true);
      return;
    }
    if (lName!=null && lName != userDataState?['lastName']) {
      state = state.copyWith(isChanged: true);
      return;
    }
    if (email!=null && email != userDataState?['email']) {
      state = state.copyWith(isChanged: true);
      return;
    }
    state = state.copyWith(isChanged: false);
  }

  Future<void> checkBiometrics() async {
    late bool canCheckBiometrics;
    try {
      canCheckBiometrics = await LocalAuthentication().canCheckBiometrics;
    } catch (e) {
      canCheckBiometrics = false;
    }
    if (!mounted) {
      return;
    }
    state = state.copyWith(canCheckBiometrics: canCheckBiometrics);
  }
}
