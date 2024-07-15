import 'package:bid_bazaar/config/themes/app_theme.dart';
import 'package:bid_bazaar/core/common/widgets/custom_appbars.dart';
import 'package:bid_bazaar/core/common/widgets/custom_button.dart';
import 'package:bid_bazaar/features/add/add_view_model.dart';
import 'package:bid_bazaar/features/bottom_navigation/nav_view_model.dart';
import 'package:bid_bazaar/features/details/widgets/specification_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../details/widgets/image_slider.dart';

class ReadonlyDetailsView extends ConsumerWidget {
  const ReadonlyDetailsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addState = ref.read(addViewModelProvider);
    return Scaffold(
      appBar: BranchPageAppBar(
        addState.title!,
        actionIcon: 'share',
        actionFunction: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width,
        height: 80,
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
          child: CustomButton(
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Place a Bid',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Icon(
                  Icons.gavel_rounded,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: (MediaQuery.of(context).size.width - 40) * 3 / 4,
              width: MediaQuery.of(context).size.width - 40,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.hardEdge,
              child: ImageSlider(
                images: [...addState.imageUrls, ...addState.images],
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
                        'Rs. ${NumberFormat.decimalPattern().format(addState.price)}',
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
                          child: const Row(
                            children: [
                              Icon(
                                Iconsax.eye,
                                size: 12,
                              ),
                              SizedBox(width: 4),
                              Text(
                                ' 0',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 10),
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
                          child: const Text(
                            'Bid Count: 0',
                            style: TextStyle(
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
                            'Ends In: ${addState.time! > 1 ? '${addState.time! - 1}D ' : ' '}23H 59M',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: SvgPicture.asset(
                    'assets/images/svg/save-2.svg',
                    colorFilter: ColorFilter.mode(
                        Theme.of(context).colorScheme.tertiary,
                        BlendMode.srcIn),
                    width: 30,
                  ),
                ),
              ],
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ref
                                  .read(navViewModelProvider)
                                  .userData!['profileImageUrl'] !=
                              null
                          ? CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(ref
                                  .read(navViewModelProvider)
                                  .userData!['profileImageUrl']))
                          : Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .inputDecorationTheme
                                      .fillColor,
                                  borderRadius: BorderRadius.circular(58)),
                              child: SvgPicture.asset(
                                'assets/images/svg/profile-circle.svg',
                              ),
                            ),
                      const SizedBox(
                        width: 14,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ref
                                    .read(navViewModelProvider)
                                    .userData!['firstName'] +
                                ' ' +
                                ref
                                    .read(navViewModelProvider)
                                    .userData!['lastName'],
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.primaryColor),
                          ),
                          Text(
                            ref.read(navViewModelProvider).userData!['email'],
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
                    addState.description!,
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
                      fields: addState.details,
                      condition: addState.condition!),
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
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
