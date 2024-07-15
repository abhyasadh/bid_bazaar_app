import 'package:bid_bazaar/core/common/widgets/items/view/normal_item_view.dart';

import '../filter/filter_state.dart';

class SavedState {
  final List<NormalItemView> allAuctions;
  final List<NormalItemView> filteredAuctions;
  final List<NormalItemView> searchedAuctions;
  final bool isLoading;
  final FilterState filterState;

  SavedState({
    required this.allAuctions,
    required this.filteredAuctions,
    required this.searchedAuctions,
    required this.isLoading,
    required this.filterState,
  });

  factory SavedState.initialState() {
    return SavedState(
      allAuctions: [],
      filteredAuctions: [],
      searchedAuctions: [],
      isLoading: false,
      filterState: FilterState.initialState(),
    );
  }

  SavedState copyWith({
    List<NormalItemView>? allAuctions,
    List<NormalItemView>? filteredAuctions,
    List<NormalItemView>? searchedAuctions,
    bool? isLoading,
    FilterState? filterState,
  }) {
    return SavedState(
      allAuctions: allAuctions ?? this.allAuctions,
      filteredAuctions: filteredAuctions ?? this.filteredAuctions,
      searchedAuctions: searchedAuctions ?? this.searchedAuctions,
      isLoading: isLoading ?? this.isLoading,
      filterState: filterState ?? this.filterState,
    );
  }
}
