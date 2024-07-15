import 'package:bid_bazaar/config/themes/app_theme.dart';
import 'package:bid_bazaar/features/add/add_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTable extends ConsumerStatefulWidget {
  final String category;
  final List<Map<String, dynamic>> fields;
  final List<TextEditingController> controllers;
  final List<FocusNode> nodes;
  final List<GlobalKey<FormState>> keys;

  const CustomTable({
    super.key,
    required this.category,
    required this.fields,
    required this.controllers,
    required this.nodes,
    required this.keys,
  });

  @override
  ConsumerState createState() => _CustomTableState();
}

class _CustomTableState extends ConsumerState<CustomTable> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in widget.controllers) {
      controller.dispose();
    }
    for (var node in widget.nodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(widget.fields.length, (index) {
              return Column(
                children: [
                  Container(
                    height: 56,
                    width: 118,
                    alignment: Alignment.centerLeft,
                    color: Theme.of(context).colorScheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('${widget.fields[index]['label']}${widget.fields[index]['required'] ? '*' : ''}'),
                  ),
                  index < widget.fields.length - 1
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
              children: List.generate(
                widget.fields.length,
                (index) {
                  return Column(
                    children: [
                      widget.fields[index]['type'] == 'text' ||
                              widget.fields[index]['type'] == 'number'
                          ? Form(
                              key: widget.keys[index],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: TextFormField(
                                controller: widget.controllers[index],
                                focusNode: widget.nodes[index],
                                keyboardType:
                                    widget.fields[index]['type'] == 'text'
                                        ? TextInputType.text
                                        : TextInputType.number,
                                textCapitalization: TextCapitalization.words,
                                decoration: InputDecoration(
                                  hintText: widget.fields[index]['hint'],
                                  errorStyle: const TextStyle(
                                      height: 0, color: Colors.transparent),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppTheme.errorColor,
                                      width: 2.0,
                                    ),
                                    borderRadius: index == 0
                                        ? const BorderRadius.only(
                                            topRight: Radius.circular(10.0))
                                        : index == widget.fields.length - 1
                                            ? const BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10.0))
                                            : BorderRadius.zero,
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                      color: AppTheme.errorColor,
                                      width: 2.0,
                                    ),
                                    borderRadius: index == 0
                                        ? const BorderRadius.only(
                                            topRight: Radius.circular(10.0))
                                        : index == widget.fields.length - 1
                                            ? const BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(10.0))
                                            : BorderRadius.zero,
                                  ),
                                ),
                                cursorColor: AppTheme.primaryColor,
                                cursorErrorColor: AppTheme.primaryColor,
                                onTapOutside: (e) {
                                  widget.nodes[index].unfocus();
                                },
                                validator: (value) {
                                  if (widget.fields[index]['required'] && (value == null || value.trim() == '')) {
                                    return '';
                                  }
                                  return null;
                                },
                                onChanged: (value){
                                  ref.read(addViewModelProvider.notifier).updateDetails(widget.fields[index]['label'], value);
                                },
                              ),
                            )
                          : Form(
                              key: widget.keys[index],
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: FormField(
                                validator: (value) {
                                  if (widget.fields[index]['required'] && value == null) {
                                    return '';
                                  }
                                  return null;
                                },
                                builder: (FormFieldState<String> state) {
                                  return DropdownMenu<String>(
                                    width: state.hasError
                                        ? MediaQuery.of(context).size.width -
                                            155
                                        : MediaQuery.of(context).size.width -
                                            153,
                                    inputDecorationTheme: InputDecorationTheme(
                                      filled: true,
                                      fillColor:
                                          Theme.of(context).colorScheme.primary,
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: !state.hasError
                                            ? BorderSide.none
                                            : const BorderSide(
                                                color: AppTheme.errorColor,
                                                width: 2),
                                        borderRadius: index == 0
                                            ? const BorderRadius.only(
                                                topRight: Radius.circular(10.0))
                                            : index == widget.fields.length - 1
                                                ? const BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10.0))
                                                : BorderRadius.zero,
                                      ),
                                    ),
                                    hintText: widget.fields[index]['hint'],
                                    initialSelection: widget.controllers[index].text,
                                    dropdownMenuEntries: widget.fields[index]
                                            ['options']
                                        .map<DropdownMenuEntry<String>>(
                                      (String value) {
                                        return DropdownMenuEntry<String>(
                                          value: value,
                                          label: value,
                                        );
                                      },
                                    ).toList(),
                                    onSelected: (value) {
                                      state.didChange(value);
                                      ref.read(addViewModelProvider.notifier).updateDetails(widget.fields[index]['label'], value!);
                                    },
                                  );
                                },
                              ),
                            ),
                      index < widget.fields.length - 1
                          ? const SizedBox(
                              height: 2,
                            )
                          : const SizedBox.shrink()
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
