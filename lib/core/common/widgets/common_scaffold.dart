import 'package:bid_bazaar/config/navigation/navigation_service.dart';
import 'package:bid_bazaar/core/common/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class CustomScaffold extends ConsumerWidget {
  final String title;
  final bool logo;
  final void Function()? backFunction;
  final bool backButton;
  final String? subtitle;
  final InkWell? subtitleLink;
  final List<Widget> textFields;
  final Widget? afterTextFields;
  final CustomButton? button;
  final Row? buttonRow;
  final List<Widget>? afterButton;

  const CustomScaffold({
    super.key,
    required this.title,
    this.logo = false,
    this.backFunction,
    this.backButton = false,
    this.subtitle,
    this.subtitleLink,
    required this.textFields,
    this.afterTextFields,
    this.button,
    this.buttonRow,
    this.afterButton,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        appBar: backButton
            ? AppBar(
                leading: IconButton(
                  onPressed: backFunction ??
                      () {
                        ref.read(navigationServiceProvider).goBack();
                      },
                  icon: SvgPicture.asset(
                    'assets/images/svg/arrow-left-1.svg',
                    colorFilter: const ColorFilter.mode(
                        Color(0xff787878), BlendMode.srcIn),
                    width: 16,
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    fixedSize: WidgetStateProperty.all(const Size(50, 50)),
                  ),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                leadingWidth: 80,
                toolbarHeight: 100,
              )
            : logo
                ? AppBar(
                    toolbarHeight: 100,
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo/logo_trans.png',
                          width: 68,
                          height: 68,
                        ),
                        const SizedBox(width: 10),
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 32,
                              fontFamily: 'Blinker',
                            ),
                            children: [
                              TextSpan(
                                text: 'Bid',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              TextSpan(
                                text: 'Bazaar',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    toolbarHeight: 100,
                  ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                SizedBox(
                  height: 114,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (subtitle != null || subtitleLink != null) ...[
                        const SizedBox(height: 4),
                        if (subtitle != null && subtitleLink == null)
                          Text(
                            subtitle!,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        if (subtitleLink != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${subtitle!}  ',
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitleLink!,
                            ],
                          ),
                      ],
                    ],
                  ),
                ),
                ...textFields,
                if (afterTextFields != null) afterTextFields!,
                const SizedBox(height: 14),
                button ?? buttonRow!,
                if (afterButton != null) ...afterButton!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
