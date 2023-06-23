import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WidgetTestable {
  WidgetTestable(Widget page) {
    basePage = page;
  }

  late Widget basePage;
  late Map<String, Widget Function(BuildContext)> routesMock = {};

  factory WidgetTestable.of(Widget page) => WidgetTestable(page);

  WidgetTestable makeMockRoutes({
    Map<String, Widget Function(BuildContext)>? r,
  }) {
    routesMock = r ?? routesMock;
    return this;
  }

  Widget build() => TestWidget(
        routesMock: routesMock,
        child: basePage,
      );
}

class TestWidget extends StatelessWidget {
  final Widget child;
  final Map<String, Widget Function(BuildContext)> routesMock;
  const TestWidget({
    super.key,
    required this.child,
    required this.routesMock,
  });

  @override
  Widget build(BuildContext context) => MaterialApp(
        routes: routesMock,
        home: Scaffold(
          body: child,
        ),
      );
}
