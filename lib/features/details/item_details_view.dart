import 'dart:math';

import 'package:bid_bazaar/config/navigation/navigation_service.dart';
import 'package:bid_bazaar/config/routes/app_routes.dart';
import 'package:bid_bazaar/features/add/add_view_model.dart';
import 'package:bid_bazaar/features/details/widgets/image_slider.dart';
import 'package:bid_bazaar/features/details/widgets/keyboard.dart';
import 'package:bid_bazaar/features/details/widgets/specification_table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../config/themes/app_theme.dart';
import '../../core/common/widgets/custom_appbars.dart';
import '../../core/common/widgets/custom_button.dart';
import '../../core/common/widgets/items/view/normal_item_view.dart';
import '../../core/common/widgets/items/view_model.dart';
import '../../core/common/widgets/no_internet_widget.dart';
import '../../core/utils/connectivity_notifier.dart';
import '../bottom_navigation/nav_view_model.dart';

class ItemDetailsView extends ConsumerStatefulWidget {
  final String itemId;
  final String itemName;
  final bool isOwn;

  const ItemDetailsView(
      {required this.itemId,
      required this.itemName,
      this.isOwn = false,
      super.key});

  @override
  ConsumerState createState() => _ItemDetailsViewState();
}

class _ItemDetailsViewState extends ConsumerState<ItemDetailsView> {
  @override
  void initState() {
    super.initState();
    if (!widget.isOwn) _increaseView();
  }

