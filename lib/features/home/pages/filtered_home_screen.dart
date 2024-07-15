import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/widgets/title_widgets.dart';
import '../../../core/common/widgets/filter_tab_group.dart';
import '../../filter/filter.dart';
import '../../filter/filter_state.dart';
import '../../filter/filter_view_model.dart';
import '../home_view_model.dart';

enum ParentScreen {homeScreen, savedScreen, bidsScreen}

class FilteredHomeScreen {

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
      const BlackSemiBoldTitle('Filtered Items'),
      if (homeState.filteredAuctions.isNotEmpty) ...{
        ...List.generate(homeState.filteredAuctions.length, (index) {
          return homeState.filteredAuctions[index];
        }),
      } else ...{
        SizedBox(height: MediaQuery.of(context).size.height / 2,
          child: const Center(
            child: Text('No items found!\nTry expanding your filter criteria.', textAlign: TextAlign.center, style: TextStyle(fontSize: 18),),
          ),
        ),
      },
    ];
  }
}
