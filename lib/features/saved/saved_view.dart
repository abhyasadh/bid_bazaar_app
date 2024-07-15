import 'package:bid_bazaar/core/common/widgets/custom_appbars.dart';
import 'package:bid_bazaar/core/common/widgets/filter_tab_group.dart';
import 'package:bid_bazaar/features/saved/saved_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/themes/app_theme.dart';
import '../../core/common/widgets/no_internet_widget.dart';
import '../../core/utils/connectivity_notifier.dart';
import '../filter/filter.dart';
import '../filter/filter_state.dart';
import '../filter/filter_view_model.dart';

class SavedView extends ConsumerStatefulWidget {
  const SavedView({super.key});

  @override
  ConsumerState createState() => _SavedViewState();
}

class _SavedViewState extends ConsumerState<SavedView> {
  final searchKey = GlobalKey<FormState>();
  final searchController = TextEditingController(text: "");
  final searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    if (ref.watch(connectivityProvider) != ConnectivityStatus.isConnected) {
      return const NoInternetWidget();
    }

    final savedState = ref.watch(savedViewModelProvider);

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
                    return const Filters(page: FilteringPage.savedPage);
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
                                    .read(savedViewModelProvider.notifier)
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
                        .read(savedViewModelProvider.notifier)
                        .searchItems(query);
                  },
                ),
              ),
            )
          ],
        ),
      ),
      if (searchController.text.isNotEmpty &&
          savedState.filterState != FilterState.initialState()) ...{
        FilterTabGroup(
          provider: savedViewModelProvider,
          reset: () {
            ref
                .read(filterModelProvider(FilteringPage.savedPage).notifier)
                .reset();
            ref
                .read(savedViewModelProvider.notifier)
                .filterAuctions(FilterState.initialState());
          },
        ),
        const SizedBox(
          height: 20,
        ),
        ...ref
            .read(savedViewModelProvider.notifier)
            .applyFilters(savedState.searchedAuctions, savedState.filterState),
      } else if (searchController.text.isNotEmpty) ...{
        const SizedBox(
          height: 20,
        ),
        ...savedState.searchedAuctions,
      } else if (savedState.filterState != FilterState.initialState()) ...{
        FilterTabGroup(
          provider: savedViewModelProvider,
          reset: () {
            ref
                .read(filterModelProvider(FilteringPage.savedPage).notifier)
                .reset();
            ref
                .read(savedViewModelProvider.notifier)
                .filterAuctions(FilterState.initialState());
          },
        ),
        const SizedBox(
          height: 20,
        ),
        ...savedState.filteredAuctions
      } else if (savedState.allAuctions.isNotEmpty)...{
        const SizedBox(
          height: 20,
        ),
        ...savedState.allAuctions
      },
    ];

    return Scaffold(
        appBar: const MainPageAppBar('Saved Auctions'),
        body: savedState.allAuctions.isNotEmpty ? RefreshIndicator(
          color: Theme.of(context).primaryColor,
          onRefresh: () async {
            ref.read(savedViewModelProvider.notifier).fetchAuctions();
          },
          child: ListView.builder(
            itemCount: widgets.length,
            itemBuilder: (context, index) {
              return widgets[index];
            },
          ),
        ) : const Center(child: Text('Nothing Saved!', style: TextStyle(fontSize: 18),),),
    );
  }
}
