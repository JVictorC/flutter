import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

class ArrowScrollButton extends StatefulWidget {
  final ScrollController scrollController;
  const ArrowScrollButton({
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  State<ArrowScrollButton> createState() => _ArrowScrollButtonState();
}

class _ArrowScrollButtonState extends State<ArrowScrollButton> {
  bool hoverArrowRight = false;
  bool hoverArrowLeft = false;
  late final ValueNotifier<bool> _leftArrowVisible;
  late final ValueNotifier<bool> _rightArrowVisible;
  bool visibleScroll = true;

  @override
  void initState() {
    super.initState();

    _leftArrowVisible = ValueNotifier<bool>(false);
    _rightArrowVisible = ValueNotifier<bool>(true);
    widget.scrollController.addListener(_scrollListener);

    // ignore: prefer_null_aware_operators, unnecessary_null_comparison
    var execute = WidgetsBinding != null ? WidgetsBinding.instance : null;

    execute!.addPostFrameCallback(
      (_) {
        setState(() {
          visibleScroll = widget.scrollController.position.maxScrollExtent > 0;
        });
      },
    );
  }

  _scrollListener() {
    _leftArrowVisible.value = ((widget.scrollController.offset >
                widget.scrollController.position.minScrollExtent &&
            !widget.scrollController.position.outOfRange) ||
        (widget.scrollController.offset >=
                widget.scrollController.position.maxScrollExtent &&
            !widget.scrollController.position.outOfRange));

    _rightArrowVisible.value = ((widget.scrollController.offset <
                widget.scrollController.position.maxScrollExtent &&
            !widget.scrollController.position.outOfRange) ||
        (widget.scrollController.offset <=
                widget.scrollController.position.minScrollExtent &&
            !widget.scrollController.position.outOfRange));
  }

  Widget _leftArrow() => StatefulBuilder(
        builder: (context, reloadState) => GestureDetector(
          onLongPressDown: (_) {
            widget.scrollController.animateTo(
              widget.scrollController.position.minScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          },
          onTap: () {
            var scrollPosition = widget.scrollController.position;
            if (scrollPosition.viewportDimension >
                scrollPosition.minScrollExtent) {
              widget.scrollController.animateTo(
                widget.scrollController.offset - 50,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
              );
            }
          },
          child: MouseRegion(
            onEnter: (details) {
              if (!hoverArrowLeft && _leftArrowVisible.value) {
                reloadState(() {
                  hoverArrowLeft = true;
                });
              }
            },
            onExit: (details) {
              if (hoverArrowLeft) {
                reloadState(() {
                  hoverArrowLeft = false;
                });
              }
            },
            cursor: SystemMouseCursors.click,
            child: Icon(
              Icons.arrow_back,
              color: hoverArrowLeft
                  ? ZeraColors.primaryDark
                  : _leftArrowVisible.value
                      ? ZeraColors.neutralDark02
                      : ZeraColors.neutralLight04,
            ),
          ),
        ),
      );

  Widget _rightArrow() => StatefulBuilder(
        builder: (context, reloadState) => GestureDetector(
          child: MouseRegion(
            onEnter: (details) {
              if (!hoverArrowRight && _rightArrowVisible.value) {
                reloadState(() {
                  hoverArrowRight = true;
                });
              }
            },
            onExit: (details) {
              if (hoverArrowRight) {
                reloadState(() {
                  hoverArrowRight = false;
                });
              }
            },
            cursor: SystemMouseCursors.click,
            child: Icon(
              Icons.arrow_forward,
              color: hoverArrowRight
                  ? ZeraColors.primaryDark
                  : _rightArrowVisible.value
                      ? ZeraColors.neutralDark02
                      : ZeraColors.neutralLight04,
            ),
          ),
          onLongPressDown: (_) {
            widget.scrollController.animateTo(
              widget.scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          },
          onTap: () {
            widget.scrollController.animateTo(
              widget.scrollController.offset + 50,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
            );
          },
        ),
      );

  @override
  Widget build(BuildContext context) => Visibility(
        visible: visibleScroll,
        child: Container(
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: _leftArrowVisible,
                builder: (BuildContext context, bool value, _) => IgnorePointer(
                  ignoring: !value,
                  child: _leftArrow(),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              ValueListenableBuilder<bool>(
                valueListenable: _rightArrowVisible,
                builder: (BuildContext context, bool value, _) => IgnorePointer(
                  ignoring: !value,
                  child: _rightArrow(),
                ),
              ),
            ],
          ),
        ),
      );
}
