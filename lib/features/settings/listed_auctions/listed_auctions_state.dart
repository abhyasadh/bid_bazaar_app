import 'package:bid_bazaar/core/common/widgets/items/view/normal_item_view.dart';

import '../../filter/filter_state.dart';

class ListedAuctionsState {
  final List<NormalItemView> runningAuctions;
  final List<NormalItemView> endedAuctions;
  final List<NormalItemView> filteredEndedAuctions;
  final List<NormalItemView> searchedEndedAuctions;
  final List<NormalItemView> filteredRunningAuctions;
  final List<NormalItemView> searchedRunningAuctions;
  final int totalItems;
  final int totalViews;
  final int totalBids;
  final bool isLoading;
  final FilterState filterState;

  ListedAuctionsState({
    required this.runningAuctions,
    required this.endedAuctions,
    required this.filteredRunningAuctions,
    required this.filteredEndedAuctions,
    required this.searchedRunningAuctions,
    required this.searchedEndedAuctions,
    required this.totalItems,
    required this.totalViews,
    required this.totalBids,
    required this.isLoading,
    required this.filterState,
  });

  factory ListedAuctionsState.initialState() {
    return ListedAuctionsState(
      runningAuctions: [],
      endedAuctions: [],
      filteredRunningAuctions: [],
      searchedRunningAuctions: [],
      searchedEndedAuctions: [],
      filteredEndedAuctions: [],
      totalItems: 0,
      totalViews: 0,
      totalBids: 0,
      isLoading: false,
      filterState: FilterState.initialState(),
    );
  }

  ListedAuctionsState copyWith({
    List<NormalItemView>? runningAuctions,
    List<NormalItemView>? endedAuctions,
    List<NormalItemView>? filteredRunningAuctions,
    List<NormalItemView>? filteredEndedAuctions,
    List<NormalItemView>? searchedRunningAuctions,
    List<NormalItemView>? searchedEndedAuctions,
    int? totalItems,
    int? totalViews,
    int? totalBids,
    bool? isLoading,
    FilterState? filterState,
  }) {
    return ListedAuctionsState(
      runningAuctions: runningAuctions ?? this.runningAuctions,
      endedAuctions: endedAuctions ?? this.endedAuctions,
      filteredRunningAuctions: filteredRunningAuctions ?? this.filteredRunningAuctions,
      filteredEndedAuctions: filteredEndedAuctions ?? this.filteredEndedAuctions,
      searchedRunningAuctions: searchedRunningAuctions ?? this.searchedRunningAuctions,
      searchedEndedAuctions: searchedEndedAuctions ?? this.searchedEndedAuctions,
      totalItems: totalItems ?? this.totalItems,
      totalViews: totalViews ?? this.totalViews,
      totalBids: totalBids ?? this.totalBids,
      isLoading: isLoading ?? this.isLoading,
      filterState: filterState ?? this.filterState,
    );
  }
}
