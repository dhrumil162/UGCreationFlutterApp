// ignore_for_file: library_private_types_in_public_api

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:ugbussinesscard/models/item_style.dart';
import 'package:ugbussinesscard/models/text_model.dart';

import 'textstyle_editor.dart';

// ignore: must_be_immutable
class TextEditingBox extends StatefulWidget {
  // TextModel for your text
  final TextModel newText;

  /// Your widget should be move within this [boundWidth]
  final double boundWidth;

  /// Your widget should be move within this [boundHeight]
  final double boundHeight;

  /// For Visibility of editing border
  bool isSelected;

  /// For Visibility of editing style modal
  bool openModal;

  /// Total Fonts option that you want to give to user
  final List<String> fonts;

  /// If you use onTap then you Have to manage IsSelected field in TextModel and [isSelected]
  final Function()? onTap;

  /// If you use onCancel then you Have to manage IsSelected field in TextModel and [isSelected]
  final Function()? onCancel;

  final void Function(ItemStyle)? onMoveStop;

  final void Function(double)? onSizeChange;

  final void Function(double)? onRotate;

  final Function(TextStyle)? onTextStyleEdited;

  final Function(String)? onTextChange;

  double? angle = 0.0;

  /// Create a [TextEditingBox] widget
  ///
  /// [TextModel] detail of your picture
  /// [onTap] callback function that called when you tap on [TextEditingBox]
  /// [onCancel] callback function that called when you tap on Cross icon in [TextEditingBox] border
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
  double _angleDelta = 0.0;
  Offset deltaOffset = const Offset(0, 0);

  @override
  void initState() {
    setState(() {
      xPosition = widget.newText.left;
      yPosition = widget.newText.top;
      angle = widget.angle ?? 0.0;
      _oldAngle = widget.angle ?? 0.0;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: widget.newText.top,
      left: widget.newText.left,
      child: Transform.scale(
        scale: widget.newText.scale,
        child: Transform.rotate(
          angle: angle,
          child: GestureDetector(
            onScaleUpdate: (tap) {
              if (tap.pointerCount == 2) {
                widget.newText.scale = tap.scale;
                angle = tap.rotation;
              }
              if (widget.onMoveStop != null && widget.isSelected) {
                if (_oldAngle > 1.2) {
                  setState(() {
                    xPosition -= tap.focalPointDelta.dx;
                    yPosition -= tap.focalPointDelta.dy;
                  });
                } else {
                  setState(() {
                    xPosition += tap.focalPointDelta.dx;
                    yPosition += tap.focalPointDelta.dy;
                  });
                }
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
                                shape: BoxShape.circle, color: Colors.white),
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
                                border:
                                    Border.all(color: Colors.black, width: 1),
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
                    behavior: HitTestBehavior.translucent,
                    onPanStart: (details) {
                      // final touchPositionFromCenter =
                      //     details.localPosition - centerOfGestureDetector;
                      _angleDelta = _oldAngle - details.localPosition.direction;
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
                      setState(
                        () {
                          angle = details.localPosition.direction + _angleDelta;
                        },
                      );
                    },
                    // onScaleUpdate: (detail) {
                    //   setState(() => angle = detail.focalPoint.direction);
                    //   if (widget.onRotate != null && widget.isSelected) {
                    //     widget.onRotate!(angle);
                    //   }
                    // },
                    child: widget.isSelected
                        ? Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
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
                    onPanUpdate: (tap) {
                      if (tap.delta.dx.isNegative &&
                          widget.newText.scale > .8) {
                        setState(() => widget.newText.scale -= 0.01);
                      } else if (!tap.delta.dx.isNegative &&
                          widget.newText.scale < 5) {
                        setState(() => widget.newText.scale += 0.01);
                      }
                      if (widget.onSizeChange != null && widget.isSelected) {
                        widget.onSizeChange!(widget.newText.scale);
                      }
                    },
                    child: widget.isSelected
                        ? Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 1),
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
          ),
        ),
      ),
    );
  }

  // Model Bottom sheet
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

  // Text edit dailog box
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
