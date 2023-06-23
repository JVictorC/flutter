import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

import '../constants/assets_constants.dart';
import '../constants/parameters_constants.dart';
import '../constants/strings.dart';
import '../extensions/translate_extension.dart';

class TextFieldList<T extends Object> extends StatefulWidget {
  final List<T> list;
  final AutocompleteOptionsBuilder<T> optionsBuilder;
  final AutocompleteOptionToString<T> displayStringForOption;
  final AutocompleteOnSelected<T>? onSelected;
  final AutocompleteOptionsViewBuilder<T>? optionsViewBuilder;
  final ValueChanged<String>? onChange;
  final ValueChanged<String>? onSubmitted;
  final TextEditingController controller;
  final Function actionVoice;
  final Function clearField;

  const TextFieldList({
    required this.list,
    required this.optionsBuilder,
    required this.displayStringForOption,
    required this.onSelected,
    required this.optionsViewBuilder,
    required this.onChange,
    required this.onSubmitted,
    required this.controller,
    required this.actionVoice,
    required this.clearField,
    Key? key,
  }) : super(key: key);

  @override
  State<TextFieldList<T>> createState() => _TextFieldListState<T>();
}

class _TextFieldListState<T extends Object> extends State<TextFieldList<T>> {
  @override
  Widget build(BuildContext context) => Autocomplete<T>(
        optionsBuilder: widget.optionsBuilder,
        displayStringForOption: widget.displayStringForOption,
        fieldViewBuilder: (
          BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted,
        ) {
          if (widget.controller.text.isNotEmpty) {
            fieldTextEditingController.text = widget.controller.text;
          }

          return TextField(
            onSubmitted: widget.onSubmitted,
            controller: fieldTextEditingController,
            focusNode: fieldFocusNode,
            style: const TextStyle(fontWeight: FontWeight.bold),
            onChanged: widget.onChange,
            textAlign: TextAlign.left,
            decoration: InputDecoration(
              prefixIcon: Icon(
                ZeraIcons.search,
                color: ZeraColors.neutralDark02,
                size: 19.0,
              ),
              suffixIcon: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  /*MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () async {
                        widget.controller.clear();
                        fieldTextEditingController.clear();

                        await widget.clearField();
                      },
                      child: const Icon(
                        Icons.clear,
                        size: 17,
                      ),
                    ),
                  ),*/
                  // const VerticalDivider(
                  //   width: 15,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () async => await widget.actionVoice(),
                        child: Image.asset(
                          MIC_IMG,
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                          package: MICRO_APP_PACKAGE_NAME,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              contentPadding: const EdgeInsets.all(0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(48.0),
                borderSide: BorderSide(
                  width: 1,
                  color: ZeraColors.neutralLight02,
                ),
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(48.0),
                borderSide: BorderSide(
                  width: 1,
                  color: ZeraColors.neutralLight02,
                ),
              ),
              // filled: true,
              hintStyle: TextStyle(
                color: ZeraColors.neutralDark02,
                fontSize: 16.0,
                fontWeight: FontWeight.w400,
                fontFamily: fontFamilyName,
              ),
              hintText: SEARCH_EXAM2.translate(),
              fillColor: ZeraColors.neutralLight,
            ),
          );
        },
        onSelected: widget.onSelected,
        optionsViewBuilder: widget.optionsViewBuilder,
      );
}
