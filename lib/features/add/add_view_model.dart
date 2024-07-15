import 'dart:io';

import 'package:bid_bazaar/config/routes/app_routes.dart';
import 'package:bid_bazaar/core/common/messages/snackbar.dart';
import 'package:bid_bazaar/features/bottom_navigation/nav_view_model.dart';
import 'package:bid_bazaar/features/settings/listed_auctions/listed_auctions_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import '../../config/navigation/navigation_service.dart';
import 'add_state.dart';

final addViewModelProvider =
    StateNotifierProvider<AddViewModel, AddState>(
  (ref) => AddViewModel(),
);

class AddViewModel extends StateNotifier<AddState> {
  AddViewModel() : super(AddState.initialState());

  PageController? _pageController;

  void resetState(){
    state = AddState.initialState();
  }

  void setPageController(PageController pageController) {
    _pageController = pageController;
  }

  void updateDetails(String key, String value) {
    state.details?[key] = value;
  }

  void copyWith({
    String? id,
    String? title,
    List<File>? images,
    List<String>? imageUrls,
    String? category,
    Map<String, dynamic>? details,
    String? condition,
    String? description,
    int? price,
    int? increment,
    int? time,
    int? bidCount,
    int? seen,
    List<int>? bidPrices,
    List<String>? bidUsers,
    List<String>? reports,
    List<String>? saved,
  }) {
    state = state.copyWith(
      id: id ?? state.id,
      title: title ?? state.title,
      images: images ?? state.images,
      imageUrls: imageUrls ?? state.imageUrls,
      category: category ?? state.category,
      details: details ?? state.details,
      condition: condition ?? state.condition,
      description: description ?? state.description,
      price: price ?? state.price,
      increment: increment ?? state.increment,
      time: time ?? state.time,
      bidCount: bidCount ?? state.bidCount,
      seen: seen ?? state.seen,
      bidPrices: bidPrices ?? state.bidPrices,
      bidUsers: bidUsers ?? state.bidUsers,
      reports: reports ?? state.reports,
      saved: saved ?? state.saved,
    );
  }

  void changeIndex(int index) {
    _pageController?.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    Future.delayed(const Duration(milliseconds: 150), () {
      state = state.copyWith(index: index);
    });
  }

  void addImage(File image) {
    final updatedImages = List<File>.from(state.images)..add(image);
    state = state.copyWith(images: updatedImages);
  }

  void removeImage(Either<File, String> image) {
    image.fold((l){
      final updatedImages = List<File>.from(state.images)..remove(l);
      state = state.copyWith(images: updatedImages);
    }, (r){
      final updatedImages = List<String>.from(state.imageUrls)..remove(r);
      state = state.copyWith(imageUrls: updatedImages);
    });
  }

  Future<void> addAuction(WidgetRef ref) async {
    state = state.copyWith(isLoading: true);

    try {
      List<String> imageUrl = state.imageUrls;

      for (int i = 0; i < state.images.length; i++) {
        final storageRef = FirebaseStorage.instance.ref().child(
            'uploads/items/${DateTime.now().millisecondsSinceEpoch}.jpg');
        final uploadTask = storageRef.putFile(state.images[i]);

        await uploadTask.whenComplete(() async {
          final downloadUrl = await storageRef.getDownloadURL();
          imageUrl.add(downloadUrl);
        });
      }

      Map<String, dynamic> auctionData = {
        'user_id': ref.read(navViewModelProvider).userData?['uid'],
        'title': state.title,
        'images': imageUrl,
        'category': state.category,
        'details': state.details,
        'condition': state.condition,
        'description': state.description,
        'price': state.price,
        'min_increment': state.increment,
        'time_limit': DateTime.now().add(Duration(days: state.time!)),
        'bid_count': state.bidCount,
        'bid_prices': state.bidPrices,
        'bid_users': state.bidUsers,
        'saved': state.saved,
        'reports': state.saved,
        'seen': state.seen,
        'timestamp': FieldValue.serverTimestamp(),
      };

      if (state.id == null) {
        // Add new auction
        await FirebaseFirestore.instance.collection('items').add(auctionData);
        showSnackBar(
            context: ref.read(navigationServiceProvider).navigatorKey.currentContext!,
            message: 'Auction Added Successfully!',
            requiresMargin: true);
      } else {
        await FirebaseFirestore.instance.collection('items').doc(state.id).update(auctionData);
        showSnackBar(
            context: ref.read(navigationServiceProvider).navigatorKey.currentContext!,
            message: 'Auction Updated Successfully!',
            requiresMargin: true);
      }
      state = state.copyWith(isLoading: false);
      ref.read(listedAuctionsViewModelProvider.notifier).fetchAuctions();
      state.id == null ? ref.read(navigationServiceProvider).popUntil(AppRoutes.homeRoute) : ref.read(navigationServiceProvider).popUntil(AppRoutes.listedAuctionsRoute);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      showSnackBar(
          context: ref.read(navigationServiceProvider).navigatorKey.currentContext!,
          error: true,
          message: 'An error occurred: ${e.toString()}',
          requiresMargin: true);
    }
  }
}
