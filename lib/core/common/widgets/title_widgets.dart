import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlackSemiBoldTitle extends ConsumerWidget{
  final String title;
  const BlackSemiBoldTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
    );
  }
}

class PrimarySemiBoldTitle extends ConsumerWidget {
  final String title;
  const PrimarySemiBoldTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Text(
        title,
        textAlign: TextAlign.left,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24,
          color: Theme.of(context).primaryColor
        ),
      ),
    );
  }
}