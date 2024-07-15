import 'package:bid_bazaar/config/navigation/navigation_service.dart';
import 'package:bid_bazaar/config/routes/app_routes.dart';
import 'package:bid_bazaar/features/add/add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:page_transition/page_transition.dart';

import 'nav_view_model.dart';

class NavView extends ConsumerStatefulWidget {
  const NavView({super.key});

  @override
  ConsumerState createState() => _NavViewState();
}

class _NavViewState extends ConsumerState<NavView> {

  @override
  Widget build(BuildContext context) {
    final navState = ref.watch(navViewModelProvider);

    return Scaffold(
      body: navState.listWidgets[navState.index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        margin: const EdgeInsets.only(left: 14, right: 14, bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            NavItem(
              icon: 'home-2',
              label: "Home",
              index: 0,
              onTap: () =>
              {ref.read(navViewModelProvider.notifier).changeIndex(0)},
            ),
            NavItem(
              icon: 'save-1',
              label: "Saved",
              index: 1,
              onTap: () =>
              {ref.read(navViewModelProvider.notifier).changeIndex(1)},
            ),
            NavItem(
              icon: 'add-square',
              label: "Add",
              index: -1,
              onTap: () => {
                ref.read(addViewModelProvider.notifier).resetState(),
                ref.read(navigationServiceProvider).navigateTo(routeName: AppRoutes.addRoute, transitionType: PageTransitionType.bottomToTop)
              },
            ),
            NavItem(
              icon: 'judge',
              label: "My Bids",
              index: 2,
              onTap: () =>
              {ref.read(navViewModelProvider.notifier).changeIndex(2)},
            ),
            NavItem(
              icon: 'setting-2',
              label: "Settings",
              index: 3,
              onTap: () =>
              {ref.read(navViewModelProvider.notifier).changeIndex(3)},
            ),
          ],
        ),
      ),
    );
  }
}

class NavItem extends ConsumerWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;
  final int index;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navViewModelProvider);
    final size = (60 / 411.42857142857144) * MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(6),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: navState.index == index
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/svg/$icon.svg',
              colorFilter: ColorFilter.mode(
                  navState.index != index
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).primaryColor, BlendMode.srcIn),
              width: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontFamily: "Blinker",
                fontWeight: FontWeight.w600,
                color: navState.index != index
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
