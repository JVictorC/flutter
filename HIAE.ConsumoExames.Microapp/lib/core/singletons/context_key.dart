import 'package:flutter/material.dart';

class ContextUtil {
  static final ContextUtil _instance = ContextUtil._internal();
  // BuildContext? context;

  final GlobalKey<ScaffoldMessengerState> globalKey =
      GlobalKey<ScaffoldMessengerState>();

  factory ContextUtil() => _instance;

  ContextUtil._internal();
  BuildContext? get context => globalKey.currentContext;
}
