import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget web;

  const Responsive({
    Key? key,
    required this.mobile,
    required this.tablet,
    required this.web,
  }) : super(key: key);

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600 && !kIsWeb;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 && !kIsWeb;

  static bool isWebAndTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600;

  static bool isWeb(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 && kIsWeb;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) =>
            constraints.maxWidth >= 600 ? web : mobile,
      );
}
