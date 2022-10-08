// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'dart:io';
import 'dart:typed_data';

import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ugbussinesscard/main.dart';
import 'package:ugbussinesscard/models/carddetail.dart';
import 'package:ugbussinesscard/models/item_style.dart';
import 'package:ugbussinesscard/models/text_model.dart';
import 'package:ugbussinesscard/models/user.dart';
import 'package:ugbussinesscard/resizable_utils/movable_item.dart';
import 'package:ugbussinesscard/resizable_utils/responsive_util.dart';
import 'package:ugbussinesscard/text_widget/text_box.dart';
import 'package:ugbussinesscard/utils/constants.dart';
import 'package:ugbussinesscard/utils/filestorage.dart';
import 'package:ugbussinesscard/utils/helper.dart';
import 'package:ugbussinesscard/utils/imgutils.dart';
import 'package:ugbussinesscard/utils/widget_to_image.dart';

class BusinessCard extends StatefulWidget {
  final User? user;
  const BusinessCard({Key? key, this.user}) : super(key: key);

  @override
  _BusinessCardState createState() => _BusinessCardState();
}

class _BusinessCardState extends State<BusinessCard> {
  GlobalKey? key1;
  GlobalKey? key2;
  Uint8List? bytes1;
  Uint8List? bytes2;
  CardDetail? cardDetail;
  Color? pickerColor;
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      cardDetail = getCardDetail("Card1");
      if (cardDetail != null) {
        cardDetail?.frontcardcolor = cardDetail?.frontcardcolor ??
            (themeChangeProvider.darkTheme
                ? cardDarkColor.value
                : cardLightColor.value);
        cardDetail?.backcardcolor = cardDetail?.backcardcolor ??
            (themeChangeProvider.darkTheme
                ? cardDarkColor.value
                : cardLightColor.value);
        cardDetail?.frontImageSize = cardDetail?.frontImageSize ??
            Size(const Size.fromWidth(200).width,
                const Size.fromHeight(100).height);
        cardDetail?.backImageSize = cardDetail?.backImageSize ??
            Size(const Size.fromWidth(100).width,
                const Size.fromHeight(150).height);
        cardDetail?.frontImagePosition = cardDetail?.frontImagePosition ??
            ItemStyle(const Size.fromWidth(100).width,
                const Size.fromHeight(20).height);
        cardDetail?.frontTitleStyle = cardDetail?.frontTitleStyle ??
            ItemStyle(const Size.fromWidth(85).width,
                const Size.fromHeight(150).height);
        cardDetail?.backImagePosition = cardDetail?.backImagePosition ??
            ItemStyle(const Size.fromWidth(0).width,
                const Size.fromHeight(50).height);
        cardDetail?.backTitleStyle = cardDetail?.backTitleStyle ??
            ItemStyle(const Size.fromWidth(140).width,
                const Size.fromHeight(5).height);
        cardDetail?.backAddressStyle = cardDetail?.backAddressStyle ??
            ItemStyle(const Size.fromWidth(140).width,
                const Size.fromHeight(45).height);
      }
    });
  }

  Future<bool> colorPickerDialog() async {
    return ColorPicker(
      color: pickerColor!,
      onColorChanged: (Color color) {
        setState(() {
          pickerColor = color;
        });
      },
      width: 40,
      height: 40,
      borderRadius: 4,
      spacing: 5,
      runSpacing: 5,
      wheelDiameter: 155,
      heading: Text(
        'Select color',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      subheading: Text(
        'Select color shade',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      wheelSubheading: Text(
        'Selected color and its shades',
        style: Theme.of(context).textTheme.subtitle1,
      ),
      showColorName: true,
      materialNameTextStyle: Theme.of(context).textTheme.caption,
      colorNameTextStyle: Theme.of(context).textTheme.caption,
      colorCodeTextStyle: Theme.of(context).textTheme.bodyText2,
      colorCodePrefixStyle: Theme.of(context).textTheme.caption,
      selectedPickerTypeColor: Theme.of(context).colorScheme.primary,
      pickersEnabled: const <ColorPickerType, bool>{
        ColorPickerType.both: true,
        ColorPickerType.primary: false,
        ColorPickerType.accent: false,
        ColorPickerType.wheel: true,
        ColorPickerType.custom: false,
      },
    ).showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context, "Card", actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem<int>(
                value: 1,
                child: Row(
                  children: [
                    Icon(
                      isEdit ? Icons.save_outlined : Icons.edit_rounded,
                      color: getFontColor(),
                      size: const Size.fromHeight(26).height,
                    ),
                    SizedBox(
                      width: const Size.fromWidth(10).width,
                    ),
                    Text(isEdit ? "Save" : "Edit")
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Row(
                  children: [
                    Icon(
                      Icons.download,
                      color: getFontColor(),
                      size: const Size.fromHeight(28).height,
                    ),
                    SizedBox(
                      width: const Size.fromWidth(10).width,
                    ),
                    const Text("Download")
                  ],
                ),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Row(
                  children: [
                    Icon(
                      Icons.color_lens,
                      color: getFontColor(),
                      size: const Size.fromHeight(28).height,
                    ),
                    SizedBox(
                      width: const Size.fromWidth(10).width,
                    ),
                    const Text("Change Background")
                  ],
                ),
              ),
            ];
          }, onSelected: (value) async {
            if (value == 1) {
              if (isEdit) {
                snackBar(context, title: 'Card details saved');
                setValue("Card1", cardDetail?.toJson());
              }
              setState(() {
                isEdit = !isEdit;
              });
            } else if (value == 3) {
              showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return CupertinoActionSheet(
                    actions: [
                      CupertinoActionSheetAction(
                        onPressed: () async {
                          finish(context);
                          setState(() {
                            pickerColor =
                                Color(cardDetail?.frontcardcolor ?? 0);
                          });
                          if (await colorPickerDialog()) {
                            setState(() {
                              cardDetail?.frontcardcolor =
                                  pickerColor?.value ?? 0;
                            });
                          }
                        },
                        isDefaultAction: true,
                        child: Text(
                          'Front Card Background',
                          style: TextStyle(
                              fontSize: const Size.fromHeight(18).height,
                              color: getFontColor()),
                        ),
                      ),
                      CupertinoActionSheetAction(
                          onPressed: () async {
                            finish(context);
                            setState(() {
                              pickerColor =
                                  Color(cardDetail?.backcardcolor ?? 0);
                            });
                            if (await colorPickerDialog()) {
                              setState(() {
                                cardDetail?.backcardcolor =
                                    pickerColor?.value ?? 0;
                              });
                            }
                          },
                          child: Text(
                            'Back Card Background',
                            style: TextStyle(
                                fontSize: const Size.fromHeight(18).height,
                                color: getFontColor()),
                          ))
                    ],
                    cancelButton: CupertinoActionSheetAction(
                        onPressed: () {
                          finish(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontSize: const Size.fromHeight(18).height,
                              color: getFontColor()),
                        )),
                  );
                },
              );
            } else if (value == 2) {
              setState(() {
                isEdit = false;
              });
              FileStorage fs = FileStorage();
              if (await fs.requestPermissions(Permission.storage)) {
                var directory = await fs.getDownloadDirectory();
                var cardDirectory =
                    Directory("${directory?.path ?? ""}/Cards/Card1");
                if (!cardDirectory.existsSync()) {
                  cardDirectory.createSync(recursive: true);
                }
                var newPath = '${cardDirectory.path}/front-card.png';
                var newFile = File(newPath);
                if (!newFile.existsSync()) {
                  newFile.createSync(recursive: true);
                } else {
                  newFile.deleteSync(recursive: true);
                  newFile.createSync(recursive: true);
                }
                final bytes1 = await Utils.capture(key1);
                newFile.writeAsBytesSync(bytes1);

                var newPath1 = '${cardDirectory.path}/back-card.png';
                var newFile1 = File(newPath1);
                if (!newFile1.existsSync()) {
                  newFile1.createSync(recursive: true);
                } else {
                  newFile1.deleteSync(recursive: true);
                  newFile1.createSync(recursive: true);
                }
                final bytes2 = await Utils.capture(key2);
                newFile1.writeAsBytesSync(bytes2);
                snackBar(context,
                    title: 'Card is downloaded to ${cardDirectory.path}');
                setValue("Card1", cardDetail?.toJson());
              }
            }
          }),
        ]),
        body: SingleChildScrollView(
            child: SafeArea(
                maintainBottomViewPadding: true,
                minimum: EdgeInsets.symmetric(
                    horizontal: const Size.fromWidth(10).width,
                    vertical: const Size.fromHeight(20).height),
                child: Column(
                  children: [
                    WidgetToImage(
                      builder: (key) {
                        key2 = key;
                        return Card(
                            color: Color(cardDetail?.frontcardcolor ??
                                (themeChangeProvider.darkTheme
                                    ? cardDarkColor.value
                                    : cardLightColor.value)),
                            elevation: 10,
                            child: SizedBox(
                              height: const Size.fromHeight(240).height,
                              width: context.width() - 30,
                              child: Stack(children: [
                                widget.user?.companyLogo.isEmptyOrNull == true
                                    ? 0.height
                                    : MoveableItem(
                                        isMovable: isEdit,
                                        onMoveStop: ((p0) => setState(() {
                                              cardDetail?.frontImagePosition =
                                                  p0;
                                            })),
                                        xPosition: cardDetail
                                            ?.frontImagePosition?.left,
                                        yPosition:
                                            cardDetail?.frontImagePosition?.top,
                                        child: ResponsiveUtil(
                                          onResize: (p0) {
                                            setState(() {
                                              cardDetail?.frontImageSize = p0;
                                            });
                                          },
                                          disabled: !isEdit,
                                          builder: (context, constraints) {
                                            return Image.file(
                                              File(widget.user?.companyLogo ??
                                                  ""),
                                              height: cardDetail
                                                  ?.frontImageSize?.height,
                                              width: cardDetail
                                                  ?.frontImageSize?.width,
                                              fit: BoxFit.fill,
                                            );
                                          },
                                        )),
                                TextEditingBox(
                                  fonts: fonts,
                                  boundHeight: context.height(),
                                  boundWidth: context.width(),
                                  palletColor: colorPallet,
                                  isSelected: isEdit,
                                  angle: cardDetail?.frontTitleStyle?.angle,
                                  onMoveStop: (p0) {
                                    setState(() {
                                      cardDetail?.frontTitleStyle?.left =
                                          p0.left;
                                      cardDetail?.frontTitleStyle?.top = p0.top;
                                    });
                                  },
                                  onSizeChange: (p0) {
                                    setState(() {
                                      cardDetail?.frontTitleStyle?.scale = p0;
                                    });
                                  },
                                  onRotate: (p0) {
                                    setState(() {
                                      cardDetail?.frontTitleStyle?.angle = p0;
                                    });
                                  },
                                  onTextStyleEdited: (p0) {
                                    setState(() {
                                      cardDetail?.frontTitleStyle?.textStyle =
                                          p0;
                                    });
                                  },
                                  onTap: () {},
                                  newText: TextModel(
                                      name:
                                          "${widget.user?.firstname} ${widget.user?.lastname}",
                                      textStyle: cardDetail
                                          ?.frontTitleStyle?.textStyle,
                                      top:
                                          cardDetail?.frontTitleStyle?.top ?? 0,
                                      isSelected: true,
                                      scale:
                                          cardDetail?.frontTitleStyle?.scale ??
                                              1,
                                      left: cardDetail?.frontTitleStyle?.left ??
                                          0),
                                ),
                              ]),
                            ));
                      },
                    ),
                    12.height,
                    WidgetToImage(builder: (key) {
                      key1 = key;
                      return Card(
                          elevation: 10,
                          color: Color(cardDetail?.backcardcolor ??
                              (themeChangeProvider.darkTheme
                                  ? cardDarkColor.value
                                  : cardLightColor.value)),
                          child: SizedBox(
                              height: const Size.fromHeight(240).height,
                              width: context.width() - 30,
                              child: Stack(
                                children: [
                                  widget.user?.companyLogo.isEmptyOrNull == true
                                      ? 0.height
                                      : MoveableItem(
                                          isMovable: isEdit,
                                          onMoveStop: ((p0) => setState(() {
                                                cardDetail?.backImagePosition =
                                                    p0;
                                              })),
                                          xPosition: cardDetail
                                                  ?.backImagePosition?.left ??
                                              0,
                                          yPosition: cardDetail
                                                  ?.backImagePosition?.top ??
                                              50,
                                          child: ResponsiveUtil(
                                              disabled: !isEdit,
                                              onResize: (p0) {
                                                setState(() {
                                                  cardDetail?.backImageSize =
                                                      p0;
                                                });
                                              },
                                              builder: (context, constraints) {
                                                return Image.file(
                                                  File(widget
                                                          .user?.companyLogo ??
                                                      ""),
                                                  width: cardDetail
                                                      ?.backImageSize?.width,
                                                  height: cardDetail
                                                      ?.backImageSize?.height,
                                                  fit: BoxFit.fill,
                                                );
                                              })),
                                  MoveableItem(
                                      isMovable: isEdit,
                                      onMoveStop: ((p0) => setState(() {
                                            cardDetail?.backTitleStyle = p0;
                                          })),
                                      xPosition:
                                          cardDetail?.backTitleStyle?.left ??
                                              140,
                                      yPosition:
                                          cardDetail?.backTitleStyle?.top ?? 5,
                                      child: Text(
                                          "${widget.user?.firstname} ${widget.user?.lastname}",
                                          style: cardDetail
                                              ?.backTitleStyle?.textStyle)),
                                  MoveableItem(
                                      isMovable: isEdit,
                                      onMoveStop: ((p0) => setState(() {
                                            cardDetail?.backAddressStyle = p0;
                                          })),
                                      xPosition:
                                          cardDetail?.backAddressStyle?.left ??
                                              140,
                                      yPosition:
                                          cardDetail?.backAddressStyle?.top ??
                                              45,
                                      child: Text("${widget.user?.address}",
                                          style: cardDetail
                                              ?.backAddressStyle?.textStyle)),
                                  MoveableItem(
                                      isMovable: isEdit,
                                      onMoveStop: ((p0) => setState(() {
                                            cardDetail?.backMobileStyle = p0;
                                          })),
                                      xPosition:
                                          cardDetail?.backMobileStyle?.left ??
                                              140,
                                      yPosition:
                                          cardDetail?.backMobileStyle?.top ??
                                              160,
                                      child: Text("${widget.user?.phone}",
                                          style: cardDetail
                                              ?.backMobileStyle?.textStyle)),
                                  MoveableItem(
                                      isMovable: isEdit,
                                      onMoveStop: ((p0) => setState(() {
                                            cardDetail?.backEmailStyle = p0;
                                          })),
                                      xPosition:
                                          cardDetail?.backEmailStyle?.left ??
                                              140,
                                      yPosition:
                                          cardDetail?.backEmailStyle?.top ??
                                              180,
                                      child: Text("${widget.user?.email}",
                                          style: cardDetail
                                              ?.backEmailStyle?.textStyle)),
                                ],
                              )));
                    }),
                  ],
                ))));
  }
}
