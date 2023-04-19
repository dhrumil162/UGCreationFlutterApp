import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ugbussinesscard/models/item_style.dart';

class MoveableItem extends StatefulWidget {
  final Widget? child;
  final double? xPosition;
  final double? yPosition;
  final bool? isMovable;
  final void Function(ItemStyle)? onMoveStop;

  const MoveableItem(
      {Key? key,
      required this.child,
      this.xPosition,
      this.yPosition,
      this.isMovable,
      this.onMoveStop})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MoveableItemState();
  }
}

class _MoveableItemState extends State<MoveableItem> {
  double xPosition = 0;
  double yPosition = 0;

  @override
  void initState() {
    setState(() {
      xPosition = widget.xPosition ?? 0;
      yPosition = widget.yPosition ?? 0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: yPosition,
      left: xPosition,
      child: GestureDetector(
        onPanUpdate: (tap) {
          if (widget.isMovable ?? false) {
            setState(() {
              xPosition = max(0, xPosition + tap.delta.dx);
              yPosition = max(0, yPosition + tap.delta.dy);
            });
            if (widget.onMoveStop != null) {
              widget.onMoveStop!(ItemStyle(xPosition, yPosition));
            }
          }
        },
        child: widget.child,
      ),
    );
  }
}
