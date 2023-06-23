import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';
import 'package:textfield_tags/textfield_tags.dart';

void showPopupEmail({
  required BuildContext context,
  title,
}) {
  List<String> listTags = [];
  showDialog(
    context: context, // ContextUtil().context!
    useSafeArea: true,

    builder: (_) => StatefulBuilder(
      builder: (context, StateSetter setStateModal) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        backgroundColor: Colors.white,
        titlePadding: EdgeInsets.zero,
        title: Container(
          constraints: const BoxConstraints(
            maxWidth: 512,
          ),
          width: double.infinity,
          padding:
              const EdgeInsets.only(left: 24, right: 24, top: 40, bottom: 16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: ZeraColors.neutralLight02,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ZeraText(
                title,
                type: ZeraTextType.MEDIUM_20_NEUTRAL_DARK,
                theme: const ZeraTextTheme(
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                  fontStyle: FontStyle.normal,
                  fontFamily: 'Montserrat',
                ),
              ),
              InkWell(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(ZeraIcons.close),
              ),
            ],
          ),
        ),
        content: Container(
          constraints: const BoxConstraints(
            maxWidth: 512,
          ),
          width: double.infinity,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: kComponentSpacerXS),
                child: ZeraText(
                  'Destinatários',
                  theme: const ZeraTextTheme(
                    fontSize: kFontsizeXS,
                  ),
                ),
              ),
              TextFieldTags(
                initialTags: const [],
                textSeparators: const [' ', ','],
                letterCase: LetterCase.normal,
                validator: (String tag) {
                  if (!RegExp(
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
                  ).hasMatch(tag)) {
                    return 'Email invalido';
                  }
                  return null;
                },
                inputfieldBuilder:
                    (context, tec, fn, error, onChanged, onSubmitted) {
                  const border = InputBorder.none;
                  return ((context, sc, tags, onTagDelete) {
                    listTags = tags;
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: ZeraColors.neutralDark03,
                          width: 1,
                        ),
                      ),
                      clipBehavior: Clip.none,
                      // padding: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.only(
                        // top: 28.0,
                        // top: 8.0,
                        left: 8.0,
                        right: 8.0,
                        bottom: 8,
                      ),
                      width: double.infinity,
                      child: Wrap(
                        children: [
                          ...tags
                              .map(
                                (String tag) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0)),
                                    border: Border.all(
                                        color: ZeraColors.neutralLight03),
                                  ),
                                  margin: const EdgeInsets.only(
                                      right: 8.0, top: 8.0),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 4.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: InkWell(
                                          child: ZeraText(
                                            tag,
                                            type: ZeraTextType
                                                .BOLD_12_NEUTRAL_DARK_01,
                                          ),
                                          // onTap: () {},
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      InkWell(
                                        child: Icon(
                                          ZeraIcons.close,
                                          size: 10.0,
                                          color: ZeraColors.neutralDark02,
                                        ),
                                        onTap: () {
                                          onTagDelete(tag);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          SizedBox(
                            height: 40,
                            child: OverflowBox(
                              alignment: Alignment.topLeft,
                              maxHeight: 80,
                              minHeight: 40,
                              child: Expanded(
                                child: Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 300),
                                  alignment: Alignment.topLeft,
                                  child: TextField(
                                    controller: tec,
                                    focusNode: fn,
                                    maxLength: null,
                                    maxLines: 1,
                                    scrollPadding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    style: const TextStyle(
                                      height: 1,
                                      fontSize: 18,
                                    ),
                                    decoration: InputDecoration(
                                      border: border,
                                      alignLabelWithHint: true,
                                      focusedBorder: border,
                                      enabledBorder: border,
                                      errorBorder: border,
                                      focusedErrorBorder: border,
                                      hintText: 'Email...',
                                      errorText: error,
                                      errorMaxLines: 1,
                                      hintStyle: const TextStyle(
                                        height: 1,
                                        fontSize: 18,
                                      ),
                                      // labelStyle: ,
                                      errorStyle: const TextStyle(
                                        height: 1.5,
                                      ),
                                    ),
                                    onChanged: onChanged,
                                    onSubmitted: onSubmitted,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
        actionsPadding: EdgeInsets.zero,
        actions: [
          FittedBox(
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 30, right: 24, left: 24, top: 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ZeraButton(
                    text: 'Cancelar',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ZeraButtonStyle.PRIMARY_CLEAN_TEXT_DARK,
                    theme: ZeraButtonTheme(
                      borderColor: ZeraColors.primaryDark,
                      borderWidth: 2,
                      fontSize: 16,
                      minWidth: 160,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ZeraButton(
                    text: 'Enviar',
                    onPressed: () {
                      Navigator.of(context).pop(listTags);
                    },
                    style: ZeraButtonStyle.PRIMARY_DARK,
                    theme: ZeraButtonTheme(
                      fontSize: 16,
                      minWidth: 160,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
