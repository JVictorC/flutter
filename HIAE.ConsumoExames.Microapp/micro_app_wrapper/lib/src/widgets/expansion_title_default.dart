import 'package:base_dependencies/dependencies.dart';
import 'package:flutter/material.dart';

class ExpansionTitleDefault extends StatefulWidget {
  final String title;
  final Widget body;
  const ExpansionTitleDefault({
    required this.title,
    required this.body,
    Key? key,
  }) : super(key: key);

  @override
  State<ExpansionTitleDefault> createState() => _ExpansionTitleDefaultState();
}

class _ExpansionTitleDefaultState extends State<ExpansionTitleDefault>
    with TickerProviderStateMixin {
  late final AnimationController _animateController;

  @override
  void initState() {
    _animateController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    super.initState();
  }

  @override
  void dispose() {
    _animateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: false,
      collapsedBackgroundColor: ZeraColors.neutralLight01,
      backgroundColor: ZeraColors.neutralLight01,
      trailing: RotationTransition(
        turns: Tween(begin: 0.0, end: 0.5).animate(_animateController),
        child: Icon(
          ZeraIcons.arrow_up_1,
          color: ZeraColors.primaryMedium,
        ),
      ),
      onExpansionChanged: (isOpen) {
        if (_animateController.status == AnimationStatus.completed) {
          _animateController.reverse();
        } else {
          _animateController.forward();
        }
      },
      title: ZeraText(
        widget.title,
        color: ZeraColors.primaryDark,
        type: ZeraTextType.BOLD_16_DARK_01,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.body,
            ],
          ),
        ),
      ],
    );
  }
}
