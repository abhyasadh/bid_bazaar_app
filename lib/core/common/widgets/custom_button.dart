import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomButton extends ConsumerWidget {
  const CustomButton({super.key, required this.onPressed, required this.child});

  final Function() onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 50,
      child: FilledButton(
        onPressed: onPressed,
        child: Container(
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0x66ff6c44),
                  spreadRadius: 8,
                  blurRadius: 14,
                ),
              ],
            ),
            child: child),
      ),
    );
  }
}

class ButtonCircularProgressIndicator extends StatelessWidget {
  const ButtonCircularProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 3,
      ),
    );
  }
}

