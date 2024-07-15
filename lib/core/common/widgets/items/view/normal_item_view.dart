import 'dart:io';

import 'package:bid_bazaar/config/themes/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../config/navigation/navigation_service.dart';
import '../../../../../features/details/item_details_view.dart';
import '../view_model.dart';

class NormalItemView extends ConsumerStatefulWidget {

  final String itemId;
  final File? imageFile;
  final String? imageLink;
  final String title;
  final int price;
  final int bidCount;
  final String endsIn;
  final bool isSaved;
  final String category;
  final bool padding;
  final bool isOwn;

  const NormalItemView(
      {super.key, this.itemId = '0', this.imageFile, this.imageLink, required this.title, required this.price, required this.bidCount, required this.endsIn, required this.isSaved, required this.category, this.padding=false, this.isOwn=false});

  factory NormalItemView.fromDocument({required DocumentSnapshot doc, bool padding = false, bool isOwn = false}){
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return NormalItemView(
      itemId: doc.id,
      imageLink: data['images'][0],
      title: data['title'],
      price: data['bid_prices'].isNotEmpty ? data['bid_prices'][data['bid_count']-1] : data['price'],
      bidCount: data['bid_count'],
      endsIn: formatDuration(data['time_limit']),
      isSaved: data['saved'] != null && data['saved'].contains(FirebaseAuth.instance.currentUser?.uid),
      category: data['category'],
      padding: padding,
      isOwn: isOwn,
    );
  }

  @override
  ConsumerState createState() => _NormalItemViewState();
}

class _NormalItemViewState extends ConsumerState<NormalItemView> {

  final GlobalKey menuKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        ref.read(navigationServiceProvider).navigateTo(
            page: ItemDetailsView(itemId: widget.itemId, itemName: widget.title, isOwn: widget.isOwn,));
      },
      child: Container(
        margin: widget.padding ? const EdgeInsets.only(bottom: 22) : const EdgeInsets.only(left: 14, right: 14, bottom: 22),
        child: Row(
          children: [
            Container(
              height: 92,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary, width: 3),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(17),
                child: widget.itemId == '0' ? Image.file(
                  widget.imageFile!,
                  fit: BoxFit.fill,
                ) : CachedNetworkImage(imageUrl: widget.imageLink!, fit: BoxFit.fill,),
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Container(
                height: 92,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme
                      .of(context)
                      .colorScheme
                      .primary,
                ),
                padding:
                const EdgeInsets.only(top: 12, bottom: 12, left: 14, right: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 196,
                          child: Text(
                            widget.title,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor,
                                height: 1
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 196,
                          child: Text(
                            'Rs. ${NumberFormat.decimalPattern().format(
                                widget.price)}',
                            style: const TextStyle(
                              height: 1,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 1,),
                        Row(
                          children: [
                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              decoration: BoxDecoration(
                                color:
                                Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                'Bid Count: ${widget.bidCount}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 10),
                              ),
                            ),
                            const SizedBox(width: 8,),
                            Container(
                              padding:
                              const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 8),
                              decoration: BoxDecoration(
                                color:
                                Colors.grey.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                widget.endsIn,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 10),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
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
                        const SizedBox(height: 4,),
                        widget.endsIn.substring(0, 5) != 'Ended' && !widget.isOwn ? InkWell(
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
                        ):const SizedBox.shrink()
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
        if (!widget.isOwn) const PopupMenuItem<int>(
          value: 1,
          child: Row(
            children: [
              Icon(Icons.flag, color: AppTheme.errorColor, size: 20,),
              SizedBox(width: 8),
              Text('Report', style: TextStyle(color: AppTheme.errorColor),),
            ],
          ),
        ),
        if (widget.isOwn) const PopupMenuItem<int>(
          value: 2,
          child: Row(
            children: [
              Icon(Iconsax.trash, color: AppTheme.errorColor, size: 20,),
              SizedBox(width: 8),
              Text('Delete', style: TextStyle(color: AppTheme.errorColor),),
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
      } else if (value == 2) {
      ref.read(itemViewModelProvider(widget.itemId)).deleteItem(widget.itemId, ref);
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

  Duration difference = endsInFuture ? timestampDate.difference(now) : now.difference(timestampDate);

  int days = difference.inDays;
  int hours = difference.inHours % 24;
  int minutes = difference.inMinutes % 60;

  String formatted = '${endsInFuture ? 'Ends In:' : 'Ended:'} ${days}D ${hours}H ${minutes}M';
  return formatted;
}