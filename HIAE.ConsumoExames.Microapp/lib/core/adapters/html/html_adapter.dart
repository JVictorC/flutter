import 'package:flutter/material.dart';

import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'html_interface.dart';

class HTMLAdapter implements IHTMLAdapter {
  @override
  Widget html({
    required String html,
    String? url,
  }) =>
      HtmlWidget(
        html,
        baseUrl: url != null ? Uri.tryParse(url) : null,
      );
}
