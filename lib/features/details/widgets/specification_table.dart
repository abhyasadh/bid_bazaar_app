import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SpecificationTable extends ConsumerStatefulWidget {
  final Map<String, dynamic>? fields;
  final String condition;

  const SpecificationTable({
    super.key,
    this.fields,
    required this.condition,
  });

  @override
  ConsumerState createState() => _SpecificationTableState();
}

class _SpecificationTableState extends ConsumerState<SpecificationTable> {
  @override
  Widget build(BuildContext context) {
    var fields = widget.fields;

    if (widget.fields!=null) {
      fields!['Condition'] = widget.condition;
    } else{
      fields = {'Condition': widget.condition};
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(fields.length, (index) {
              return Column(
                children: [
                  Container(
                    height: 56,
                    width: 118,
                    alignment: Alignment.centerLeft,
                    color: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(fields!.keys.toList()[index], style: const TextStyle(fontWeight: FontWeight.w600),),
                  ),
                  index < fields.length - 1
                      ? const SizedBox(
                    height: 2,
                  )
                      : const SizedBox.shrink()
                ],
              );
            }),
          ),
          const SizedBox(
            width: 2,
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(fields.length, (index) {
                return Column(
                  children: [
                    Container(
                      height: 56,
                      alignment: Alignment.centerLeft,
                      color: Theme.of(context).colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(fields!.values.toList()[index].toString()),
                    ),
                    index < fields.length - 1
                        ? const SizedBox(
                      height: 2,
                    )
                        : const SizedBox.shrink()
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
