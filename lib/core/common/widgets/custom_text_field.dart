import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';

class CustomTextField extends ConsumerStatefulWidget {
  const CustomTextField({
    super.key,
    this.label,
    this.hintText,
    this.icon,
    this.prefix,
    required this.controller,
    required this.node,
    required this.validator,
    this.keyBoardType,
    this.obscureText = false,
    this.focusOnLoad = false,
    this.textAlign = TextAlign.start,
    this.maxLength,
    this.onChanged,
    this.onSubmitted,
  });

  final String? label;
  final String? hintText;
  final IconData? icon;
  final Widget? prefix;
  final TextEditingController controller;
  final FocusNode node;
  final String? Function(String?) validator;
  final TextInputType? keyBoardType;
  final bool obscureText;
  final bool focusOnLoad;
  final TextAlign textAlign;
  final int? maxLength;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  @override
  ConsumerState<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends ConsumerState<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();

    _obscureText = widget.obscureText;

    if (widget.focusOnLoad) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.node.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.label != null
            ? Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 8),
                child: Text(
                  widget.label!,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              )
            : const SizedBox(),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: TextFormField(
            controller: widget.controller,
            style: const TextStyle(fontSize: 16),
            keyboardType: widget.keyBoardType ?? TextInputType.text,
            textCapitalization: widget.obscureText || widget.keyBoardType == TextInputType.emailAddress
                ? TextCapitalization.none
                : TextCapitalization.words,
            cursorColor: Theme.of(context).primaryColor,
            textAlign: widget.textAlign,
            textAlignVertical: TextAlignVertical.center,
            obscureText: _obscureText,
            obscuringCharacter: '●',
            validator: widget.validator,
            focusNode: widget.node,
            inputFormatters: widget.maxLength != null
                ? [LengthLimitingTextInputFormatter(1)]
                : [],
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: widget.icon != null
                  ? Icon(
                      widget.icon,
                      size: 20,
                    )
                  : widget.prefix,
              prefixIconConstraints: const BoxConstraints(
                minWidth: 50,
              ),
              suffixIcon:
                  widget.obscureText
                      ? IconButton(
                          icon: Icon(
                            _obscureText
                                ? Iconsax.eye4
                                : Iconsax.eye_slash5,
                            size: 20,
                          ),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        )
                      : null,
            ),
            onTapOutside: (e) {
              widget.node.unfocus();
            },
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
          ),
        )
      ],
    );
  }
}
