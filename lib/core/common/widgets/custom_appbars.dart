import 'package:bid_bazaar/config/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../config/navigation/navigation_service.dart';

class MainPageAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;

  const MainPageAppBar(this.title, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(fontSize: 32, color: AppTheme.primaryColor),
      ),
      titleSpacing: 30,
      toolbarHeight: 100,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}

class BranchPageAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final String title;
  final String? actionIcon;
  final Function()? actionFunction;
  final Widget? actionButton;
  final Function()? onBackInvoked;

  const BranchPageAppBar(this.title,
      {super.key, this.actionIcon, this.actionFunction, this.actionButton, this.onBackInvoked});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 26,
          color: AppTheme.primaryColor,
          // Update this according to your app theme
          fontWeight: FontWeight.w600,
        ),
      ),
      leading: IconButton(
        onPressed: onBackInvoked ?? () {
          ref.read(navigationServiceProvider).goBack();
        },
        icon: SvgPicture.asset(
          'assets/images/svg/arrow-left-1.svg',
          colorFilter:
              const ColorFilter.mode(Color(0xff787878), BlendMode.srcIn),
          width: 16,
        ),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(
            Theme.of(context).colorScheme.primary,
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          fixedSize: WidgetStateProperty.all(const Size(50, 50)),
        ),
      ),
      leadingWidth: 80,
      toolbarHeight: 100,
      backgroundColor: Colors.transparent,
      actions: actionIcon != null && actionIcon != 'mark-read'
          ? [
              const SizedBox(width: 15),
              IconButton(
                onPressed: actionFunction,
                icon: SvgPicture.asset(
                  'assets/images/svg/$actionIcon.svg',
                  colorFilter: const ColorFilter.mode(
                      Color(0xff787878), BlendMode.srcIn),
                  width: 16,
                ),
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary,
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  fixedSize: WidgetStateProperty.all(const Size(50, 50)),
                ),
              ),
              const SizedBox(width: 15),
            ]
          : actionIcon == 'mark-read'
              ? [
                  InkWell(
                    onTap: (){},
                    child: const Text(
                      'Mark Read',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey),
                    ),
                  ),
                  const SizedBox(width: 15),
                ]
              : actionButton !=null ? [
                  const SizedBox(width: 15),
                  actionButton!,
                  const SizedBox(width: 15),
      ]: [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
