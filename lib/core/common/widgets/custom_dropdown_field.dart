import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../config/themes/app_theme.dart';

class CustomDropdownField extends ConsumerWidget {
  final String? label;
  final IconData? icon;
  final String? initiallySelected;
  final String? hintText;
  final List<String> items;
  final double width;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownField({
    super.key,
    this.label,
    this.icon,
    this.hintText,
    this.initiallySelected,
    required this.items,
    required this.width,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label != null
            ? Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 8),
                child: Text(
                  label!,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              )
            : const SizedBox(),
        FormField(
          initialValue: initiallySelected,
          validator: validator,
          builder: (FormFieldState<String> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownMenu<String>(
                  width: width,
                  leadingIcon: icon != null
                      ? SizedBox(
                          width: 50,
                          child: Icon(
                            icon,
                            size: 20,
                          ),
                        )
                      : null,
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primary,
                    enabledBorder: OutlineInputBorder(
                      borderSide: !state.hasError ? BorderSide.none : const BorderSide(color: AppTheme.errorColor, width: 2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  hintText: hintText,
                  initialSelection: initiallySelected,
                  dropdownMenuEntries:
                      items.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                      value: value,
                      label: value,
                    );
                  }).toList(),
                  onSelected: (value) {
                    state.didChange(value);
                    if (onChanged != null) {
                      onChanged!(value);
                    }
                  },
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 5),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(
                        color: AppTheme.errorColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
