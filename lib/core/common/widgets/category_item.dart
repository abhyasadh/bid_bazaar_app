import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CategoryItem extends ConsumerWidget {
  final bool scaleDown;
  final Color color;
  final String image;
  final String name;
  final bool isActive;

  const CategoryItem({
    super.key,
    this.scaleDown = false,
    required this.color,
    required this.image,
    required this.name,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Transform.scale(
          scale: scaleDown ? 0.8 : 1,
          child: Container(
            width: 54,
            height: 54,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: isActive
                  ? Border.all(
                      color: color,
                      width: 3,
                    )
                  : Border.all(
                      color: color.withOpacity(0),
                      width: 3,
                    ),
              borderRadius: BorderRadius.circular(12),
              color: color.withOpacity(0.3),
            ),
            child: Image.asset('assets/images/categories/$image.png'),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          name,
          style: const TextStyle(fontSize: 10),
        )
      ],
    );
  }
}
