import 'package:bid_bazaar/core/common/widgets/custom_appbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/themes/app_theme.dart';
import '../../core/common/widgets/no_internet_widget.dart';
import '../../core/utils/connectivity_notifier.dart';

class SearchResultsView extends ConsumerStatefulWidget {
  const SearchResultsView({super.key});

  @override
  ConsumerState createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends ConsumerState<SearchResultsView> {
  final searchKey = GlobalKey<FormState>();
  late TextEditingController searchController;
  final searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var query = ModalRoute.of(context)?.settings.arguments as String;
    searchController.text = query;
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(connectivityProvider) != ConnectivityStatus.isConnected) {
      return const NoInternetWidget();
    }

    return Scaffold(
      appBar: const BranchPageAppBar(''),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Form(
              key: searchKey,
              child: TextFormField(
                focusNode: searchFocusNode,
                controller: searchController,
                cursorColor: Theme.of(context).primaryColor,
                textInputAction: TextInputAction.search,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Search items...',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SvgPicture.asset(
                      'assets/images/svg/search-normal-1.svg',
                      colorFilter: const ColorFilter.mode(
                          AppTheme.primaryColor, BlendMode.srcIn),
                      width: 14,
                    ),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
                  filled: false,
                  hintStyle: const TextStyle(color: Colors.grey),
                ),
                onTapOutside: (e) {
                  searchFocusNode.unfocus();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}