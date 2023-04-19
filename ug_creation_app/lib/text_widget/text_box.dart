// ignore_for_file: library_private_types_in_public_api
import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:ugbussinesscard/models/item_style.dart';
import 'package:ugbussinesscard/models/text_model.dart';
import 'textstyle_editor.dart';

// ignore: must_be_immutable
class TextEditingBox extends StatefulWidget {
  final TextModel newText;

  final double boundWidth;

  final double boundHeight;

  bool isSelected;

  bool openModal;

  final List<String> fonts;

  final Function()? onTap;

  final Function()? onCancel;

  final void Function(ItemStyle)? onMoveStop;

  final void Function(double)? onSizeChange;

  final void Function(double)? onRotate;

  final Function(TextStyle)? onTextStyleEdited;

  final Function(String)? onTextChange;

  double? angle = 0.0;

  TextEditingBox(
      {Key? key,
      required this.newText,
      required this.boundWidth,
      required this.boundHeight,
      required this.fonts,
      this.isSelected = false,
      this.openModal = false,
      this.onCancel,
      this.onTap,
      this.onMoveStop,
      this.onSizeChange,
      this.onTextStyleEdited,
      this.onTextChange,
      this.onRotate,
      this.angle = 0.0})
      : super(key: key);

  @override
  _TextEditingBoxState createState() => _TextEditingBoxState();
}

class _TextEditingBoxState extends State<TextEditingBox> {
  double angle = 0.0;
  double xPosition = 0.0;
  double yPosition = 0.0;
  double _oldAngle = 0.0;
  double? height = 0;
  double? width = 0;
  Offset deltaOffset = const Offset(0, 0);
  final _textWidgetKey = GlobalKey();

