import 'package:bid_bazaar/config/navigation/navigation_service.dart';
import 'package:bid_bazaar/config/themes/app_theme.dart';
import 'package:bid_bazaar/core/common/messages/snackbar.dart';
import 'package:bid_bazaar/features/bottom_navigation/nav_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../core/common/widgets/custom_button.dart';

class Keyboard extends ConsumerStatefulWidget {
  final String itemId;
  final int minPrice;
  final int minIncrement;

  const Keyboard(
      {super.key, required this.itemId, required this.minPrice, required this.minIncrement});

  @override
  ConsumerState createState() => _KeyboardState();
}

class _KeyboardState extends ConsumerState<Keyboard> {
  late TextEditingController controller;
  late int amount = 0;

  @override
  void initState() {
    amount = widget.minPrice + widget.minIncrement;
    controller = TextEditingController(
        text: 'Rs. ${NumberFormat.decimalPattern().format(amount)}');
    super.initState();
  }

  Future<void> _placeBid(int bidAmount) async {
    final userId = ref.read(navViewModelProvider).userData?['uid'];

    final itemDoc = FirebaseFirestore.instance.collection('items').doc(widget.itemId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(itemDoc);

      if (!snapshot.exists) {
        throw Exception('Item does not exist');
      }

      final itemData = snapshot.data() as Map<String, dynamic>;

      List<dynamic> bidPrices = itemData['bid_prices'] ?? [];
      List<dynamic> bidUsers = itemData['bid_users'] ?? [];
      int bidCount = itemData['bid_count'] ?? 0;

      bidPrices.add(bidAmount);
      bidUsers.add(userId);
      bidCount += 1;

      transaction.update(itemDoc, {
        'bid_prices': bidPrices,
        'bid_users': bidUsers,
        'bid_count': bidCount,
      });
    });

    ref.read(navigationServiceProvider).goBack();
    ref.read(navigationServiceProvider).goBack();
    showSnackBar(
        context: ref.read(navigationServiceProvider).navigatorKey.currentContext!, message: 'Bid placed successfully!', requiresMargin: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 24, top: 20),
            child: Text(
              'Enter Amount',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor),
              textAlign: TextAlign.left,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextFormField(
              controller: controller,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.secondary,
                  contentPadding: EdgeInsets.zero),
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
              keyboardType: TextInputType.number,
              readOnly: true,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              clipBehavior: Clip.hardEdge,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    childAspectRatio: 1.4),
                itemCount: 16,
                itemBuilder: (context, index) {
                  switch (index) {
                    case (0 || 1 || 2):
                      return InkWell(
                        onTap: () {
                          setState(() {
                            amount = amount * 10 + index + 1;
                            controller.text =
                                'Rs. ${NumberFormat.decimalPattern().format(amount)}';
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    case (4 || 5 || 6):
                      return InkWell(
                        onTap: () {
                          setState(() {
                            amount = amount * 10 + index;
                            controller.text =
                                'Rs. ${NumberFormat.decimalPattern().format(amount)}';
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '$index',
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    case (8 || 9 || 10):
                      return InkWell(
                        onTap: () {
                          setState(() {
                            amount = amount * 10 + index - 1;
                            controller.text =
                                'Rs. ${NumberFormat.decimalPattern().format(amount)}';
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${index - 1}',
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    case (12 || 13):
                      return InkWell(
                        onTap: () {
                          setState(() {
                            amount = amount * (index == 13 ? 100 : 10);
                            controller.text =
                                'Rs. ${NumberFormat.decimalPattern().format(amount)}';
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '0${index == 13 ? '0' : ''}',
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    case (14):
                      return InkWell(
                        onTap: () {
                          setState(() {
                            amount = (amount / 10).floor();
                            controller.text =
                                'Rs. ${NumberFormat.decimalPattern().format(amount)}';
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(
                            Icons.backspace_rounded,
                            size: 28,
                          ),
                        ),
                      );
                    case (3 || 15):
                      return InkWell(
                        onTap: () {
                          setState(() {
                            amount += ((widget.minIncrement == 0
                                        ? widget.minPrice * 0.02
                                        : widget.minIncrement) /
                                    (index == 3 ? 8 : 1))
                                .toInt();
                            controller.text =
                                'Rs. ${NumberFormat.decimalPattern().format(amount)}';
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(6),
                              bottomLeft: const Radius.circular(6),
                              topRight: index == 3
                                  ? const Radius.circular(24)
                                  : const Radius.circular(6),
                              bottomRight: index == 15
                                  ? const Radius.circular(24)
                                  : const Radius.circular(6),
                            ),
                          ),
                          child: Text(
                            '+${NumberFormat.compactSimpleCurrency(name: 'Rs. ', decimalDigits: 0).format(((widget.minIncrement == 0 ? widget.minPrice * 0.02 : widget.minIncrement) / (index == 3 ? 8 : 1)).ceil())}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                    case (7 || 11):
                      return InkWell(
                        onTap: () {
                          setState(() {
                            amount += ((widget.minIncrement == 0
                                        ? widget.minPrice * 0.02
                                        : widget.minIncrement) /
                                    (index == 7 ? 4 : 2))
                                .toInt();
                            controller.text =
                                'Rs. ${NumberFormat.decimalPattern().format(amount)}';
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            '+${NumberFormat.compactSimpleCurrency(name: 'Rs. ', decimalDigits: 0).format(((widget.minIncrement == 0 ? widget.minPrice * 0.02 : widget.minIncrement) / (index == 7 ? 4 : 2)).ceil())}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      );
                  }
                  return null;
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              height: 60,
              child: CustomButton(
                onPressed: () {
                  final requiredAmount = widget.minPrice + widget.minIncrement;
                  final bidAmount = amount;
                  if (bidAmount < requiredAmount) {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.all(25),
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: 200,
                              child: Column(
                                children: [
                                  const Icon(
                                    Iconsax.danger,
                                    size: 48,
                                    color: AppTheme.errorColor,
                                  ),
                                  const Text('Insufficient Amount!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppTheme.errorColor),),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text('Amount should be greater than or equal to'),
                                  Text('Rs. ${NumberFormat.decimalPattern().format(requiredAmount)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),),
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    );
                  } else {
                    _placeBid(bidAmount);
                  }
                },
                child: const Text(
                  'Confirm Bid',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
