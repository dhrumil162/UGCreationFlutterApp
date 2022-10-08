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
        onPanUpdate: (tapInfo) {
          if (widget.isMovable ?? false) {
            setState(() {
              xPosition += tapInfo.delta.dx;
              yPosition += tapInfo.delta.dy;
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
