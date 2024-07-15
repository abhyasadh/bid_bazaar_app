import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/common/widgets/title_widgets.dart';
import '../home_view_model.dart';

class SearchResultsScreen {
  List<Widget> buildItemList(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);

    final List<Widget> itemList = [
      const SizedBox(
        height: 10,
      ),
      const BlackSemiBoldTitle('Search Results'),
      if (homeState.searchedAuctions.isNotEmpty) ...{
        ...homeState.searchedAuctions
      } else ...{
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: const Center(
            child: Text(
              'No items found!\nTry expanding your search criteria.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      },
    ];

    return itemList;
  }
}
