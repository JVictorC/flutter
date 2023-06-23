import 'package:flutter/material.dart';

import 'package:base_dependencies/dependencies.dart';

/// Build the Scroll Thumb and label using the current configuration
typedef ScrollThumbBuilder = Widget Function(
  Color backgroundColor,
  Animation<double> thumbAnimation,
  Animation<double> labelAnimation,
  double width, {
  Text? labelText,
  BoxConstraints? labelConstraints,
});

/// Build a Text widget using the current scroll offset
typedef LabelTextBuilder = Text Function(double offsetY);

class DraggableScrollbar extends StatefulWidget {
  /// The view that will be scrolled with the scroll thumb
  final Widget child;

  /// A function that builds a thumb using the current configuration
  final ScrollThumbBuilder scrollThumbBuilder;

  /// The height of the scroll thumb
  // final double heightScrollThumb;

  /// The width of the scroll thumb
  final double widthScrollThumb;

  /// The background color of the label and thumb
  final Color backgroundColor;

  /// The amount of padding that should surround the thumb
  final EdgeInsetsGeometry? padding;

  /// Determines how quickly the scrollbar will animate in and out
  final Duration scrollbarAnimationDuration;

  /// How long should the thumb be visible before fading out
  final Duration scrollbarTimeToFade;

  /// Build a Text widget from the current offset in the BoxScrollView
  final LabelTextBuilder? labelTextBuilder;

  /// Determines box constraints for Container displaying label
  final BoxConstraints? labelConstraints;

  /// The ScrollController for the BoxScrollView
  final ScrollController controller;

  /// Determines scrollThumb displaying. If you draw own ScrollThumb and it is true you just don't need to use animation parameters in [scrollThumbBuilder]
  final bool alwaysVisibleScrollThumb;

  const DraggableScrollbar({
    Key? key,
    this.alwaysVisibleScrollThumb = false,
    required this.widthScrollThumb,
    required this.backgroundColor,
    required this.scrollThumbBuilder,
    required this.child,
    required this.controller,
    this.padding,
    this.scrollbarAnimationDuration = const Duration(milliseconds: 300),
    this.scrollbarTimeToFade = const Duration(milliseconds: 600),
    this.labelTextBuilder,
    this.labelConstraints,
  }) : super(key: key);

  @override
  _DraggableScrollbarState createState() => _DraggableScrollbarState();
}

