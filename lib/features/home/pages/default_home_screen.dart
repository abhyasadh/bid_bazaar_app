import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/widgets/category_item.dart';
import '../../../core/common/widgets/title_widgets.dart';
import '../../filter/filter.dart';
import '../../filter/filter_view_model.dart';
import '../home_view_model.dart';
import '../widgets/trending_list.dart';

class DefaultHomeScreen {
  List<Widget> buildItemList(BuildContext context, WidgetRef ref){
    final homeState = ref.watch(homeViewModelProvider);
    const List<CategoryItem> categories = [
      CategoryItem(
        color: Color(0xff00aaf0),
        image: 'electronics',
        name: 'Electronics',
      ),
      CategoryItem(
        color: Color(0xffff9164),
        image: 'automobile',
        name: 'Vehicles',
      ),
      CategoryItem(
        color: Color(0xffef7582),
        image: 'jewelry',
        name: 'Jewelry',
      ),
      CategoryItem(
        color: Color(0xffccdfed),
        image: 'contract',
        name: 'Real Estate',
      ),
      CategoryItem(
        color: Color(0xffbb844c),
        image: 'furniture',
        name: 'Furniture',
      ),
      CategoryItem(
        color: Color(0xff80b4fb),
        image: 'dress',
        name: 'Fashion',
      ),
      CategoryItem(
        color: Color(0xfff7d291),
        image: 'gramophone',
        name: 'Antiques',
      ),
      CategoryItem(
        color: Color(0xfffeaee1),
        image: 'stamp',
        name: 'Collectibles',
      ),
      CategoryItem(
        color: Color(0xfff9eac7),
        image: 'statue',
        name: 'Sculptures',
      ),
      CategoryItem(
        color: Color(0xff4a94cc),
        image: 'vase',
        name: 'Decor',
      ),
    ];
    return [
      const SizedBox(height: 10,),
      TrendingList(
        title: 'Featured',
        items: homeState.trending,
      ),
      const SizedBox(
        height: 10,
      ),
      const BlackSemiBoldTitle('Ending Soon'),
      if (homeState.allAuctions.isNotEmpty) ...{
        ...List.generate(min(homeState.allAuctions.length, 7), (index) {
          return homeState.allAuctions[index];
        }),
      },
      const BlackSemiBoldTitle('Popular Categories'),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: categories.sublist(0, 5).map((e) => InkWell(
                onTap: () {
                  ref.read(filterModelProvider(FilteringPage.homePage).notifier).copyWith(selectedCategories: [e]);
                  ref.read(homeViewModelProvider.notifier).filterAuctions(ref.read(filterModelProvider(FilteringPage.homePage)));
                },
                child: e,
              )).toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: categories.sublist(5, 10).map((e) => InkWell(
                onTap: () {
                  ref.read(filterModelProvider(FilteringPage.homePage).notifier).copyWith(selectedCategories: [e]);
                  ref.read(homeViewModelProvider.notifier).filterAuctions(ref.read(filterModelProvider(FilteringPage.homePage)));
                },
                child: e,
              )).toList(),
            ),
          ],
        ),
      ),
      const SizedBox(height: 40,),
      if (homeState.allAuctions.isNotEmpty &&
          homeState.allAuctions.length > 7) ...[
        ...List.generate(homeState.allAuctions.length - 7, (index) {
          return homeState.allAuctions[index + 7];
        }),
      ],
    ];
  }
}