  @override
  void initState() {
    setState(() {
      xPosition = widget.newText.left;
      yPosition = widget.newText.top;
      angle = widget.angle ?? 0.0;
      _oldAngle = widget.angle ?? 0.0;
    });
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        height = _textWidgetKey.currentContext!.size?.height;
        width = _textWidgetKey.currentContext!.size?.width;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onPanUpdate: (tap) {
          if (widget.onMoveStop != null && widget.isSelected) {
            setState(() {
              xPosition = max(0, xPosition + tap.delta.dx);
              yPosition = max(0, yPosition + tap.delta.dy);
            });
            widget.onMoveStop!(ItemStyle(xPosition, yPosition));
          }
        },
        onTap: () {
          if (widget.onTap == null) {
            setState(() {
              if (widget.isSelected) {
                widget.isSelected = false;
                widget.newText.isSelected = false;
              } else {
                widget.isSelected = true;
                widget.newText.isSelected = true;
              }
            });
            if (widget.isSelected == true) {
              textModelBottomSheet(
                context: context,
                newText: widget.newText,
              );
            }
          } else {
            widget.onTap!();
            if (widget.isSelected) {
              textModelBottomSheet(
                context: context,
                newText: widget.newText,
              );
            }
          }
        },
        child: Container(
          margin: EdgeInsets.only(
            top: yPosition,
            left: xPosition,
          ),
          child: Transform.scale(
              scale: widget.newText.scale,
              child: Container(
                transformAlignment: FractionalOffset.center,
                transform: Matrix4.identity()..rotateZ(angle),
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DottedBorder(
                        color: widget.isSelected
                            ? Colors.grey[600]!
                            : Colors.transparent,
                        padding: const EdgeInsets.all(4),
                        child: Text(widget.newText.name,
                            key: _textWidgetKey,
                            style: widget.newText.textStyle,
                            textScaleFactor: widget.newText.scale),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () {
                          if (widget.onCancel != null) {
                            widget.onCancel!();
                          }
                          setState(() {
                            if (widget.isSelected) {
                              widget.isSelected = false;
                              widget.newText.isSelected = false;
                            } else {
                              widget.isSelected = true;
                              widget.newText.isSelected = true;
                            }
                          });
                        },
                        child: widget.isSelected
                            ? Container(
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Icon(Icons.cancel_outlined,
                                    color: Colors.black,
                                    size: const Size.fromHeight(20).height),
                              )
                            : Container(),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      child: InkWell(
                        onTap: () async {
                          await showEditBox(
                            context: context,
                            textModel: widget.newText,
                          );
                        },
                        child: widget.isSelected
                            ? Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Icon(Icons.edit,
                                    color: Colors.black,
                                    size: const Size.fromHeight(14).height),
                              )
                            : Container(),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: GestureDetector(
                        behavior: HitTestBehavior.deferToChild,
                        onPanStart: (details) {
                          Offset centerOfGestureDetector = Offset(
                              (_textWidgetKey.currentContext!.size?.width)! / 2,
                              (_textWidgetKey.currentContext!.size?.height)! /
                                  2);
                          final touchPositionFromCenter =
                              details.localPosition - centerOfGestureDetector;
                          _oldAngle = touchPositionFromCenter.direction - angle;
                        },
                        onPanEnd: (details) {
                          setState(
                            () {
                              _oldAngle = angle;
                            },
                          );
                          if (widget.onRotate != null && widget.isSelected) {
                            widget.onRotate!(_oldAngle);
                          }
                        },
                        onPanUpdate: (details) {
                          Offset centerOfGestureDetector = Offset(
                              (_textWidgetKey.currentContext!.size?.width)! / 2,
                              (_textWidgetKey.currentContext!.size?.height)! /
                                  2);
                          final touchPositionFromCenter =
                              details.localPosition - centerOfGestureDetector;
                          setState(
                            () {
                              angle =
                                  touchPositionFromCenter.direction - _oldAngle;
                            },
                          );
                        },
                        child: widget.isSelected
                            ? Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                                child: Icon(Icons.rotate_right,
                                    color: Colors.black,
                                    size: const Size.fromHeight(14).height),
                              )
                            : Container(),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        behavior: HitTestBehavior.deferToChild,
                        onPanUpdate: (tap) {
                          if (tap.delta.dx.isNegative &&
                              widget.newText.scale > .8) {
                            setState(() => widget.newText.scale -= 0.01);
                          } else if (!tap.delta.dx.isNegative &&
                              widget.newText.scale < 5) {
                            setState(() => widget.newText.scale += 0.01);
                          }
                          if (widget.onSizeChange != null &&
                              widget.isSelected) {
                            widget.onSizeChange!(widget.newText.scale);
                          }
                        },
                        child: widget.isSelected
                            ? Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                    color: Colors.white,
                                    shape: BoxShape.circle),
                                child: Icon(Icons.crop,
                                    color: Colors.black,
                                    size: const Size.fromHeight(14).height),
                              )
                            : Container(),
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }

  Future textModelBottomSheet(
      {required BuildContext context, required TextModel newText}) {
    double height = MediaQuery.of(context).size.height;
    return showModalBottomSheet(
        elevation: 15,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(4),
            height: height * .35,
            child: TextStyleEditor(
              fonts: widget.fonts,
              textStyle: newText.textStyle!,
              onTextStyleEdited: (style) {
                setState(
                    () => newText.textStyle = newText.textStyle!.merge(style));
                if (widget.onTextStyleEdited != null) {
                  widget.onTextStyleEdited!(newText.textStyle!);
                }
              },
            ),
          );
        });
  }

  Future showEditBox({BuildContext? context, TextModel? textModel}) {
    return showDialog(
        context: context!,
        builder: (context) {
          final dailogTextController =
              TextEditingController(text: widget.newText.name);
          return AlertDialog(
            title: const Text('Edit Text'),
            content: TextField(
                controller: dailogTextController,
                maxLines: 6,
                minLines: 1,
                autofocus: true,
                decoration: InputDecoration(hintText: widget.newText.name)),
            actions: [
              ElevatedButton(
                child: const Text('Done'),
                onPressed: () {
                  setState(
                      () => widget.newText.name = dailogTextController.text);
                  if (widget.onTextChange != null) {
                    widget.onTextChange!(dailogTextController.text);
                  }
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }
}