class _DraggableScrollbarState extends State<DraggableScrollbar>
    with TickerProviderStateMixin {
  late double _barOffset;
  late double _viewOffset;
  late bool _isDragInProcess;

  late AnimationController _thumbAnimationController;
  late Animation<double> _thumbAnimation;
  late AnimationController _labelAnimationController;
  late Animation<double> _labelAnimation;
  // Timer? _fadeoutTimer;

  @override
  void initState() {
    super.initState();
    _barOffset = 0.0;
    _viewOffset = 0.0;
    _isDragInProcess = false;

    _thumbAnimationController = AnimationController(
      vsync: this,
      duration: widget.scrollbarAnimationDuration,
    );

    _thumbAnimation = CurvedAnimation(
      parent: _thumbAnimationController,
      curve: Curves.fastOutSlowIn,
    );

    _labelAnimationController = AnimationController(
      vsync: this,
      duration: widget.scrollbarAnimationDuration,
    );

    _labelAnimation = CurvedAnimation(
      parent: _labelAnimationController,
      curve: Curves.fastOutSlowIn,
    );

    //bug Dart
    final executeWidgetBiding =
        // ignore: prefer_null_aware_operators
        WidgetsBinding != null ? WidgetsBinding.instance : null;

    executeWidgetBiding!.addPostFrameCallback((_) {
      _scrollNotifier.value =
          widget.controller.hasClients && viewMaxScrollExtent != 0.0
              ? true
              : false;
    });
  }

  @override
  void dispose() {
    _thumbAnimationController.dispose();
    _labelAnimationController.dispose();
    super.dispose();
  }

  double get barMaxScrollExtent =>
      context.size!.width - widget.widthScrollThumb;

  double get barMinScrollExtent => 0.0;

  double get viewMaxScrollExtent => widget.controller.position.maxScrollExtent;

  double get viewMinScrollExtent => widget.controller.position.minScrollExtent;

  final _scrollNotifier = ValueNotifier<bool?>(null);

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) =>
            NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            changePosition(notification);
            return false;
          },
          child: Stack(
            children: <Widget>[
              RepaintBoundary(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 36.0),
                  child: widget.child,
                ),
              ),
              //  (widget.controller.offset)?
              AnimatedBuilder(
                animation: _scrollNotifier,
                builder: (BuildContext context, Widget? child) =>
                    _scrollNotifier.value != true
                        ? const SizedBox()
                        : RepaintBoundary(
                            child: GestureDetector(
                              onHorizontalDragStart: _onVerticalDragStart,
                              onHorizontalDragUpdate: _onHorizontalDragUpdate,
                              onHorizontalDragEnd: _onVerticalDragEnd,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      height: 10,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: ZeraColors.neutralLight04,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    margin: EdgeInsets.only(left: _barOffset),
                                    child: widget.scrollThumbBuilder(
                                      widget.backgroundColor,
                                      _thumbAnimation,
                                      _labelAnimation,
                                      widget.widthScrollThumb,
                                      labelConstraints: widget.labelConstraints,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
              ),
            ],
          ),
        ),
      );

  //scroll bar has received notification that it's view was scrolled
  //so it should also changes his position
  //but only if it isn't dragged
  void changePosition(ScrollNotification notification) {
    if (_isDragInProcess) {
      return;
    }
    if (notification is ScrollUpdateNotification) {
      _barOffset += getBarDelta(
        notification.scrollDelta!,
        barMaxScrollExtent,
        viewMaxScrollExtent,
      );
      if (_barOffset < barMinScrollExtent) {
        _barOffset = barMinScrollExtent;
      }
      if (_barOffset > barMaxScrollExtent) {
        _barOffset = barMaxScrollExtent;
      }

      _viewOffset += notification.scrollDelta!;
      if (_viewOffset < widget.controller.position.minScrollExtent) {
        _viewOffset = widget.controller.position.minScrollExtent;
      }
      if (_viewOffset > viewMaxScrollExtent) {
        _viewOffset = viewMaxScrollExtent;
      }
    }

    if (notification is ScrollUpdateNotification ||
        notification is OverscrollNotification) {
      if (_thumbAnimationController.status != AnimationStatus.forward) {
        _thumbAnimationController.forward();
      }
    }
    setState(() {});
  }

  double getBarDelta(
    double scrollViewDelta,
    double barMaxScrollExtent,
    double viewMaxScrollExtent,
  ) =>
      scrollViewDelta * barMaxScrollExtent / viewMaxScrollExtent;

  double getScrollViewDelta(
    double barDelta,
    double barMaxScrollExtent,
    double viewMaxScrollExtent,
  ) =>
      barDelta * viewMaxScrollExtent / barMaxScrollExtent;

  void _onVerticalDragStart(DragStartDetails details) {
    setState(() {
      _isDragInProcess = true;
      _labelAnimationController.forward();
    });
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    setState(() {
      if (_thumbAnimationController.status != AnimationStatus.forward) {
        _thumbAnimationController.forward();
      }
      if (_isDragInProcess) {
        _barOffset += details.delta.dx;

        if (_barOffset < barMinScrollExtent) {
          _barOffset = barMinScrollExtent;
        }
        if (_barOffset > barMaxScrollExtent) {
          _barOffset = barMaxScrollExtent;
        }

        double viewDelta = getScrollViewDelta(
          details.delta.dx,
          barMaxScrollExtent,
          viewMaxScrollExtent,
        );

        _viewOffset = widget.controller.position.pixels + viewDelta;
        if (_viewOffset < widget.controller.position.minScrollExtent) {
          _viewOffset = widget.controller.position.minScrollExtent;
        }
        if (_viewOffset > viewMaxScrollExtent) {
          _viewOffset = viewMaxScrollExtent;
        }
        widget.controller.jumpTo(_viewOffset);
      }
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    setState(() {
      _isDragInProcess = false;
    });
  }
}
