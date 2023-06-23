import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AnimatedFabWidget extends StatefulWidget {
  final GestureTapCallback? onPressed;
  final double? elevation;
  final double? width;
  final double? height;
  final Duration? duration;
  final Widget? icon;
  final Widget? label;
  final Curve? curve;
  final ScrollController? scrollController;
  final double? limitIndicator;
  final Color? backgroundColor;
  final bool? animateIcon;
  final bool? inverted;
  final bool showLabel;
  final double? radius;

  const AnimatedFabWidget({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.scrollController,
    this.elevation = 5.0,
    this.width = 240.0,
    this.height = 64.0,
    this.duration = const Duration(milliseconds: 230),
    this.curve,
    this.limitIndicator = 10.0,
    this.backgroundColor,
    this.animateIcon = false,
    this.inverted = false,
    this.showLabel = true,
    this.radius,
  }) : super(key: key);

  @override
  _AnimatedFabWidgetState createState() => _AnimatedFabWidgetState();
}

class _AnimatedFabWidgetState extends State<AnimatedFabWidget> {
  double _endTween = 100;

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    _handleScroll();
  }

  @override
  void dispose() {
    widget.scrollController!.removeListener(() {});
    super.dispose();
  }

  void _handleScroll() {
    ScrollController _scrollController = widget.scrollController!;
    _scrollController.addListener(() {
      // if (_scrollController.position.pixels > widget.limitIndicator! && _scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          _endTween = widget.inverted! ? 100 : 0;
        });
        // } else if (_scrollController.position.pixels <= widget.limitIndicator! && _scrollController.position.userScrollDirection == ScrollDirection.forward) {
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          _endTween = widget.inverted! ? 0 : 100;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) => Card(
        elevation: widget.elevation,
        semanticContainer: true,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.height! / 2)),
        child: TweenAnimationBuilder(
          tween: Tween<double>(begin: 0, end: _endTween),
          duration: widget.duration!,
          builder: (BuildContext _, double size, Widget? child) {
            double _widthPercent = (widget.width! - widget.height!).abs() / 100;
            bool _isFull = (_endTween == 100 && widget.showLabel);
            double _radius = widget.radius ?? (widget.height! / 2);
            return InkWell(
              onTap: widget.onPressed,
              borderRadius: BorderRadius.circular(_radius),
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(_radius)),
                  color:
                      widget.backgroundColor ?? Theme.of(context).primaryColor,
                ),
                height: widget.height,
                width: widget.showLabel
                    ? widget.height! + _widthPercent * size
                    : widget.height!,
                // width: 64,
                child: Row(
                  mainAxisAlignment: _isFull
                      ? MainAxisAlignment.spaceEvenly
                      : MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      // padding: EdgeInsets.zero,
                      child: Transform.rotate(
                        angle: widget.animateIcon!
                            ? (3.6 * math.pi / 180) * size
                            : 0,
                        child: widget.icon,
                      ),
                    ),
                    ...(_isFull
                        ? [
                            Expanded(
                              child: AnimatedOpacity(
                                opacity: size > 90 ? 1 : 0,
                                duration: const Duration(milliseconds: 100),
                                child: widget.label!,
                              ),
                            ),
                          ]
                        : []),
                  ],
                ),
              ),
            );
          },
        ),
      );
}
