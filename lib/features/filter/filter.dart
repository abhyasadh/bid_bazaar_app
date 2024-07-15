import 'package:bid_bazaar/config/navigation/navigation_service.dart';
import 'package:bid_bazaar/config/themes/app_theme.dart';
import 'package:bid_bazaar/core/common/widgets/category_item.dart';
import 'package:bid_bazaar/core/common/widgets/custom_dropdown_field.dart';
import 'package:bid_bazaar/features/filter/filter_state.dart';
import 'package:bid_bazaar/features/filter/filter_view_model.dart';
import 'package:bid_bazaar/features/home/home_view_model.dart';
import 'package:bid_bazaar/features/my_bids/my_bids_view_model.dart';
import 'package:bid_bazaar/features/saved/saved_view_model.dart';
import 'package:bid_bazaar/features/settings/listed_auctions/listed_auctions_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/common/widgets/custom_text_field.dart';

enum FilteringPage { homePage, savedPage, bidsPage, myAuctionsPage }

class Filters extends ConsumerStatefulWidget {
  final FilteringPage page;

  const Filters({super.key, required this.page});

  @override
  ConsumerState createState() => _FilterState();
}

class _FilterState extends ConsumerState<Filters> {
  final minKey = GlobalKey<FormState>();
  late TextEditingController minController;
  final minFocusNode = FocusNode();

