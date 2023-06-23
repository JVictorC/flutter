import 'dart:math';

import 'package:flutter/material.dart';

import 'package:zera/zera.dart';

class DotsIndicatorWidget extends AnimatedWidget {
  final PageController controller;
  final int itemCount;
  final ValueChanged<int>? onDotTap;

  const DotsIndicatorWidget({
    required this.controller,
    required this.itemCount,
    this.onDotTap,
  }) : super(listenable: controller);

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(itemCount, _buildDot),
      );

  Widget _buildDot(int index) {
    final offset = _getOffset(index);
    final size = Size.lerp(
      const Size(36, 10),
      const Size.square(10),
      offset,
    )!;

    final color = Color.lerp(
      ZeraColors.primaryMedium,
      ZeraColors.neutralLight03,
      offset,
    );

    final shape = ShapeBorder.lerp(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      const CircleBorder(),
      offset,
    )!;
    return Center(
      child: Container(
        width: size.width,
        height: size.height,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
          onTap: onDotTap == null
              ? null
              : () {
                  controller.animateToPage(
                    index,
                    duration: const Duration(
                      milliseconds: kDotsIndicatorAnimationDuration,
                    ),
                    curve: Curves.ease,
                  );
                  onDotTap!(index);
                },
        ),
        decoration: ShapeDecoration(
          color: color,
          shape: shape,
        ),
      ),
    );
  }

  double _getOffset(int index) {
    try {
      return min(
        kOne,
        ((controller.page ?? controller.initialPage) - index).abs() as double,
      );
    } catch (_) {
      return min(
        kOne,
        (controller.initialPage.toDouble() - index).abs(),
      );
    }
  }
}
