import 'package:bid_bazaar/config/themes/app_theme.dart';
import 'package:flutter/material.dart';

showSnackBar({
  required BuildContext context,
  required String message,
  bool error = false,
  bool requiresMargin = false,
  SnackBarAction? action,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: TextStyle(
            fontFamily: 'Blinker',
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
            fontSize: 18),
      ),
      backgroundColor: error ? AppTheme.errorColor : AppTheme.successColor,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      margin: requiresMargin ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8) : const EdgeInsets.all(0),
      shape: requiresMargin ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)) : null,
      action: action,
    ),
  );
}
