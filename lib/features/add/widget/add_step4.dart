import 'package:bid_bazaar/core/common/widgets/custom_button.dart';
import 'package:bid_bazaar/features/add/add_view_model.dart';
import 'package:bid_bazaar/features/add/widget/readonly_details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../config/navigation/navigation_service.dart';
import '../../../config/themes/app_theme.dart';

class AddStep4 extends ConsumerStatefulWidget {
  const AddStep4({super.key});

  @override
  ConsumerState createState() => _AddStep4State();
}

class _AddStep4State extends ConsumerState<AddStep4> {
  @override
  Widget build(BuildContext context) {
    final addState = ref.watch(addViewModelProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Text(
            'Preview of Your Auction',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 24, bottom: 8),
          child: Text(
            '(Tap to see more info)',
            style: TextStyle(fontSize: 12, color: Colors.grey.withOpacity(0.7)),
          ),
        ),
        InkWell(
          onTap: () {
            ref
                .read(navigationServiceProvider)
                .navigateTo(page: const ReadonlyDetailsView());
          },
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 22),
            child: Row(
              children: [
                Container(
                  height: 92,
                  width: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary, width: 3),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: addState .images.isNotEmpty ? Image.file(
                            addState.images[0],
                            fit: BoxFit.fill,
                          ): addState.imageUrls.isNotEmpty ? Image.network(addState.imageUrls[0], fit: BoxFit.fill,) : null,
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
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    padding: const EdgeInsets.only(
                        top: 12, bottom: 12, left: 14, right: 14),
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
                                addState.title!,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.primaryColor,
                                    height: 1),
                              ),
                            ),
                            SizedBox(
                              width: 196,
                              child: Text(
                                'Rs. ${NumberFormat.decimalPattern().format(addState.price)}',
                                style: const TextStyle(
                                  height: 1,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 1,
                            ),
                            Row(
                              children: [
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
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2, horizontal: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    'Ends In: ${addState.time! - 1}D 23H 59M',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              child: SvgPicture.asset(
                                'assets/images/svg/more.svg',
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context).colorScheme.tertiary,
                                    BlendMode.srcIn),
                                width: 22,
                              ),
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            SvgPicture.asset(
                                    'assets/images/svg/save-2.svg',
                                    colorFilter: ColorFilter.mode(
                                        Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        BlendMode.srcIn),
                                    width: 22,
                                  )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: CustomButton(
            onPressed: () {
              ref.read(addViewModelProvider.notifier).addAuction(ref);
            },
            child: addState.isLoading ?
            const ButtonCircularProgressIndicator() :
            const Text(
              'PUBLISH',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        )
      ],
    );
  }
}
