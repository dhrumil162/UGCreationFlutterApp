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
import 'package:ugbussinesscard/resizable_utils/movable_item.dart';
import 'package:ugbussinesscard/resizable_utils/responsive_util.dart';
import 'package:ugbussinesscard/text_widget/text_box.dart';
import 'package:ugbussinesscard/utils/constants.dart';
import 'package:ugbussinesscard/utils/filestorage.dart';
import 'package:ugbussinesscard/utils/helper.dart';
import 'package:ugbussinesscard/utils/imgutils.dart';
import 'package:ugbussinesscard/utils/widget_to_image.dart';

class Card1 extends StatefulWidget {
  const Card1({Key? key}) : super(key: key);

  @override
  _Card1State createState() => _Card1State();
}

class _Card1State extends State<Card1> {
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
      cardDetail?.user ??= getUserDetail();
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
            ItemStyle(const Size.fromWidth(90).width,
                const Size.fromHeight(50).height);
        cardDetail?.frontTitleStyle = cardDetail?.frontTitleStyle ??
            ItemStyle(const Size.fromWidth(100).width,
                const Size.fromHeight(150).height);
        cardDetail?.backImagePosition = cardDetail?.backImagePosition ??
            ItemStyle(const Size.fromWidth(20).width,
                const Size.fromHeight(45).height);
        cardDetail?.backTitleStyle = cardDetail?.backTitleStyle ??
            ItemStyle(const Size.fromWidth(130).width,
                const Size.fromHeight(5).height);
        cardDetail?.backAddressStyle = cardDetail?.backAddressStyle ??
            ItemStyle(const Size.fromWidth(130).width,
                const Size.fromHeight(45).height,
                textStyle:
                    TextStyle(fontSize: const Size.fromHeight(12).height));
        cardDetail?.backEmailStyle = cardDetail?.backEmailStyle ??
            ItemStyle(const Size.fromWidth(130).width,
                const Size.fromHeight(180).height,
                textStyle:
                    TextStyle(fontSize: const Size.fromHeight(12).height));
        cardDetail?.backMobileStyle = cardDetail?.backMobileStyle ??
            ItemStyle(const Size.fromWidth(130).width,
                const Size.fromHeight(160).height,
                textStyle:
                    TextStyle(fontSize: const Size.fromHeight(12).height));
      }
      if (cardDetail?.frontTitleStyle?.textStyle?.color == null) {
        cardDetail?.frontTitleStyle?.textStyle = cardDetail
            ?.frontTitleStyle?.textStyle
            ?.copyWith(color: getFontColor());
      }
      if (cardDetail?.backAddressStyle?.textStyle?.color == null) {
        cardDetail?.backAddressStyle?.textStyle = cardDetail
            ?.backAddressStyle?.textStyle
            ?.copyWith(color: getFontColor());
      }
      if (cardDetail?.backTitleStyle?.textStyle?.color == null) {
        cardDetail?.backTitleStyle?.textStyle = cardDetail
            ?.backTitleStyle?.textStyle
            ?.copyWith(color: getFontColor());
      }
      if (cardDetail?.backEmailStyle?.textStyle?.color == null) {
        cardDetail?.backEmailStyle?.textStyle = cardDetail
            ?.backEmailStyle?.textStyle
            ?.copyWith(color: getFontColor());
      }
      if (cardDetail?.backMobileStyle?.textStyle?.color == null) {
        cardDetail?.backMobileStyle?.textStyle = cardDetail
            ?.backMobileStyle?.textStyle
            ?.copyWith(color: getFontColor());
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
                var cardDirectory = Directory("$directory/Cards/Card1");
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
                setValue("Card1", cardDetail?.toJson());
                snackBar(context,
                    title: 'Card is downloaded to ${cardDirectory.path}');
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
                                cardDetail?.user?.companyLogo.isEmptyOrNull ==
                                        true
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
                                              File(cardDetail
                                                      ?.user?.companyLogo ??
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
                                  onTextChange: (p0) {
                                    setState(() {
                                      cardDetail?.user?.name = p0;
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
                                      name: "${cardDetail?.user?.name}",
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
                                  cardDetail?.user?.companyLogo.isEmptyOrNull ==
                                          true
                                      ? 0.height
                                      : MoveableItem(
                                          isMovable: isEdit,
                                          onMoveStop: ((p0) => setState(() {
                                                cardDetail?.backImagePosition =
                                                    p0;
                                              })),
                                          xPosition: cardDetail
                                                  ?.backImagePosition?.left ??
                                              20,
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
                                                  File(cardDetail
                                                          ?.user?.companyLogo ??
                                                      ""),
                                                  width: cardDetail
                                                      ?.backImageSize?.width,
                                                  height: cardDetail
                                                      ?.backImageSize?.height,
                                                  fit: BoxFit.fill,
                                                );
                                              })),
                                  TextEditingBox(
                                    fonts: fonts,
                                    boundHeight: context.height(),
                                    boundWidth: context.width(),
                                    isSelected: isEdit,
                                    angle: cardDetail?.backTitleStyle?.angle,
                                    onMoveStop: (p0) {
                                      setState(() {
                                        cardDetail?.backTitleStyle?.left =
                                            p0.left;
                                        cardDetail?.backTitleStyle?.top =
                                            p0.top;
                                      });
                                    },
                                    onSizeChange: (p0) {
                                      setState(() {
                                        cardDetail?.backTitleStyle?.scale = p0;
                                      });
                                    },
                                    onRotate: (p0) {
                                      setState(() {
                                        cardDetail?.backTitleStyle?.angle = p0;
                                      });
                                    },
                                    onTextStyleEdited: (p0) {
                                      setState(() {
                                        cardDetail?.backTitleStyle?.textStyle =
                                            p0;
                                      });
                                    },
                                    onTextChange: (p0) {
                                      setState(() {
                                        cardDetail?.user?.name = p0;
                                      });
                                    },
                                    onTap: () {},
                                    newText: TextModel(
                                        name: "${cardDetail?.user?.name}",
                                        textStyle: cardDetail
                                            ?.backTitleStyle?.textStyle,
                                        top: cardDetail?.backTitleStyle?.top ??
                                            5,
                                        isSelected: true,
                                        scale:
                                            cardDetail?.backTitleStyle?.scale ??
                                                1,
                                        left:
                                            cardDetail?.backTitleStyle?.left ??
                                                130),
                                  ),
                                  TextEditingBox(
                                    fonts: fonts,
                                    boundHeight: context.height(),
                                    boundWidth: context.width(),
                                    isSelected: isEdit,
                                    angle: cardDetail?.backAddressStyle?.angle,
                                    onMoveStop: (p0) {
                                      setState(() {
                                        cardDetail?.backAddressStyle?.left =
                                            p0.left;
                                        cardDetail?.backAddressStyle?.top =
                                            p0.top;
                                      });
                                    },
                                    onSizeChange: (p0) {
                                      setState(() {
                                        cardDetail?.backAddressStyle?.scale =
                                            p0;
                                      });
                                    },
                                    onRotate: (p0) {
                                      setState(() {
                                        cardDetail?.backAddressStyle?.angle =
                                            p0;
                                      });
                                    },
                                    onTextStyleEdited: (p0) {
                                      setState(() {
                                        cardDetail
                                            ?.backAddressStyle?.textStyle = p0;
                                      });
                                    },
                                    onTextChange: (p0) {
                                      setState(() {
                                        cardDetail?.user?.address = p0;
                                      });
                                    },
                                    onTap: () {},
                                    newText: TextModel(
                                        name: "${cardDetail?.user?.address}",
                                        textStyle: cardDetail
                                            ?.backAddressStyle?.textStyle,
                                        top:
                                            cardDetail?.backAddressStyle?.top ??
                                                45,
                                        isSelected: true,
                                        scale: cardDetail
                                                ?.backAddressStyle?.scale ??
                                            1,
                                        left: cardDetail
                                                ?.backAddressStyle?.left ??
                                            130),
                                  ),
                                  TextEditingBox(
                                    fonts: fonts,
                                    boundHeight: context.height(),
                                    boundWidth: context.width(),
                                    isSelected: isEdit,
                                    angle: cardDetail?.backMobileStyle?.angle,
                                    onMoveStop: (p0) {
                                      setState(() {
                                        cardDetail?.backMobileStyle?.left =
                                            p0.left;
                                        cardDetail?.backMobileStyle?.top =
                                            p0.top;
                                      });
                                    },
                                    onSizeChange: (p0) {
                                      setState(() {
                                        cardDetail?.backMobileStyle?.scale = p0;
                                      });
                                    },
                                    onRotate: (p0) {
                                      setState(() {
                                        cardDetail?.backMobileStyle?.angle = p0;
                                      });
                                    },
                                    onTextStyleEdited: (p0) {
                                      setState(() {
                                        cardDetail?.backMobileStyle?.textStyle =
                                            p0;
                                      });
                                    },
                                    onTextChange: (p0) {
                                      setState(() {
                                        cardDetail?.user?.phone = p0;
                                      });
                                    },
                                    onTap: () {},
                                    newText: TextModel(
                                        name: "${cardDetail?.user?.phone}",
                                        textStyle: cardDetail
                                            ?.backMobileStyle?.textStyle,
                                        top: cardDetail?.backMobileStyle?.top ??
                                            160,
                                        isSelected: true,
                                        scale: cardDetail
                                                ?.backMobileStyle?.scale ??
                                            1,
                                        left:
                                            cardDetail?.backMobileStyle?.left ??
                                                130),
                                  ),
                                  TextEditingBox(
                                    fonts: fonts,
                                    boundHeight: context.height(),
                                    boundWidth: context.width(),
                                    isSelected: isEdit,
                                    angle: cardDetail?.backEmailStyle?.angle,
                                    onMoveStop: (p0) {
                                      setState(() {
                                        cardDetail?.backEmailStyle?.left =
                                            p0.left;
                                        cardDetail?.backEmailStyle?.top =
                                            p0.top;
                                      });
                                    },
                                    onSizeChange: (p0) {
                                      setState(() {
                                        cardDetail?.backEmailStyle?.scale = p0;
                                      });
                                    },
                                    onRotate: (p0) {
                                      setState(() {
                                        cardDetail?.backEmailStyle?.angle = p0;
                                      });
                                    },
                                    onTextStyleEdited: (p0) {
                                      setState(() {
                                        cardDetail?.backEmailStyle?.textStyle =
                                            p0;
                                      });
                                    },
                                    onTextChange: (p0) {
                                      setState(() {
                                        cardDetail?.user?.email = p0;
                                      });
                                    },
                                    onTap: () {},
                                    newText: TextModel(
                                        name: "${cardDetail?.user?.email}",
                                        textStyle: cardDetail
                                            ?.backEmailStyle?.textStyle,
                                        top: cardDetail?.backEmailStyle?.top ??
                                            180,
                                        isSelected: true,
                                        scale:
                                            cardDetail?.backEmailStyle?.scale ??
                                                1,
                                        left:
                                            cardDetail?.backEmailStyle?.left ??
                                                130),
                                  ),
                                ],
                              )));
                    }),
                  ],
                ))));
  }
}
