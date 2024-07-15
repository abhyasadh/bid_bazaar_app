import 'package:bid_bazaar/config/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationWidget extends ConsumerWidget {
  final bool read;
  const NotificationWidget({super.key, this.read=true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: const Border(
          bottom: BorderSide(color: Colors.grey, width: 1),
        ),
        color: read ? null : AppTheme.linkColor.withOpacity(0.15)
      ),
      child: Row(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.asset(
                'assets/images/png/img.png',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              )),
          const SizedBox(
            width: 24,
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Title',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              Text(
                'Notification Body',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
              Text(
                'Date',
                style: TextStyle(fontSize: 9, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
