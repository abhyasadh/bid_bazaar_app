import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/themes/app_theme.dart';

class FilterTabGroup extends ConsumerWidget {
  final StateNotifierProvider provider;
  final void Function() reset;
  
  const FilterTabGroup({required this.provider, required this.reset, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);
    return Container(
      padding: const EdgeInsets.only(top: 8),
      margin: const EdgeInsets.only(top: 8),
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: 1 +
            (state.filterState.minPrice != null ||
                state.filterState.maxPrice != null
                ? 1
                : 0) +
            (state.filterState.minTime != 1 ||
                state.filterState.maxTime != 30
                ? 1
                : 0) +
            (state.filterState.sortBy != 'Time Left' ||
                !state.filterState.lowToHigh
                ? 1
                : 0) +
            int.parse(state.filterState.selectedCategories.length.toString()),
        itemBuilder: (context, index) {
          final filterState = state.filterState;

          Container itemContainer(Color color, String text) {
            return Container(
              height: 30,
              margin: const EdgeInsets.only(right: 8),
              alignment: Alignment.center,
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(text),
            );
          }

          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: reset,
                child: const Icon(Icons.close),
              ),
            );
          }

          index--;

          if (index < filterState.selectedCategories.length) {
            return itemContainer(
              filterState.selectedCategories[index].color,
              filterState.selectedCategories[index].name,
            );
          }

          index -= int.parse(state.filterState.selectedCategories.length.toString());

          if (filterState.minPrice != null ||
              filterState.maxPrice != null) {
            if (index == 0) {
              if (filterState.minPrice != null &&
                  filterState.maxPrice != null) {
                return itemContainer(
                  AppTheme.successColor,
                  'Rs. ${filterState.minPrice} - Rs. ${filterState.maxPrice}',
                );
              } else if (filterState.minPrice != null) {
                return itemContainer(
                  AppTheme.successColor,
                  'Min: Rs. ${filterState.minPrice}',
                );
              } else {
                return itemContainer(
                  AppTheme.successColor,
                  'Max: Rs. ${filterState.maxPrice}',
                );
              }
            }
            index--;
          }

          if (filterState.minTime != 1 || filterState.maxTime != 30) {
            if (index == 0) {
              return itemContainer(
                Colors.red,
                '${filterState.minTime} - ${filterState.maxTime} Days',
              );
            }
            index--;
          }

          if (filterState.sortBy != 'Time Left' || !filterState.lowToHigh) {
            if (index == 0) {
              return itemContainer(
                Colors.orange,
                '${filterState.sortBy} ${filterState.lowToHigh ? '(Low to High)' : '(High to Low)'}',
              );
            }
          }
          return null;
        },
      ),
    );
  }
}
