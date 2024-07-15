import 'package:bid_bazaar/config/routes/app_routes.dart';
import 'package:bid_bazaar/config/themes/app_theme.dart';
import 'package:bid_bazaar/core/common/messages/alert_dialogue.dart';
import 'package:bid_bazaar/core/common/widgets/custom_appbars.dart';
import 'package:bid_bazaar/core/common/widgets/no_internet_widget.dart';
import 'package:bid_bazaar/features/add/add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/navigation/navigation_service.dart';
import '../../core/utils/connectivity_notifier.dart';

class AddView extends ConsumerStatefulWidget {
  const AddView({super.key});

  @override
  ConsumerState createState() => _AddViewState();
}

class _AddViewState extends ConsumerState<AddView> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(addViewModelProvider.notifier)
          .setPageController(_pageController);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addState = ref.watch(addViewModelProvider);

    return PopScope(
      canPop: addState.index == 0,
      onPopInvoked: (value) {
        if (addState.index > 0) {
          ref
              .read(addViewModelProvider.notifier)
              .changeIndex(addState.index - 1);
        } else {
          RoutePopDisposition.pop;
        }
      },
      child: Scaffold(
        appBar: BranchPageAppBar(ref.watch(connectivityProvider) == ConnectivityStatus.isConnected
            ? 'Add Auction' : '', onBackInvoked: () {
          if (addState.index > 0) {
            ref
                .read(addViewModelProvider.notifier)
                .changeIndex(addState.index - 1);
          } else if (ref.read(addViewModelProvider).title != null ||
              ref.read(addViewModelProvider).images.isNotEmpty) {
            showAlertDialogue(
              message: 'Are you sure you want to quit and discard all changes?',
              context: context,
              ref: ref,
              onConfirm: () {
                ref.read(navigationServiceProvider).goBack();
                ref.read(navigationServiceProvider).goBack();
              },
            );
          } else {
            ref.read(navigationServiceProvider).goBack();
          }
        }),
        body: ref.watch(connectivityProvider) != ConnectivityStatus.isConnected
            ? const Scaffold(
                body: NoInternetWidget(bottomPadding: 100,),
        )
            : Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StepIndicator(text: 'Step 1: Title and Image', index: 0),
                      StepIndicator(text: 'Step 2: Details', index: 1),
                      StepIndicator(text: 'Step 3: Price and Time', index: 2),
                      StepIndicator(text: 'Step 4: Confirmation', index: 3),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: addState.listWidgets,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class StepIndicator extends ConsumerWidget {
  final String text;
  final int index;

  const StepIndicator({super.key, required this.text, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool isActive = ref.watch(addViewModelProvider).index >= index;

    return Column(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: isActive ? null : Colors.grey.withOpacity(0.5),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.primaryColor
                : Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.horizontal(
              left: index == 0 ? const Radius.circular(4) : Radius.zero,
              right: index == 3 ? const Radius.circular(4) : Radius.zero,
            ),
          ),
          width: (MediaQuery.of(context).size.width - 40) / 4,
          height: 6,
        ),
      ],
    );
  }
}
