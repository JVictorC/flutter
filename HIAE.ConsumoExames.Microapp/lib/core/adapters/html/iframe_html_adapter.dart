import 'package:flutter/material.dart';

import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import 'html_interface.dart';

class IFRAMEAdapter implements IHTMLAdapter {
  @override
  Widget html({
    required String html,
    String? url,
  }) =>
      HtmlWidget(
        html,
        // ignore: deprecated_member_use
        webView: true,
        baseUrl: url != null ? Uri.tryParse(url) : null,
        // factoryBuilder: factoryBuilder,
      );
}
