import 'package:bid_bazaar/config/navigation/navigation_service.dart';
import 'package:bid_bazaar/config/routes/app_routes.dart';
import 'package:bid_bazaar/config/themes/app_theme.dart';
import 'package:bid_bazaar/core/common/widgets/custom_appbars.dart';
import 'package:bid_bazaar/core/common/widgets/title_widgets.dart';
import 'package:bid_bazaar/features/bottom_navigation/nav_view_model.dart';
import 'package:bid_bazaar/features/settings/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/shared_preferences/app_prefs.dart';
import '../../core/utils/theme_pref.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.read(navViewModelProvider).userData!;

    return Scaffold(
      appBar: const MainPageAppBar('Settings'),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 30, bottom: 10),
            child: InkWell(
              onTap: () {
                ref.read(navigationServiceProvider).navigateTo(
                      routeName: AppRoutes.accountSettingsRoute,
                    );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      userData['profileImageUrl'] != null
                          ? CircleAvatar(
                              radius: 37,
                              backgroundImage:
                                  NetworkImage(userData['profileImageUrl']),
                            )
                          : Container(
                              width: 74,
                              height: 74,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor,
                                  borderRadius: BorderRadius.circular(58)),
                              child: SvgPicture.asset(
                                'assets/images/svg/user.svg',
                                colorFilter: const ColorFilter.mode(
                                    Colors.grey, BlendMode.srcIn),
                              ),
                            ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userData['firstName'] + ' ' + userData['lastName'],
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor),
                          ),
                          Text(
                            userData['phone'].substring(4),
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          ),
                          Text(
                            userData['email'],
                            style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: const BlackSemiBoldTitle('Listed Auctions'),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
            ),
            contentPadding: const EdgeInsets.only(right: 30,),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            onTap: (){ref.read(navigationServiceProvider).navigateTo(routeName: AppRoutes.listedAuctionsRoute);}
          ),
          Divider(
            color: Colors.grey.withOpacity(0.5),
            indent: 20,
            endIndent: 20,
          ),
          const BlackSemiBoldTitle('System Settings'),
          ListTile(
            title: const Text(
              'Push Notifications',
              style: TextStyle(
                fontFamily: 'Blinker',
                fontSize: 16,
              ),
            ),
            contentPadding:
                const EdgeInsets.only(top: 4, bottom: 4, left: 30, right: 30),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(18.0), // Adjust the value as needed
            ),
            trailing: Switch(
              value: true,
              onChanged: (bool value) {},
              activeTrackColor: AppTheme.primaryColor,
              inactiveTrackColor: Theme.of(context).colorScheme.primary,
              trackOutlineWidth: WidgetStateProperty.all(0),
              trackOutlineColor: WidgetStateColor.transparent,
            ),
          ),
          ListTile(
            title: const Text(
              'Dark Mode',
              style: TextStyle(
                fontFamily: 'Blinker',
                fontSize: 16,
              ),
            ),
            contentPadding:
                const EdgeInsets.only(top: 4, bottom: 4, left: 30, right: 30),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(18.0), // Adjust the value as needed
            ),
            trailing: DropdownButtonHideUnderline(
              child: Container(
                width: 90,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.primary),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButton<String>(
                  value: ref.watch(getThemeProvider) == AppThemePref.system
                      ? 'System'
                      : ref.watch(getThemeProvider) == AppThemePref.dark
                          ? 'Dark'
                          : 'Light',
                  items: ['System', 'Dark', 'Light']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,
                          style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Blinker',
                              color: Theme.of(context).colorScheme.tertiary)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    ref.read(getThemeProvider.notifier).updateTheme(newValue!);
                  },
                  isDense: true,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                  icon: const Icon(Icons.arrow_drop_down, size: 16),
                  // Adjust icon size
                  iconSize: 16, // Adjust the height of each item
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.grey.withOpacity(0.5),
            indent: 20,
            endIndent: 20,
          ),
          const BlackSemiBoldTitle('More'),
          ListTile(
            title: const Text(
              'FAQs',
              style: TextStyle(
                fontFamily: 'Blinker',
                fontSize: 16,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
            ),
            contentPadding: const EdgeInsets.only(right: 30, left: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          ListTile(
            title: const Text(
              'Contact Us',
              style: TextStyle(
                fontFamily: 'Blinker',
                fontSize: 16,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
            ),
            contentPadding: const EdgeInsets.only(right: 30, left: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          ListTile(
            title: const Text(
              'Terms and Conditions',
              style: TextStyle(
                fontFamily: 'Blinker',
                fontSize: 16,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
            ),
            contentPadding: const EdgeInsets.only(right: 30, left: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          ListTile(
            title: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.errorColor,
              ),
            ),
            contentPadding:
                const EdgeInsets.only(top: 4, bottom: 4, left: 30, right: 30),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(18.0), // Adjust the value as needed
            ),
            trailing: SvgPicture.asset(
              'assets/images/svg/logout-1.svg',
              colorFilter:
                  const ColorFilter.mode(AppTheme.errorColor, BlendMode.srcIn),
            ),
            onTap: () {
              ref.read(settingsViewModelProvider.notifier).logout();
            },
          ),
        ],
      ),
    );
  }
}
