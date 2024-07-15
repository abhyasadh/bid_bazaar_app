import 'package:bid_bazaar/core/common/widgets/items/view/normal_item_view.dart';
import 'package:bid_bazaar/features/filter/filter_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bottom_navigation/nav_view_model.dart';
import 'listed_auctions_state.dart';

final listedAuctionsViewModelProvider =
StateNotifierProvider<ListedAuctionsViewModel, ListedAuctionsState>(
      (ref) => ListedAuctionsViewModel(ListedAuctionsState.initialState(), ref),
);

class ListedAuctionsViewModel extends StateNotifier<ListedAuctionsState> {
  final StateNotifierProviderRef ref;

  ListedAuctionsViewModel(super.state, this.ref) {
    fetchAuctions();
  }

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  void fetchAuctions() {
    state = state.copyWith(isLoading: true);

    int totalViews = 0;
    int totalBids = 0;
    int totalItems = 0;

    _fireStore
        .collection('items')
        .where('time_limit', isGreaterThan: Timestamp.now())
        .where('user_id', isEqualTo: ref.read(navViewModelProvider).userData?['uid'])
        .snapshots()
        .listen((snapshot) {
      final items = snapshot.docs.map((doc) => NormalItemView.fromDocument(doc: doc, isOwn: true,)).toList();
      int runningViews = snapshot.docs.fold(0, (total, doc) => total + (int.parse(doc['seen'].toString())));
      int runningBids = snapshot.docs.fold(0, (total, doc) => total + (int.parse(doc['bid_count'].toString())));
      int runningTotal = items.length;

      totalViews = totalViews + runningViews;
      totalBids += runningBids;
      totalItems += runningTotal;

      state = state.copyWith(runningAuctions: items, totalViews: totalViews, totalBids: totalBids, totalItems: totalItems);
      _applyFiltersAndNotify();
    });

    _fireStore
        .collection('items')
        .where('time_limit', isLessThan: Timestamp.now())
        .where('user_id', isEqualTo: ref.read(navViewModelProvider).userData?['uid'])
        .snapshots()
        .listen((snapshot) {
      final items = snapshot.docs.map((doc) => NormalItemView.fromDocument(doc: doc, isOwn: true,)).toList();
      int runningViews = snapshot.docs.fold(0, (total, doc) => total + (int.parse(doc['seen'].toString())));
      int runningBids = snapshot.docs.fold(0, (total, doc) => total + (int.parse(doc['bid_count'].toString())));
      int runningTotal = items.length;

      totalViews = totalViews + runningViews;
      totalBids += runningBids;
      totalItems += runningTotal;

      state = state.copyWith(endedAuctions: items, totalViews: totalViews, totalBids: totalBids, totalItems: totalItems);
      _applyFiltersAndNotify();
    });

    Future.delayed(const Duration(seconds: 1), () {
      state = state.copyWith(isLoading: false);
    });
  }

  void searchItems(String query) {
    if (query.isEmpty) {
      state = state
          .copyWith(searchedRunningAuctions: [], searchedEndedAuctions: []);
      return;
    }

    _fireStore
        .collection('items')
        .where('time_limit', isGreaterThan: Timestamp.now())
        .where('bid_users',
        arrayContains: ref.read(navViewModelProvider).userData?['uid'])
        .snapshots()
        .listen((snapshot) {
      final searchedAuctions = snapshot.docs.map((doc) {
        return NormalItemView.fromDocument(doc: doc);
      }).where((item) {
        return item.title.toLowerCase().contains(query.toLowerCase());
      }).toList();

      state = state.copyWith(searchedRunningAuctions: searchedAuctions);
    });

    _fireStore
        .collection('items')
        .where('time_limit', isLessThan: Timestamp.now())
        .where('bid_users',
        arrayContains: ref.read(navViewModelProvider).userData?['uid'])
        .snapshots()
        .listen((snapshot) {
      final searchedAuctions = snapshot.docs.map((doc) {
        return NormalItemView.fromDocument(doc: doc);
      }).where((item) {
        return item.title.toLowerCase().contains(query.toLowerCase());
      }).toList();

      state = state.copyWith(searchedEndedAuctions: searchedAuctions);
    });
  }

  void filterAuctions(FilterState filter) {
    state = state.copyWith(filterState: filter);
    _applyFiltersAndNotify();
  }

  void _applyFiltersAndNotify() {
    final filter = state.filterState;

    if (filter == FilterState.initialState()) {
      state = state.copyWith(filteredRunningAuctions: [], filteredEndedAuctions: []);
      return;
    }

    final filteredRunningAuctions = applyFilters(state.runningAuctions, filter);
    final filteredEndedAuctions = applyFilters(state.endedAuctions, filter);

    state = state.copyWith(
      filteredRunningAuctions: filteredRunningAuctions,
      filteredEndedAuctions: filteredEndedAuctions,
    );
  }

  List<NormalItemView> applyFilters(
      List<NormalItemView> items, FilterState filter) {
    return items.where((item) {
      bool matchesPrice =
          (filter.minPrice == null || item.price >= filter.minPrice!) &&
              (filter.maxPrice == null || item.price <= filter.maxPrice!);

      bool matchesTime = (filter.minTime == 1 ||
          int.parse(item.endsIn.split(' ')[0].replaceAll('D', '')) >=
              filter.minTime) &&
          (filter.maxTime == 30 ||
              int.parse(item.endsIn.split(' ')[0].replaceAll('D', '')) <
                  filter.maxTime);

      bool matchesCategory = filter.selectedCategories.isEmpty ||
          List.of(filter.selectedCategories.map((e) => e.name))
              .contains(item.category);

      return matchesPrice && matchesTime && matchesCategory;
    }).toList()
      ..sort(
            (a, b) {
          if (filter.sortBy == 'Price') {
            return filter.lowToHigh
                ? a.price.compareTo(b.price)
                : b.price.compareTo(a.price);
          } else if (filter.sortBy == 'Time Left') {
            return filter.lowToHigh
                ? parseEndsInToDays(a.endsIn)
                .compareTo(parseEndsInToDays(b.endsIn))
                : parseEndsInToDays(b.endsIn)
                .compareTo(parseEndsInToDays(a.endsIn));
          } else if (filter.sortBy == 'Bids Placed') {
            return filter.lowToHigh
                ? a.bidCount.compareTo(b.price)
                : b.bidCount.compareTo(a.price);
          } else {
            return 0;
          }
        },
      );
  }

  int parseEndsInToDays(String endsIn) {
    int days = 0;
    int hours = 0;
    int minutes = 0;

    List<String> parts = endsIn.split(' ');

    for (String part in parts) {
      if (part.endsWith('D')) {
        days = int.parse(part.replaceAll('D', ''));
      } else if (part.endsWith('H')) {
        hours = int.parse(part.replaceAll('H', ''));
      } else if (part.endsWith('M')) {
        minutes = int.parse(part.replaceAll('M', ''));
      }
    }

    return days + (hours ~/ 24) + (minutes ~/ 1440);
  }
}
