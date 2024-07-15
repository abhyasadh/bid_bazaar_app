import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class NoInternetWidget extends StatelessWidget {
  final double bottomPadding;
  const NoInternetWidget({super.key, this.bottomPadding=0});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SvgPicture.asset(
            'assets/images/svg/no_internet.svg',
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.tertiary,
              BlendMode.srcIn,
            ),
            width: MediaQuery.of(context).size.width / 1.5,
          ),
        ),
        const SizedBox(height: 12,),
        const Text('No Connection!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),),
        const SizedBox(height: 6,),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text('Please check your internet connection and try again...'),
        ),
        SizedBox(height: bottomPadding,)
      ],
    );
  }
}
