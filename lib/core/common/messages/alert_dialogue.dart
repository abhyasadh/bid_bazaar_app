import 'package:bid_bazaar/config/navigation/navigation_service.dart';
import 'package:bid_bazaar/config/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

showAlertDialogue({
  required String message,
  required BuildContext context,
  required WidgetRef ref,
  required void Function() onConfirm,
  void Function()? onCancel,
  bool barrierDismissible = true,
}) {
  return showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) {
      return AlertDialog(
        titlePadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        actionsAlignment: MainAxisAlignment.start,
        clipBehavior: Clip.hardEdge,
        shadowColor: Theme.of(context).colorScheme.tertiary,
        surfaceTintColor: Colors.grey,
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontFamily: 'Blinker',
                    fontSize: 18
                  ),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: TextButton(
                      onPressed: onCancel ??
                          () {
                            ref.read(navigationServiceProvider).goBack();
                          },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey.withOpacity(0.3),
                        shape: const RoundedRectangleBorder(),
                        minimumSize: const Size(0, 50),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontFamily: 'Blinker',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: TextButton(
                      onPressed: onConfirm,
                      style: TextButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.5),
                        shape: const RoundedRectangleBorder(),
                        minimumSize: const Size(0, 50),
                      ),
                      child: const Text(
                        'Yes',
                        style: TextStyle(
                          fontFamily: 'Blinker',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
