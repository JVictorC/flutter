import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:universal_html/html.dart' as html;

// import 'dart:html' as html;

void registerWebViewWebImplementation({
  required String key,
  required String url,
  required String width,
  required String height,
}) {
// ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
    key,
    (int viewId) => html.IFrameElement()
      ..width = width
      ..height = height
      ..src = url
      ..style.border = 'none',
  );
}

Widget webViewWebImplementation(String key) => HtmlElementView(viewType: key);
html.WindowBase newWebTab(String url) => html.window.open(url, '_blank');
