import 'dart:io';

import 'package:bid_bazaar/features/auth/details/details_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final detailsViewModelProvider =
    StateNotifierProvider<DetailsViewModel, DetailsState>((ref) {
  return DetailsViewModel(ref);
});

class DetailsViewModel extends StateNotifier<DetailsState> {
  final StateNotifierProviderRef ref;

  DetailsViewModel(this.ref) : super(DetailsState.initial());

  Future<void> uploadImage(File? file) async {
    state = state.copyWith(imageName: 'Image');
  }
}
