import 'dart:async';

import 'package:bid_bazaar/config/navigation/navigation_service.dart';
import 'package:bid_bazaar/core/common/messages/alert_dialogue.dart';
import 'package:bid_bazaar/core/common/messages/snackbar.dart';
import 'package:bid_bazaar/features/bottom_navigation/nav_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final itemViewModelProvider =
    Provider.family<ItemViewModel, String?>((ref, itemId) {
  return ItemViewModel(
    itemId: itemId,
  );
});

class ItemViewModel {
  ItemViewModel({
    String? itemId,
  }) : super();

  Future<void> save(String itemId, WidgetRef ref) async {
    final itemDoc = FirebaseFirestore.instance.collection('items').doc(itemId);
    final userId = ref.read(navViewModelProvider).userData?['uid'];

    FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(itemDoc);
      if (!snapshot.exists) {
        return;
      }

      List<dynamic> saved = snapshot.data()?['saved'] ?? [];

      if (!saved.contains(userId)) {
        saved.add(userId);
      } else {
        saved.remove(userId);
      }

      transaction.update(itemDoc, {'saved': saved});
    });
  }

  void deleteItem(String itemId, WidgetRef ref) async {
    bool undo = false;
    Completer<void> completer = Completer<void>();

    showAlertDialogue(
      message: 'Are you sure you want to delete this item?',
      context: ref.read(navigationServiceProvider).navigatorKey.currentContext!,
      ref: ref,
      onConfirm: () async {
        ref.read(navigationServiceProvider).goBack();
        ref.read(navigationServiceProvider).goBack();

        showSnackBar(
          context: ref.read(navigationServiceProvider).navigatorKey.currentContext!,
          message: 'Item Deleted!',
          error: true,
          requiresMargin: true,
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              undo = true;
              completer.complete();
            },
          ),
        );

        await Future.delayed(const Duration(seconds: 4));
        if (!completer.isCompleted) {
          completer.complete();
        }

        await completer.future;
        if (!undo) {
          try {
            // await FirebaseFirestore.instance.collection('items').doc(itemId).delete();
            print('Item deleted successfully');
          } catch (e) {
            print('Error deleting item: $e');
          }
        } else {
          print('Deletion undone');
        }
      },
    );
  }
}
