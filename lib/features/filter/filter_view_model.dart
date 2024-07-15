import 'package:bid_bazaar/core/common/widgets/category_item.dart';
import 'package:bid_bazaar/features/filter/filter.dart';
import 'package:bid_bazaar/features/filter/filter_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filterModelProvider = StateNotifierProvider.family<FilterViewModel, FilterState, FilteringPage>(
  (ref, page) {
    return FilterViewModel(
      page: page,
    );
  },
);

class FilterViewModel extends StateNotifier<FilterState> {
  final FilteringPage page;

  FilterViewModel({required this.page}) : super(FilterState.initialState());

  void copyWith({
    List<CategoryItem>? selectedCategories,
    int? minPrice,
    int? maxPrice,
    int? minTime,
    int? maxTime,
    String? sortBy,
    bool? lowToHigh,
  }) {
    state = state.copyWith(
      selectedCategories: selectedCategories ?? state.selectedCategories,
      minPrice: minPrice ?? state.minPrice,
      maxPrice: maxPrice ?? state.maxPrice,
      minTime: minTime ?? state.minTime,
      maxTime: maxTime ?? state.maxTime,
      sortBy: sortBy ?? state.sortBy,
      lowToHigh: lowToHigh ?? state.lowToHigh,
    );
  }

  void reset() {
    state = FilterState.initialState();
  }
}
