import 'package:bid_bazaar/core/common/widgets/items/view/featured_item_view.dart';
import 'package:bid_bazaar/core/common/widgets/items/view/normal_item_view.dart';

import '../filter/filter_state.dart';

class HomeState {
  final List<FeaturedItemView> trending;
  final List<NormalItemView> allAuctions;
  final List<NormalItemView> filteredAuctions;
  final List<NormalItemView> searchedAuctions;
  final bool isLoading;
  final bool showScrollButton;
  final FilterState filterState;

  HomeState({
    required this.trending,
    required this.allAuctions,
    required this.filteredAuctions,
    required this.searchedAuctions,
    required this.isLoading,
    required this.showScrollButton,
    required this.filterState,
  });

  factory HomeState.initialState() {
    return HomeState(
      trending: [],
      allAuctions: [],
      filteredAuctions: [],
      searchedAuctions: [],
      isLoading: false,
      showScrollButton: false,
      filterState: FilterState.initialState(),
    );
  }

  HomeState copyWith({
    List<FeaturedItemView>? trending,
    List<NormalItemView>? allAuctions,
    List<NormalItemView>? filteredAuctions,
    List<NormalItemView>? searchedAuctions,
    bool? isLoading,
    bool? showScrollButton,
    FilterState? filterState,
  }) {
    return HomeState(
      trending: trending ?? this.trending,
      allAuctions: allAuctions ?? this.allAuctions,
      filteredAuctions: filteredAuctions ?? this.filteredAuctions,
      searchedAuctions: searchedAuctions ?? this.searchedAuctions,
      isLoading: isLoading ?? this.isLoading,
      showScrollButton: showScrollButton ?? this.showScrollButton,
      filterState: filterState ?? this.filterState,
    );
  }
}
