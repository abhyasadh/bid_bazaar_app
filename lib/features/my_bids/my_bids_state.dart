import 'package:bid_bazaar/core/common/widgets/items/view/normal_item_view.dart';

import '../filter/filter_state.dart';

class MyBidsState {
  final List<NormalItemView> runningAuctions;
  final List<NormalItemView> endedAuctions;
  final List<NormalItemView> filteredEndedAuctions;
  final List<NormalItemView> searchedEndedAuctions;
  final List<NormalItemView> filteredRunningAuctions;
  final List<NormalItemView> searchedRunningAuctions;
  final bool isLoading;
  final FilterState filterState;

  MyBidsState({
    required this.runningAuctions,
    required this.endedAuctions,
    required this.filteredRunningAuctions,
    required this.filteredEndedAuctions,
    required this.searchedRunningAuctions,
    required this.searchedEndedAuctions,
    required this.isLoading,
    required this.filterState,
  });

  factory MyBidsState.initialState() {
    return MyBidsState(
      runningAuctions: [],
      endedAuctions: [],
      filteredRunningAuctions: [],
      searchedRunningAuctions: [],
      searchedEndedAuctions: [],
      filteredEndedAuctions: [],
      isLoading: false,
      filterState: FilterState.initialState(),
    );
  }

  MyBidsState copyWith({
    List<NormalItemView>? runningAuctions,
    List<NormalItemView>? endedAuctions,
    List<NormalItemView>? filteredRunningAuctions,
    List<NormalItemView>? filteredEndedAuctions,
    List<NormalItemView>? searchedRunningAuctions,
    List<NormalItemView>? searchedEndedAuctions,
    bool? isLoading,
    FilterState? filterState,
  }) {
    return MyBidsState(
      runningAuctions: runningAuctions ?? this.runningAuctions,
      endedAuctions: endedAuctions ?? this.endedAuctions,
      filteredRunningAuctions: filteredRunningAuctions ?? this.filteredRunningAuctions,
      filteredEndedAuctions: filteredEndedAuctions ?? this.filteredEndedAuctions,
      searchedRunningAuctions: searchedRunningAuctions ?? this.searchedRunningAuctions,
      searchedEndedAuctions: searchedEndedAuctions ?? this.searchedEndedAuctions,
      isLoading: isLoading ?? this.isLoading,
      filterState: filterState ?? this.filterState,
    );
  }
}
