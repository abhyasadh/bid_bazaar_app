import 'package:bid_bazaar/core/common/widgets/category_item.dart';
import 'package:equatable/equatable.dart';

class FilterState extends Equatable {
  final List<CategoryItem> selectedCategories;
  final int? minPrice;
  final int? maxPrice;
  final int minTime;
  final int maxTime;
  final String sortBy;
  final bool lowToHigh;

  FilterState({
    required this.selectedCategories,
    required this.minPrice,
    required this.maxPrice,
    required this.minTime,
    required this.maxTime,
    required this.sortBy,
    required this.lowToHigh,
  });

  factory FilterState.initialState() {
    return FilterState(
      selectedCategories: [],
      minPrice: null,
      maxPrice: null,
      minTime: 1,
      maxTime: 30,
      sortBy: 'Time Left',
      lowToHigh: true,
    );
  }

  FilterState copyWith({
    List<CategoryItem>? selectedCategories,
    int? minPrice,
    int? maxPrice,
    int? minTime,
    int? maxTime,
    String? sortBy,
    bool? lowToHigh,
  }) {
    return FilterState(
      selectedCategories: selectedCategories ?? this.selectedCategories,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      minTime: minTime ?? this.minTime,
      maxTime: maxTime ?? this.maxTime,
      sortBy: sortBy ?? this.sortBy,
      lowToHigh: lowToHigh ?? this.lowToHigh,
    );
  }

  @override
  List<Object?> get props => [selectedCategories, minPrice, maxPrice, minTime, maxTime, sortBy, lowToHigh];

  @override
  bool get stringify => true;
}


