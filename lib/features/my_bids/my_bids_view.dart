import 'package:bid_bazaar/core/common/widgets/custom_appbars.dart';
import 'package:bid_bazaar/core/common/widgets/filter_tab_group.dart';
import 'package:bid_bazaar/features/my_bids/my_bids_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/themes/app_theme.dart';
import '../../core/common/widgets/no_internet_widget.dart';
import '../../core/common/widgets/title_widgets.dart';
import '../../core/utils/connectivity_notifier.dart';
import '../filter/filter.dart';
import '../filter/filter_state.dart';
import '../filter/filter_view_model.dart';

class MyBidsView extends ConsumerStatefulWidget {
  const MyBidsView({super.key});

  @override
  ConsumerState createState() => _MyBidsViewState();
}

class _MyBidsViewState extends ConsumerState<MyBidsView> {
  final searchKey = GlobalKey<FormState>();
  final searchController = TextEditingController(text: "");
  final searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    if (ref.watch(connectivityProvider) != ConnectivityStatus.isConnected) {
      return const NoInternetWidget();
    }

    final myBidsState = ref.watch(myBidsViewModelProvider);

    final widgets = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    return const Filters(page: FilteringPage.bidsPage);
                  },
                );
              },
              icon: SvgPicture.asset(
                'assets/images/svg/filter.svg',
                colorFilter:
                const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
              constraints: BoxConstraints.tight(const Size(50, 50)),
              style: ButtonStyle(
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(color: Colors.grey, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Form(
                key: searchKey,
                child: TextFormField(
                  focusNode: searchFocusNode,
                  controller: searchController,
                  cursorColor: Theme.of(context).primaryColor,
                  textInputAction: TextInputAction.search,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                      hintText: 'Search items...',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Icon(
                          Icons.search,
                          size: 18,
                        ),
                      ),
                      suffixIcon: searchController.text.isNotEmpty
                          ? InkWell(
                          onTap: () {
                            searchController.text = '';
                            ref
                                .read(myBidsViewModelProvider.notifier)
                                .searchItems('');
                          },
                          child: const Icon(Icons.close))
                          : null,
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide: BorderSide(color: Colors.grey, width: 2),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        borderSide:
                        BorderSide(color: AppTheme.primaryColor, width: 2),
                      ),
                      prefixIconConstraints: const BoxConstraints(
                        minWidth: 40,
                      ),
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 10.0),
                      filled: false,
                      hintStyle: const TextStyle(color: Colors.grey)),
                  onTapOutside: (e) {
                    searchFocusNode.unfocus();
                  },
                  onChanged: (query) {
                    ref
                        .read(myBidsViewModelProvider.notifier)
                        .searchItems(query);
                  },
                ),
              ),
            )
          ],
        ),
      ),
      if (searchController.text.isNotEmpty && myBidsState.filterState != FilterState.initialState()) ...{
        FilterTabGroup(
          provider: myBidsViewModelProvider,
          reset: () {
            ref
                .read(filterModelProvider(FilteringPage.bidsPage).notifier)
                .reset();
            ref
                .read(myBidsViewModelProvider.notifier)
                .filterAuctions(FilterState.initialState());
          },
        ),
        const SizedBox(
          height: 20,
        ),
        const BlackSemiBoldTitle('Live Auctions'),
        ...ref
            .read(myBidsViewModelProvider.notifier)
            .applyFilters(myBidsState.searchedRunningAuctions, myBidsState.filterState),

        const BlackSemiBoldTitle('Ended Auctions'),
        ...ref
            .read(myBidsViewModelProvider.notifier)
            .applyFilters(myBidsState.searchedEndedAuctions, myBidsState.filterState),
      } else if (searchController.text.isNotEmpty) ...{
        const SizedBox(
          height: 20,
        ),
        if (myBidsState.searchedRunningAuctions.isNotEmpty) const BlackSemiBoldTitle('Live Auctions'),
        ...myBidsState.searchedRunningAuctions,
        if (myBidsState.searchedEndedAuctions.isNotEmpty) const BlackSemiBoldTitle('Ended Auctions'),
        ...myBidsState.searchedEndedAuctions,

      } else if (myBidsState.filterState != FilterState.initialState()) ...{
        FilterTabGroup(
          provider: myBidsViewModelProvider,
          reset: () {
            ref
                .read(filterModelProvider(FilteringPage.bidsPage).notifier)
                .reset();
            ref
                .read(myBidsViewModelProvider.notifier)
                .filterAuctions(FilterState.initialState());
          },
        ),
        const SizedBox(
          height: 20,
        ),
        if (myBidsState.filteredRunningAuctions.isNotEmpty) const BlackSemiBoldTitle('Live Auctions'),
        ...myBidsState.filteredRunningAuctions,
        if (myBidsState.filteredEndedAuctions.isNotEmpty) const BlackSemiBoldTitle('Ended Auctions'),
        ...myBidsState.filteredEndedAuctions,

      } else ...{
        const SizedBox(
          height: 20,
        ),
        if (myBidsState.runningAuctions.isNotEmpty) const BlackSemiBoldTitle('Live Auctions'),
        ...myBidsState.runningAuctions,
        if (myBidsState.endedAuctions.isNotEmpty) const BlackSemiBoldTitle('Ended Auctions'),
        ...myBidsState.endedAuctions
      },
    ];

    return Scaffold(
      appBar: const MainPageAppBar('My Bids'),
      body: myBidsState.runningAuctions.isNotEmpty || myBidsState.endedAuctions.isNotEmpty ? RefreshIndicator(
        color: Theme.of(context).primaryColor,
        onRefresh: () async {
          ref.read(myBidsViewModelProvider.notifier).fetchAuctions();
        },
        child: ListView.builder(
          itemCount: widgets.length,
          itemBuilder: (context, index) {
            return widgets[index];
          },
        ),
      ) : const Center(child: Text('No Bids Yet!', style: TextStyle(fontSize: 18),),),
    );
  }
}
