import 'package:bid_bazaar/config/navigation/navigation_service.dart';
import 'package:bid_bazaar/config/routes/app_routes.dart';
import 'package:bid_bazaar/config/themes/app_theme.dart';
import 'package:bid_bazaar/core/common/widgets/no_internet_widget.dart';
import 'package:bid_bazaar/features/bottom_navigation/nav_view_model.dart';
import 'package:bid_bazaar/features/filter/filter_state.dart';
import 'package:bid_bazaar/features/home/pages/default_home_screen.dart';
import 'package:bid_bazaar/features/home/pages/filtered_home_screen.dart';
import 'package:bid_bazaar/features/home/pages/search_results_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/utils/connectivity_notifier.dart';
import '../filter/filter.dart';
import 'home_view_model.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  final searchKey = GlobalKey<FormState>();
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  final ScrollController _scrollController = ScrollController();
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _scrollController.addListener(() {
      if (_scrollController.offset > 300) {
        if (!ref.read(homeViewModelProvider).showScrollButton) {
          ref.read(homeViewModelProvider.notifier).showScrollToTopButton(true);
        }
      } else {
        if (ref.read(homeViewModelProvider).showScrollButton) {
          ref.read(homeViewModelProvider.notifier).showScrollToTopButton(false);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    searchFocusNode.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(connectivityProvider) != ConnectivityStatus.isConnected) {
      return const NoInternetWidget();
    }

    final homeState = ref.watch(homeViewModelProvider);

    final widgetList = [
      AppBar(
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateTime.now().hour < 12
                    ? 'Good Morning!'
                    : DateTime.now().hour < 18
                        ? 'Good Afternoon!'
                        : 'Good Evening!',
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 22,
                    fontFamily: 'Blinker',
                    fontWeight: FontWeight.normal),
              ),
              Text(
                '${ref.watch(navViewModelProvider).userData?['firstName'] ?? ' '} ${ref.watch(navViewModelProvider).userData?['lastName'] ?? ' '}',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontFamily: 'Blinker',
                    fontSize: 30,
                    color: Theme.of(context).primaryColor,
                    letterSpacing: 1.1),
              )
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14.0),
            child: IconButton(
              onPressed: () {
                ref
                    .read(navigationServiceProvider)
                    .navigateTo(routeName: AppRoutes.notificationRoute);
              },
              icon: SvgPicture.asset(
                'assets/images/svg/notification.svg',
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
          )
        ],
      ),
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
                    return const Filters(
                      page: FilteringPage.homePage,
                    );
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
                                    .read(homeViewModelProvider.notifier)
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
                    ref.read(homeViewModelProvider.notifier).searchItems(query);
                  },
                ),
              ),
            )
          ],
        ),
      ),
      if (searchController.text.isNotEmpty &&
          homeState.filterState != FilterState.initialState()) ...{
        ...SearchResultsScreen().buildItemList(context, ref),
      } else if (searchController.text.isNotEmpty) ...{
        ...SearchResultsScreen().buildItemList(context, ref),
      } else if (homeState.filterState != FilterState.initialState()) ...{
        ...FilteredHomeScreen().buildItemList(context, ref),
      } else ...{
        ...DefaultHomeScreen().buildItemList(context, ref),
      }
    ];

    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerTop,
        floatingActionButton: ref.watch(homeViewModelProvider).showScrollButton
            ? Container(
                margin: const EdgeInsets.only(top: 10),
                width: 50,
                height: 50,
                child: FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: AppTheme.primaryColor,
                  onPressed: () {
                    _scrollController.animateTo(
                      0,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Icon(
                    Icons.arrow_upward_rounded,
                    weight: 0.5,
                  ),
                ),
              )
            : null,
        body: homeState.isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryColor,
                ),
              )
            : RefreshIndicator(
                color: Theme.of(context).primaryColor,
                onRefresh: () async {
                  ref.read(homeViewModelProvider.notifier).fetchAuctions();
                },
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: widgetList.length,
                  itemBuilder: (context, index) {
                    return widgetList[index];
                  },
                ),
              ),
      ),
    );
  }
}