  final maxKey = GlobalKey<FormState>();
  late TextEditingController maxController;
  final maxFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final minPrice = ref.read(filterModelProvider(widget.page)).minPrice ?? '';
    final maxPrice = ref.read(filterModelProvider(widget.page)).maxPrice ?? '';
    minController = TextEditingController(text: minPrice.toString());
    maxController = TextEditingController(text: maxPrice.toString());
  }

  @override
  void dispose() {
    minFocusNode.dispose();
    maxFocusNode.dispose();
    minController.dispose();
    maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    bool isActive(String name) {
      final selectedCategories = ref.watch(filterModelProvider(widget.page)).selectedCategories.map((e)=>e.name).toList();
      if (name == 'All') {
        return selectedCategories.isEmpty;
      }
      return selectedCategories.contains(name);
    }

    List<CategoryItem> categories = [
      CategoryItem(
        color: const Color(0xffff6c52),
        image: 'all',
        name: 'All',
        isActive: isActive('All'),
      ),
      CategoryItem(
        color: const Color(0xff00aaf0),
        image: 'electronics',
        name: 'Electronics',
        isActive: isActive('Electronics'),
      ),
      CategoryItem(
        color: const Color(0xffff9164),
        image: 'automobile',
        name: 'Vehicles',
        isActive: isActive('Vehicles'),
      ),
      CategoryItem(
        color: const Color(0xffef7582),
        image: 'jewelry',
        name: 'Jewelry',
        isActive: isActive('Jewelry'),
      ),
      CategoryItem(
        color: const Color(0xffccdfed),
        image: 'contract',
        name: 'Real Estate',
        isActive: isActive('Real Estate'),
      ),
      CategoryItem(
        color: const Color(0xffbb844c),
        image: 'furniture',
        name: 'Furniture',
        isActive: isActive('Furniture'),
      ),
      CategoryItem(
        color: const Color(0xff80b4fb),
        image: 'dress',
        name: 'Fashion',
        isActive: isActive('Fashion'),
      ),
      CategoryItem(
        color: const Color(0xfff7d291),
        image: 'gramophone',
        name: 'Antiques',
        isActive: isActive('Antiques'),
      ),
      CategoryItem(
        color: const Color(0xfffeaee1),
        image: 'stamp',
        name: 'Collectibles',
        isActive: isActive('Collectibles'),
      ),
      CategoryItem(
        color: const Color(0xfff9eac7),
        image: 'statue',
        name: 'Sculptures',
        isActive: isActive('Sculptures'),
      ),
      CategoryItem(
        color: const Color(0xff4a94cc),
        image: 'vase',
        name: 'Decor',
        isActive: isActive('Decor'),
      ),
      CategoryItem(
        color: const Color(0xfffe9532),
        image: 'alcohol',
        name: 'Drinks',
        isActive: isActive('Drinks'),
      ),
      CategoryItem(
        color: const Color(0xffe88e8e),
        image: 'mona-lisa',
        name: 'Art',
        isActive: isActive('Art'),
      ),
      CategoryItem(
        color: const Color(0xffffe07d),
        image: 'autograph',
        name: 'Memorabilia',
        isActive: isActive('Memorabilia'),
      ),
    ];

    final filterState = ref.watch(filterModelProvider(widget.page));
    final filterNotifier = ref.read(filterModelProvider(widget.page).notifier);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
            child: Text(
              'Filters',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor),
            ),
          ),
          SizedBox(
            height: 72,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              padding: const EdgeInsets.only(left: 20),
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    InkWell(
                      onTap: () {
                        var selectedCategories = filterState.selectedCategories;
                        final category = categories[index];

                        if (category.name == 'All') {
                          selectedCategories.clear();
                        } else {
                          if (selectedCategories.map((e)=>e.name).contains(category.name)) {
                            selectedCategories.removeWhere((e)=>e.name == category.name);
                          } else {
                            selectedCategories.add(category);
                          }

                          if (selectedCategories.isNotEmpty &&
                              selectedCategories.contains(categories[0])) {
                            selectedCategories.remove(categories[0]);
                          }
                        }

                        ref
                            .read(filterModelProvider(widget.page).notifier)
                            .copyWith(selectedCategories: selectedCategories);
                      },
                      child: categories[index],
                    ),
                    const SizedBox(
                      width: 20,
                    )
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: minKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Expanded(
                    child: CustomTextField(
                      label: 'Price',
                      hintText: 'Min',
                      icon: null,
                      controller: minController,
                      node: minFocusNode,
                      keyBoardType: TextInputType.number,
                      obscureText: false,
                      validator: (value) {
                        if (value == null || value == '') return null;
                        try {
                          int.parse(value);
                          return null;
                        } catch (e) {
                          return 'Invalid number';
                        }
                      },
                      onChanged: (value) {
                        try {
                          ref
                              .read(filterModelProvider(widget.page).notifier)
                              .copyWith(minPrice: int.parse(value));
                        } catch (e) {
                          //
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  width: 24,
                ),
                Form(
                  key: maxKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Expanded(
                    child: CustomTextField(
                      label: ' ',
                      hintText: 'Max',
                      icon: null,
                      controller: maxController,
                      keyBoardType: TextInputType.number,
                      node: maxFocusNode,
                      validator: (value) {
                        if (value == null || value == '') return null;
                        try {
                          int.parse(value);
                          return null;
                        } catch (e) {
                          return 'Invalid number';
                        }
                      },
                      onChanged: (value) {
                        try {
                          ref
                              .read(filterModelProvider(widget.page).notifier)
                              .copyWith(maxPrice: int.parse(value));
                        } catch (e) {
                          //
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 14, bottom: 6),
            child: Text(
              'Time Left',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: RangeSlider(
              values: RangeValues(
                  filterState.minTime.toDouble(),
                  filterState.maxTime.toDouble()),
              min: 1,
              max: 30,
              activeColor: AppTheme.primaryColor,
              inactiveColor: Colors.grey,
              onChanged: (value) {
                filterNotifier.copyWith(
                    minTime: value.start.toInt(), maxTime: value.end.toInt());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppTheme.primaryColor.withOpacity(0.4)),
                  child: Text(
                    '${filterState.minTime} Day(s)',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppTheme.primaryColor.withOpacity(0.4)),
                  child: Text(
                    '${filterState.maxTime} Day(s)',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Divider(
              thickness: 0.5,
              endIndent: 2,
              indent: 2,
              color: Colors.grey.withOpacity(0.5),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: CustomDropdownField(
                      width: MediaQuery.of(context).size.width - 188,
                      label: 'Sort By:',
                      items: const ['Time Left', 'Price', 'Bids Placed'],
                      initiallySelected: filterState.sortBy,
                      onChanged: (value){
                        filterNotifier.copyWith(sortBy: value);
                      },
                    ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.tertiary,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  filterNotifier.copyWith(lowToHigh: !filterState.lowToHigh);
                },
                child: Text(
                  filterState.lowToHigh? 'Low   →   High' : 'High   →   Low',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      ref.read(filterModelProvider(widget.page).notifier).reset();
                      minController.text = '';
                      maxController.text = '';
                      switch (widget.page){
                        case FilteringPage.homePage:
                          ref.read(homeViewModelProvider.notifier).filterAuctions(FilterState.initialState());
                          break;
                        case FilteringPage.savedPage:
                          ref.read(savedViewModelProvider.notifier).filterAuctions(FilterState.initialState());
                          break;
                        case FilteringPage.bidsPage:
                          ref.read(myBidsViewModelProvider.notifier).filterAuctions(FilterState.initialState());
                          break;
                        case FilteringPage.myAuctionsPage:
                          ref.read(listedAuctionsViewModelProvider.notifier).filterAuctions(FilterState.initialState());
                      }
                    },
                    child: const Text(
                      'Reset',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if ((minController.text.isNotEmpty && maxController.text.isNotEmpty) && int.parse(minController.text) > int.parse(maxController.text)){
                        String maxPlaceholder = minController.text;
                        String minPlaceholder = maxController.text;
                        minController.text = minPlaceholder;
                        maxController.text = maxPlaceholder;

                        filterNotifier.copyWith(minPrice: int.parse(minPlaceholder), maxPrice: int.parse(maxPlaceholder));
                      }
                      
                      switch (widget.page){
                        case FilteringPage.homePage:
                          ref.read(homeViewModelProvider.notifier).filterAuctions(ref.watch(filterModelProvider(FilteringPage.homePage)));
                          break;
                        case FilteringPage.savedPage:
                          ref.read(savedViewModelProvider.notifier).filterAuctions(ref.watch(filterModelProvider(FilteringPage.savedPage)));
                          break;
                        case FilteringPage.bidsPage:
                          ref.read(myBidsViewModelProvider.notifier).filterAuctions(ref.watch(filterModelProvider(FilteringPage.bidsPage)));
                          break;
                        case FilteringPage.myAuctionsPage:
                          ref.read(listedAuctionsViewModelProvider.notifier).filterAuctions(ref.watch(filterModelProvider(FilteringPage.myAuctionsPage)));
                          break;
                      }
                      ref.read(navigationServiceProvider).goBack();
                    },
                    child: const Text(
                      'Apply',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
