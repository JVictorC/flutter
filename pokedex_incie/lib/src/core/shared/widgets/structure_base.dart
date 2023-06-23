import 'package:flutter/material.dart';

class StructureBase extends StatelessWidget {
  const StructureBase({
    super.key,
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
  });

  final Widget child;
  final Widget? bottomNavigationBar;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        bottom: true,
        child: Scaffold(
          bottomNavigationBar: bottomNavigationBar,
          appBar: appBar,
          body: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
