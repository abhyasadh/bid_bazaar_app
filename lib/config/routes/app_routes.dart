import 'package:bid_bazaar/features/add/add_view.dart';
import 'package:bid_bazaar/features/auth/login/login_view.dart';
import 'package:bid_bazaar/features/bottom_navigation/nav_view.dart';
import 'package:bid_bazaar/features/search_results/search_results_view.dart';
import 'package:bid_bazaar/features/settings/listed_auctions/listed_auctions_view.dart';

import '../../features/notification/notification_view.dart';
import '../../features/settings/account_settings/account_settings_view.dart';
import '../../features/settings/change_password/change_password_view.dart';

enum Purpose {reset, signup}

class AppRoutes {
  AppRoutes._();

  static const String loginRoute = '/login';

  static const String homeRoute = '/home';
  static const String notificationRoute = '/notification';
  static const String searchRoute = '/search';

  static const String addRoute = '/add';

  static const String accountSettingsRoute = '/account-settings';
  static const String changePasswordRoute = '/change-password';
  static const String listedAuctionsRoute = '/my-auctions';

  static getApplicationRoute() {
    return {
      loginRoute: (context) => const LoginView(),
      homeRoute: (context) => const NavView(),
      notificationRoute: (context) => const NotificationView(),
      searchRoute: (context) => const SearchResultsView(),
      addRoute: (context) => const AddView(),
      accountSettingsRoute: (context) => const AccountSettingsView(),
      changePasswordRoute: (context) => const ChangePasswordView(),
      listedAuctionsRoute: (context) => const ListedAuctionsView(),
    };
  }
}
