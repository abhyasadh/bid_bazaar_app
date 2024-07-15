import 'dart:ui';

import 'package:bid_bazaar/config/navigation/navigation_service.dart';
import 'package:bid_bazaar/config/themes/app_theme.dart';
import 'package:bid_bazaar/features/details/item_details_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../view_model.dart';

class FeaturedItemView extends ConsumerStatefulWidget {

  final String itemId;
  final String imageLink;
  final String title;
  final int price;
  final int bidCount;
  final String endsIn;
  final bool isSaved;
  final String category;

  const FeaturedItemView(
      {super.key, required this.itemId, required this.imageLink, required this.title, required this.price, required this.bidCount, required this.endsIn, required this.isSaved, required this.category});

  factory FeaturedItemView.fromDocument(DocumentSnapshot doc){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FeaturedItemView(
      itemId: doc.id,
      imageLink: data['images'][0],
      title: data['title'],
      price: data['bid_prices'].isNotEmpty ? data['bid_prices'][data['bid_count']] : data['price'],
      bidCount: data['bid_count'],
      endsIn: formatDuration(data['time_limit']),
      isSaved: data['saved'] != null && data['saved'].contains(FirebaseAuth.instance.currentUser?.uid),
      category: data['category'],
    );
  }

  @override
  ConsumerState createState() => _FeaturedItemViewState();
}

class _FeaturedItemViewState extends ConsumerState<FeaturedItemView> {

  final GlobalKey menuKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        ref.read(navigationServiceProvider).navigateTo(
            page: ItemDetailsView(itemId: widget.itemId, itemName: widget.title,));
      },
      child: Column(
        children: [
          Container(
            height: 230,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(60),
                bottom: Radius.circular(10),
              ),
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary, width: 4),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  bottom: 0,
                  right: 0,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(56),
                      bottom: Radius.circular(6),
                    ),
                    child: CachedNetworkImage(imageUrl: widget.imageLink, fit: BoxFit.fill,),
                  ),
                ),
                Positioned(
                  bottom: 3,
                  left: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                          color:
                          Theme.of(context).colorScheme.primary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'Bid Count: ${widget.bidCount}',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 3,
                  right: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                        decoration: BoxDecoration(
                          color:
                          Theme.of(context).colorScheme.primary.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          widget.endsIn,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Container(
            height: 70,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
                bottom: Radius.circular(20),
              ),
              color: Theme.of(context).colorScheme.primary,
            ),
            padding:
            const EdgeInsets.only(top: 4, bottom: 8, left: 14, right: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 232,
                      child: Text(
                        widget.title,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.primaryColor),
                      ),
                    ),
                    SizedBox(
                      width: 232,
                      child: Text(
                        'Rs. ${NumberFormat.decimalPattern().format(
                            widget.price)}',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 4),
                    InkWell(
                      key: menuKey,
                      onTap: () {
                        _showPopupMenu(context);
                      },
                      child: SvgPicture.asset(
                        'assets/images/svg/more.svg',
                        colorFilter: ColorFilter.mode(
                            Theme
                                .of(context)
                                .colorScheme
                                .tertiary, BlendMode.srcIn),
                        width: 22,
                      ),
                    ),
                    const SizedBox(height: 4),
                    InkWell(
                      onTap: () {
                        ref
                            .read(
                            itemViewModelProvider(widget.itemId))
                            .save(widget.itemId, ref);
                      },
                      child: widget.isSaved ? SvgPicture.asset(
                        'assets/images/svg/save-filled.svg',
                        width: 22,
                      ) : SvgPicture.asset(
                        'assets/images/svg/save-2.svg',
                        colorFilter: ColorFilter.mode(
                            Theme
                                .of(context)
                                .colorScheme
                                .tertiary, BlendMode.srcIn),
                        width: 22,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPopupMenu(BuildContext context) async {
    final RenderBox renderBox = menuKey.currentContext?.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        position.dx,
        position.dy + size.height,
        position.dx + size.width,
        position.dy,
      ),
      items: [
        const PopupMenuItem<int>(
          value: 0,
          child: Row(
            children: [
              Icon(Icons.share, size: 20,),
              SizedBox(width: 8),
              Text('Share'),
            ],
          ),
        ),
        const PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.flag, color: AppTheme.errorColor, size: 20,),
              SizedBox(width: 8),
              Text('Report', style: TextStyle(color: AppTheme.errorColor),),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value == 0) {
        _handleShare();
      } else if (value == 1) {
        _handleReport();
      }
    });
  }

  void _handleShare() async {
    await Share.share('I just found this amazing item on Bid Bazaar! Check it out now!');
  }

  void _handleReport() {
    print('Report tapped');
  }
}

String formatDuration(Timestamp timestamp) {
  DateTime now = DateTime.now();
  DateTime timestampDate = timestamp.toDate();

  bool endsInFuture = now.isBefore(timestampDate);

  Duration difference = !endsInFuture ? now.difference(timestampDate) : timestampDate.difference(now);

  int days = difference.inDays;
  int hours = difference.inHours % 24;
  int minutes = difference.inMinutes % 60;

  String formatted = '${endsInFuture ? 'Ends In:' : 'Ended:'} ${days}D ${hours}H ${minutes}M';
  return formatted;
}