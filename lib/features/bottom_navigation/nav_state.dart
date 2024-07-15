import 'package:bid_bazaar/features/home/home_view.dart';
import 'package:bid_bazaar/features/my_bids/my_bids_view.dart';
import 'package:bid_bazaar/features/saved/saved_view.dart';
import 'package:bid_bazaar/features/settings/settings_view.dart';
import 'package:flutter/widgets.dart';

class NavState {
  final Map<String, dynamic>? userData;
  final int index;
  final List<Widget> listWidgets;

  NavState({
    this.userData,
    required this.index,
    required this.listWidgets,
  });

  NavState.initialState()
      : userData = {},
        index = 0,
        listWidgets = [
          const HomeView(),
          const SavedView(),
          const MyBidsView(),
          const SettingsView(),
        ];

  NavState copyWith({
    Map<String, dynamic>? userData,
    int? index,
  }) {
    return NavState(
      userData: userData ?? this.userData,
      index: index ?? this.index,
      listWidgets: listWidgets,
    );
  }
}
