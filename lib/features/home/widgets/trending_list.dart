import 'package:bid_bazaar/core/common/widgets/title_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrendingList extends ConsumerWidget {
  final String title;
  final List<Widget> items;

  const TrendingList({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        const BlackSemiBoldTitle('Trending'),
        SizedBox(
          height: 324,
          child: ListView(scrollDirection: Axis.horizontal, children: [
            const SizedBox(
              width: 10,
            ),
            ...items.map((item) {
              return Container(
                width: 300,
                padding: const EdgeInsets.all(10),
                child: item,
              );
            }),
            const SizedBox(
              width: 10,
            ),
          ]),
        ),
      ],
    );
  }
}