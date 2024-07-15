import 'package:bid_bazaar/config/themes/app_theme.dart';
import 'package:bid_bazaar/features/notification/widget/notifcation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../config/navigation/navigation_service.dart';
import '../../core/common/widgets/no_internet_widget.dart';
import '../../core/utils/connectivity_notifier.dart';

class NotificationView extends ConsumerWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(connectivityProvider) != ConnectivityStatus.isConnected) {
      return const NoInternetWidget();
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Notifications',
            style: TextStyle(
              fontSize: 26,
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: IconButton(
            onPressed: () {
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
          actions: [
            InkWell(
              onTap: (){},
              child: const Text(
                'Mark Read',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 15),
          ],
          bottom: TabBar(
            tabs: const [
              Tab(icon: Text('Bids Placed', style: TextStyle(fontSize: 18),)),
              Tab(icon: Text('My Auctions', style: TextStyle(fontSize: 18),)),
            ],
            labelColor: Theme.of(context).colorScheme.tertiary,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 4,
            indicatorColor: AppTheme.primaryColor,
            dividerColor: Colors.grey,
          ),
        ),
        body: const TabBarView(
          children: [
            Column(
              children: [
                NotificationWidget(read: false,),
                NotificationWidget(),
                NotificationWidget(),
              ],
            ),
            Column(
              children: [
                NotificationWidget(read: false,),
                NotificationWidget(),
                NotificationWidget(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
