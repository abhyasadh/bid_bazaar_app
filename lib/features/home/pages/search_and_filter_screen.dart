import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/widgets/title_widgets.dart';
import '../../filter/filter.dart';
import '../../filter/filter_state.dart';
import '../../filter/filter_view_model.dart';
import '../home_view_model.dart';
import '../../../core/common/widgets/filter_tab_group.dart';

class SearchAndFilterScreen {
  List<Widget> buildItemList(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);

    return [
      FilterTabGroup(
        provider: homeViewModelProvider,
        reset: () {
          ref
              .read(filterModelProvider(FilteringPage.homePage).notifier)
              .reset();
          ref
              .read(homeViewModelProvider.notifier)
              .filterAuctions(FilterState.initialState());
        },
      ),
      const BlackSemiBoldTitle('Searched and Filtered Items'),
      if (homeState.searchedAuctions.isNotEmpty) ...{
        ...ref
            .read(homeViewModelProvider.notifier)
            .applyFilters(homeState.searchedAuctions, homeState.filterState),
      } else ...{
        SizedBox(height: MediaQuery.of(context).size.height / 2,
          child: const Center(
            child: Text('No items found!\nTry expanding your filter and search criteria.', textAlign: TextAlign.center, style: TextStyle(fontSize: 18),),
          ),
        ),
      },
    ];
  }
}
