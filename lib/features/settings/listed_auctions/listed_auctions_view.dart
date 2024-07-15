import 'package:bid_bazaar/features/settings/listed_auctions/listed_auctions_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/themes/app_theme.dart';
import '../../../core/common/widgets/custom_appbars.dart';
import '../../../core/common/widgets/filter_tab_group.dart';
import '../../../core/common/widgets/no_internet_widget.dart';
import '../../../core/common/widgets/title_widgets.dart';
import '../../../core/utils/connectivity_notifier.dart';
import '../../filter/filter.dart';
import '../../filter/filter_state.dart';
import '../../filter/filter_view_model.dart';

class ListedAuctionsView extends ConsumerStatefulWidget {
  const ListedAuctionsView({super.key});

  @override
  ConsumerState createState() => _ListedAuctionsViewState();
}

class _ListedAuctionsViewState extends ConsumerState<ListedAuctionsView> {
  final searchKey = GlobalKey<FormState>();
  final searchController = TextEditingController(text: "");
  final searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final listedAuctionsState = ref.watch(listedAuctionsViewModelProvider);

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
                    return const Filters(page: FilteringPage.myAuctionsPage);
                  },
                );
              },
              icon: SvgPicture.asset(
                'assets/images/svg/filter.svg',
                colorFilter: const ColorFilter.mode(
                    Colors.grey, BlendMode.srcIn),
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
                  cursorColor: Theme
                      .of(context)
                      .primaryColor,
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
                                .read(listedAuctionsViewModelProvider.notifier)
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0),
                      filled: false,
                      hintStyle: const TextStyle(color: Colors.grey)),
                  onTapOutside: (e) {
                    searchFocusNode.unfocus();
                  },
                  onChanged: (query) {
                    ref.read(listedAuctionsViewModelProvider.notifier).searchItems(
                        query);
                  },
                ),
              ),
            )
          ],
        ),
      ),
      if (searchController.text.isNotEmpty &&
          listedAuctionsState.filterState != FilterState.initialState()) ...{
        FilterTabGroup(
          provider: listedAuctionsViewModelProvider,
          reset: () {
            ref
                .read(filterModelProvider(FilteringPage.myAuctionsPage).notifier)
                .reset();
            ref
                .read(listedAuctionsViewModelProvider.notifier)
                .filterAuctions(FilterState.initialState());
          },
        ),
        const SizedBox(
          height: 20,
        ),
        const BlackSemiBoldTitle('Live Auctions'),
        ...ref.read(listedAuctionsViewModelProvider.notifier).applyFilters(
            listedAuctionsState.searchedRunningAuctions, listedAuctionsState.filterState),
        const BlackSemiBoldTitle('Ended Auctions'),
        ...ref.read(listedAuctionsViewModelProvider.notifier).applyFilters(
            listedAuctionsState.searchedEndedAuctions, listedAuctionsState.filterState),
      } else
        if (searchController.text.isNotEmpty) ...{
          const SizedBox(
            height: 20,
          ),
          if (listedAuctionsState.searchedRunningAuctions.isNotEmpty)
            const BlackSemiBoldTitle('Live Auctions'),
          ...listedAuctionsState.searchedRunningAuctions,
          if (listedAuctionsState.searchedEndedAuctions.isNotEmpty)
            const BlackSemiBoldTitle('Ended Auctions'),
          ...listedAuctionsState.searchedEndedAuctions,
        } else
          if (listedAuctionsState.filterState != FilterState.initialState()) ...{
            FilterTabGroup(
              provider: listedAuctionsViewModelProvider,
              reset: () {
                ref
                    .read(filterModelProvider(FilteringPage.myAuctionsPage).notifier)
                    .reset();
                ref
                    .read(listedAuctionsViewModelProvider.notifier)
                    .filterAuctions(FilterState.initialState());
              },
            ),
            const SizedBox(
              height: 20,
            ),
            if (listedAuctionsState.filteredRunningAuctions.isNotEmpty)
              const BlackSemiBoldTitle('Live Auctions'),
            ...listedAuctionsState.filteredRunningAuctions,
            if (listedAuctionsState.filteredEndedAuctions.isNotEmpty)
              const BlackSemiBoldTitle('Ended Auctions'),
            ...listedAuctionsState.filteredEndedAuctions,
          } else
            ...{
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text('Total Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                      Text(listedAuctionsState.totalItems.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Total Views', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                      Text(listedAuctionsState.totalViews.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),),
                    ],
                  ),
                  Column(
                    children: [
                      Text('Total Bids', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                      Text(listedAuctionsState.totalBids.toString(), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              if (listedAuctionsState.runningAuctions.isNotEmpty)
                const BlackSemiBoldTitle('Live Auctions'),
              ...listedAuctionsState.runningAuctions,
              if (listedAuctionsState.endedAuctions.isNotEmpty)
                const BlackSemiBoldTitle('Ended Auctions'),
              ...listedAuctionsState.endedAuctions
            },
    ];
    if (ref.watch(connectivityProvider) != ConnectivityStatus.isConnected) {
      return const NoInternetWidget();
    }
    return Scaffold(
        appBar: const BranchPageAppBar('Listed Auctions'),
        body: listedAuctionsState.runningAuctions.isNotEmpty ||
            listedAuctionsState.endedAuctions.isNotEmpty ? RefreshIndicator(
          color: Theme
              .of(context)
              .primaryColor,
          onRefresh: () async {
            ref.read(listedAuctionsViewModelProvider.notifier).fetchAuctions();
          },
          child: ListView.builder(
            itemCount: widgets.length,
            itemBuilder: (context, index) {
              return widgets[index];
            },
          ),
        ) : const Center(
          child: Text('No Bids Yet!', style: TextStyle(fontSize: 18),),),
    );
  }
}