  Future<void> _increaseView() async {
    final itemDoc =
        FirebaseFirestore.instance.collection('items').doc(widget.itemId);
    FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(itemDoc);
      if (!snapshot.exists) {
        return;
      }
      int currentViewCount = snapshot.data()?['seen'] ?? 0;
      transaction.update(itemDoc, {'seen': currentViewCount + 1});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (ref.watch(connectivityProvider) != ConnectivityStatus.isConnected) {
      return const NoInternetWidget();
    }

    return Scaffold(
      appBar: BranchPageAppBar(
        widget.itemName,
        actionButton: widget.isOwn
            ? ItemDetailsStreamBuilder(
                itemId: widget.itemId,
                builder: (context, itemData) {
                  return IconButton(
                    onPressed: () {
                      ref.read(addViewModelProvider.notifier).copyWith(
                            id: itemData['id'],
                            title: itemData['title'],
                            imageUrls: (itemData['images'] as List<dynamic>?)
                                ?.map((item) => item.toString())
                                .toList(),
                            category: itemData['category'],
                            details: itemData['details'],
                            description: itemData['description'],
                            price: itemData['bid_prices'].isNotEmpty
                                ? itemData['bid_prices']
                                    [itemData['bid_count'] - 1]
                                : itemData['price'],
                            increment: itemData['min_increment'],
                            condition: itemData['condition'],
                            bidCount: itemData['bid_count'],
                            seen: itemData['seen'],
                            bidPrices:
                                (itemData['bid_prices'] as List<dynamic>?)
                                    ?.map((item) => int.parse(item.toString()))
                                    .toList(),
                            bidUsers: (itemData['bid_users'] as List<dynamic>?)
                                ?.map((item) => item.toString())
                                .toList(),
                            reports: (itemData['reports'] as List<dynamic>?)
                                ?.map((item) => item.toString())
                                .toList(),
                            saved: (itemData['saved'] as List<dynamic>?)
                                ?.map((item) => item.toString())
                                .toList(),
                          );
                      ref
                          .read(navigationServiceProvider)
                          .navigateTo(routeName: AppRoutes.addRoute);
                    },
                    icon: SvgPicture.asset(
                      'assets/images/svg/edit.svg',
                      colorFilter: const ColorFilter.mode(
                          Color(0xff787878), BlendMode.srcIn),
                      width: 20,
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
                  );
                },
              )
            : null,
        actionIcon: 'share',
        actionFunction: () async {
          await Share.share(
              'I just found this amazing item on Bid Bazaar! Check it out now!',
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ItemDetailsStreamBuilder(
        itemId: widget.itemId,
        builder: (context, itemData) {
          var price = itemData['bid_prices'].isNotEmpty
              ? itemData['bid_prices'][itemData['bid_count'] - 1]
              : itemData['price'];
          var minIncrement =
              itemData['bid_prices'].isNotEmpty ? itemData['min_increment'] : 0;

          if (formatDuration(itemData['time_limit']).substring(0, 5) ==
                  'Ended' &&
              itemData['bid_users'].isNotEmpty &&
              itemData['bid_users']
                  .contains(ref.watch(navViewModelProvider).userData?['uid']) &&
              itemData['bid_users'].length -
                      itemData['bid_users'].indexOf(
                          ref.watch(navViewModelProvider).userData?['uid']) ==
                  1 &&
              !widget.isOwn) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: CustomButton(
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(itemData['user_id'])
                        .snapshots()
                        .listen((snapshots) async {
                      final Uri url = Uri(
                        scheme: 'tel',
                        path: snapshots.data()?['phone'].substring(4),
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    });
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Contact Seller',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.phone_in_talk_rounded,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else if (formatDuration(itemData['time_limit']).substring(0, 5) ==
                  'Ends ' &&
              !widget.isOwn) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              color: Theme.of(context).scaffoldBackgroundColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: CustomButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return Keyboard(
                          itemId: widget.itemId,
                          minPrice: price,
                          minIncrement: minIncrement,
                        );
                      },
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Place a Bid',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(
                        Icons.gavel_rounded,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
      body: ItemDetailsStreamBuilder(
        itemId: widget.itemId,
        builder: (context, itemData) {
          return SingleChildScrollView(
            child: Column(
              children: [
                itemData['bid_users'].isNotEmpty &&
                        itemData['bid_users'].contains(
                            ref.watch(navViewModelProvider).userData?['uid'])
                    ? Container(
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.3),
                            border: Border.all(
                              color: AppTheme.primaryColor,
                            ),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                style: TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'Blinker',
                                    color:
                                        Theme.of(context).colorScheme.tertiary),
                                children: [
                                  const TextSpan(text: 'Current Position: '),
                                  TextSpan(
                                      text:
                                          '#${itemData['bid_users'].length - itemData['bid_users'].indexOf(ref.watch(navViewModelProvider).userData?['uid'])}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Row(
                              children: [
                                Icon(Iconsax.info_circle),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Text(
                                  'Seller\'s phone number will be accessible if you win the auction. If you do not win, seller may still contact you if higher bidders refuse to buy this item.',
                                  style: TextStyle(fontSize: 9),
                                )),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
                Container(
                  height: (MediaQuery.of(context).size.width - 40) * 3 / 4,
                  width: MediaQuery.of(context).size.width - 40,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: ImageSlider(
                    images: itemData['images'],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            'Rs. ${NumberFormat.decimalPattern().format(itemData['bid_prices'].isNotEmpty ? itemData['bid_prices'][itemData['bid_count'] - 1] : itemData['price'])}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(width: 20),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Iconsax.eye,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    ' ${itemData['seen']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Bid Count: ${itemData['bid_count']}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 10),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                formatDuration(itemData['time_limit']),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 10),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    !widget.isOwn &&
                            formatDuration(itemData['time_limit'])
                                    .substring(0, 5) !=
                                'Ended'
                        ? Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: InkWell(
                              onTap: () {
                                ref
                                    .read(itemViewModelProvider(widget.itemId))
                                    .save(widget.itemId, ref);
                              },
                              child: itemData['saved'] != null &&
                                      itemData['saved'].contains(ref
                                          .read(navViewModelProvider)
                                          .userData?['uid'])
                                  ? SvgPicture.asset(
                                      'assets/images/svg/save-filled.svg',
                                      width: 30,
                                    )
                                  : SvgPicture.asset(
                                      'assets/images/svg/save-2.svg',
                                      colorFilter: ColorFilter.mode(
                                          Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                          BlendMode.srcIn),
                                      width: 30,
                                    ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                  color: Colors.grey.withOpacity(0.4),
                  thickness: 2,
                  height: 40,
                ),
                StreamBuilder<DocumentSnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(itemData['user_id'])
                      .snapshots(),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var userData =
                        userSnapshot.data!.data() as Map<String, dynamic>;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              userData['profileImageUrl'] != null
                                  ? CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                          userData['profileImageUrl']),
                                    )
                                  : Container(
                                      width: 60,
                                      height: 60,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .inputDecorationTheme
                                              .fillColor,
                                          borderRadius:
                                              BorderRadius.circular(58)),
                                      child: SvgPicture.asset(
                                        'assets/images/svg/user.svg',
                                        colorFilter: const ColorFilter.mode(
                                            Colors.grey, BlendMode.srcIn),
                                      ),
                                    ),
                              const SizedBox(width: 14),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userData['firstName'] +
                                        ' ' +
                                        userData['lastName'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
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
                        ],
                      ),
                    );
                  },
                ),
                Divider(
                  indent: 20,
                  endIndent: 20,
                  color: Colors.grey.withOpacity(0.4),
                  thickness: 2,
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Description',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: AppTheme.primaryColor),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        itemData['description'],
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Specifications',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            color: AppTheme.primaryColor),
                      ),
                      const SizedBox(height: 6),
                      SpecificationTable(
                          fields: itemData['details'],
                          condition: itemData['condition']),
                      const SizedBox(height: 12),
                      RichText(
                        textAlign: TextAlign.center,
                        text: const TextSpan(
                          style: TextStyle(
                            fontFamily: 'Blinker',
                          ),
                          children: [
                            TextSpan(
                                text: 'Note: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                )),
                            TextSpan(
                              text:
                                  'Prior inspection of the product is recommended before making the payment. ',
                            ),
                            TextSpan(
                                text: 'DO NOT PAY IN ADVANCE!',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      if (!widget.isOwn) ...{
                        const Text(
                          'Similar Products',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: AppTheme.primaryColor),
                        ),
                        const SizedBox(height: 6),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('items')
                              .where('category', isEqualTo: itemData['category'])
                              .where('time_limit', isGreaterThan: Timestamp.now())
                              .limit(4)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            var items = snapshot.data!.docs
                                .where((doc) => doc.id != widget.itemId)
                                .take(4)
                                .toList();

                            if (items.isEmpty) {
                              return const SizedBox(
                                height: 80,
                                child: Center(
                                    child: Text('No similar items found!')),
                              );
                            }

                            return SizedBox(
                              height: 114 * items.length.toDouble(),
                              child: ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return NormalItemView.fromDocument(
                                    doc: items[index],
                                    padding: true,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      } else ...{
                        if (itemData['bid_users'].isNotEmpty) ...{
                          Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 12,
                            ),
                            decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.3),
                                border: Border.all(
                                  color: AppTheme.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(12)),
                            child: const Row(
                              children: [
                                Icon(Iconsax.info_circle),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Text(
                                  'Bidders\' phone number will be accessible at the end of the auction.',
                                  style: TextStyle(fontSize: 9),
                                )),
                              ],
                            ),
                          ),
                          const Text(
                            'Highest Bids',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: AppTheme.primaryColor),
                          ),
                        },
                        const SizedBox(height: 6),
                        for (int i = 0;
                            i < min(itemData['bid_users'].length, 8);
                            i++) ...{
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(itemData['bid_users'][0])
                                .snapshots(),
                            builder: (context, userSnapshot) {
                              if (!userSnapshot.hasData) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }

                              var userData = userSnapshot.data!.data()
                                  as Map<String, dynamic>;

                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        userData['profileImageUrl'] != null
                                            ? CircleAvatar(
                                                radius: 30,
                                                backgroundImage: NetworkImage(
                                                    userData[
                                                        'profileImageUrl']),
                                              )
                                            : Container(
                                                width: 60,
                                                height: 60,
                                                padding:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .inputDecorationTheme
                                                        .fillColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            58)),
                                                child: SvgPicture.asset(
                                                  'assets/images/svg/user.svg',
                                                  colorFilter:
                                                      const ColorFilter.mode(
                                                          Colors.grey,
                                                          BlendMode.srcIn),
                                                ),
                                              ),
                                        const SizedBox(width: 14),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              userData['firstName'] +
                                                  ' ' +
                                                  userData['lastName'],
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              'Rs. ${NumberFormat.decimalPattern().format(itemData['bid_prices'][i])}',
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    if (formatDuration(itemData['time_limit'])
                                            .substring(0, 5) ==
                                        'Ended')
                                      IconButton(
                                          onPressed: () async {
                                            final Uri url = Uri(
                                              scheme: 'tel',
                                              path: userData['phone']
                                                  .substring(4),
                                            );
                                            if (await canLaunchUrl(url)) {
                                              await launchUrl(url);
                                            } else {
                                              throw 'Could not launch $url';
                                            }
                                          },
                                          icon: const Icon(Icons.call))
                                  ],
                                ),
                              );
                            },
                          ),
                        }
                      },
                      if (widget.isOwn) ...{
                        const SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                          onPressed: () {
                            ref
                                .read(itemViewModelProvider(widget.itemId))
                                .deleteItem(widget.itemId, ref);
                          },
                          child: const Text(
                            'DELETE ITEM',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 21,
                        )
                      } else ...{
                        const SizedBox(
                          height: 100,
                        )
                      },
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String formatDuration(Timestamp timestamp) {
    DateTime now = DateTime.now();
    DateTime timestampDate = timestamp.toDate();

    bool endsInFuture = now.isBefore(timestampDate);

    Duration difference = endsInFuture
        ? timestampDate.difference(now)
        : now.difference(timestampDate);

    int days = difference.inDays;
    int hours = difference.inHours % 24;
    int minutes = difference.inMinutes % 60;

    String formatted =
        '${endsInFuture ? 'Ends In:' : 'Ended:'} ${days}D ${hours}H ${minutes}M';
    return formatted;
  }
}

class ItemDetailsStreamBuilder extends ConsumerWidget {
  final String itemId;
  final Widget Function(BuildContext, Map<String, dynamic>) builder;

  const ItemDetailsStreamBuilder(
      {required this.itemId, required this.builder, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('items')
          .doc(itemId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData) {
          return const Center(child: Text('No data found'));
        }
        var itemData = snapshot.data!.data() as Map<String, dynamic>;
        itemData['id'] = itemId;
        return builder(context, itemData);
      },
    );
  }
}
