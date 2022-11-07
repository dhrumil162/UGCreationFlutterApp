// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ugbussinesscard/cardelements/cardaddress.dart';
import 'package:ugbussinesscard/cardelements/cardemail.dart';
import 'package:ugbussinesscard/cardelements/cardmobile.dart';
import 'package:ugbussinesscard/cardelements/cardtitle.dart';
import 'package:ugbussinesscard/cardelements/colorpickerdialog.dart';
import 'package:ugbussinesscard/cardelements/companylogo.dart';
import 'package:ugbussinesscard/cardshapes/card2shape.dart';
import 'package:ugbussinesscard/cardshapes/card3shape.dart';
import 'package:ugbussinesscard/cardshapes/card4shape.dart';
import 'package:ugbussinesscard/cardshapes/card5shape.dart';
import 'package:ugbussinesscard/main.dart';
import 'package:ugbussinesscard/models/carddetail.dart';
import 'package:ugbussinesscard/models/item_style.dart';
import 'package:ugbussinesscard/utils/constants.dart';
import 'package:ugbussinesscard/utils/helper.dart';
import 'package:ugbussinesscard/utils/widget_to_image.dart';

class DefaultCard extends StatefulWidget {
  static _DefaultCardState? of(BuildContext context, {bool root = false}) =>
      root
          ? context.findRootAncestorStateOfType<_DefaultCardState>()
          : context.findAncestorStateOfType<_DefaultCardState>();
  final String cardName;
  const DefaultCard({Key? key, required this.cardName}) : super(key: key);

  @override
  _DefaultCardState createState() => _DefaultCardState();
}

class _DefaultCardState extends State<DefaultCard> {
  GlobalKey? key1;
  GlobalKey? key2;
  Uint8List? bytes1;
  Uint8List? bytes2;
  CardDetail? cardDetail;
  Color? pickerColor;
  bool isEdit = false;
  String cardName = "";
  BoxConstraints? cardConstraints;

  @override
  void initState() {
    super.initState();
    imageCache.clear();
    imageCache.clearLiveImages();
    setState(() {
      cardName = widget.cardName;
      cardDetail = getCardDetail(widget.cardName);
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
    return (await colorPicker(pickerColor, context, (color) {
      setState(() {
        pickerColor = color;
      });
    }))
        .showPickerDialog(
      context,
      constraints:
          const BoxConstraints(minHeight: 480, minWidth: 300, maxWidth: 320),
    );
  }

  saveCardDialog() {
    TextEditingController nameController = TextEditingController();
    showInDialog(context, title: const Text("Enter card name"), actions: [
      formCustomTextField(nameController, TextInputType.name,
              icon: Icons.person_outline_rounded,
              hintText: "Enter card Name",
              labelText: "Card name")
          .paddingBottom(const Size.fromHeight(20).height)
          .paddingSymmetric(horizontal: const Size.fromWidth(10).width),
      AppButton(
        elevation: 5,
        shapeBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        width: context.width(),
        onTap: () async {
          if (nameController.text.isEmptyOrNull) {
            showInDialog(context, title: const Text("Enter card name"));
          } else {
            setState(() {
              cardName = nameController.text;
              isEdit = false;
            });
            snackBar(context, title: 'Card details saved');
            setValue(cardName, cardDetail?.toJson());
            finish(context);
          }
        },
        text: "Save card",
        textStyle:
            TextStyle(fontSize: const Size.fromHeight(20).height, color: white),
        color: appMatColor,
      )
          .paddingBottom(const Size.fromHeight(15).height)
          .paddingSymmetric(horizontal: const Size.fromWidth(10).width)
    ]);
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
                    Text(isEdit && cardName != "New" ? "Save" : "Edit")
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
              cardName == "New"
                  ? PopupMenuItem<int>(
                      value: 5,
                      child: Row(
                        children: [
                          Icon(
                            Icons.save_as,
                            color: getFontColor(),
                            size: const Size.fromHeight(28).height,
                          ),
                          SizedBox(
                            width: const Size.fromWidth(10).width,
                          ),
                          const Text("Save")
                        ],
                      ))
                  : PopupMenuItem<int>(
                      value: 4,
                      padding: EdgeInsets.zero,
                      child: 0.height,
                    ),
            ];
          }, onSelected: (value) async {
            if (value == 1) {
              if (isEdit) {
                if (cardName == "New") {
                  saveCardDialog();
                } else {
                  snackBar(context, title: 'Card details saved');
                  saveCardDetail(cardName, cardDetail);
                }
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
              if (cardName == "New") {
                showInDialog(context,
                    title: const Text(
                        "Kindly save your changes before download."));
                return;
              }
              if (isEdit) {
                showInDialog(context,
                    title: const Text(
                        "Kindly save your changes before download."));
                return;
              }
              downloadCard(
                  context, cardName, cardDetail, key1, key2, cardConstraints);
            } else if (value == 5) {
              saveCardDialog();
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
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero),
                            color: Color(cardDetail?.frontcardcolor ??
                                (themeChangeProvider.darkTheme
                                    ? cardDarkColor.value
                                    : cardLightColor.value)),
                            elevation: 10,
                            child: SizedBox(
                              height: getDCardHeight(),
                              width: getCardWidth(context),
                              child: LayoutBuilder(builder:
                                  (BuildContext context,
                                      BoxConstraints constraints) {
                                DefaultCard.of(context)?.cardConstraints =
                                    constraints;
                                return Stack(children: [
                                  cardName == "Card2"
                                      ? card2Shape(
                                          150,
                                          constraints.constrainHeight(),
                                          cardDetail?.deviceHeight,
                                          context.width())
                                      : cardName == "Card3"
                                          ? card3Shape(
                                              constraints.constrainHeight(),
                                              constraints.constrainHeight(),
                                              cardDetail?.deviceHeight,
                                              context.width())
                                          : cardName == "Card5"
                                              ? card5FrontShapes(
                                                  constraints, cardDetail)
                                              : 0.height,
                                  cardDetail?.user?.companyLogo.isEmptyOrNull ==
                                          true
                                      ? 0.height
                                      : CompanyLogo(true, cardDetail, isEdit,
                                          constraints: constraints),
                                  CardTitle(
                                    true,
                                    cardDetail,
                                    isEdit,
                                    constraints: constraints,
                                  )
                                ]);
                              }),
                            ));
                      },
                    ),
                    12.height,
                    WidgetToImage(builder: (key) {
                      key1 = key;
                      return Card(
                          elevation: 10,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                          color: Color(cardDetail?.backcardcolor ??
                              (themeChangeProvider.darkTheme
                                  ? cardDarkColor.value
                                  : cardLightColor.value)),
                          child: SizedBox(
                              height: getDCardHeight(),
                              width: getCardWidth(context),
                              child: LayoutBuilder(builder:
                                  (BuildContext context,
                                      BoxConstraints constraints) {
                                return Stack(
                                  children: [
                                    cardName == "Card4"
                                        ? card4Shape(
                                            constraints.constrainHeight(),
                                            constraints.constrainWidth(),
                                            cardDetail?.deviceWidth,
                                            context.width())
                                        : cardName == "Card2"
                                            ? card2Shape(
                                                180,
                                                constraints.constrainHeight(),
                                                cardDetail?.deviceHeight,
                                                context.width())
                                            : cardName == "Card3"
                                                ? card3Shape(
                                                    constraints
                                                        .constrainHeight(),
                                                    constraints
                                                        .constrainWidth(),
                                                    cardDetail?.deviceWidth,
                                                    context.width())
                                                : cardName == "Card5"
                                                    ? card5BackShapes(
                                                        constraints, cardDetail)
                                                    : 0.height,
                                    cardDetail?.user?.companyLogo
                                                    .isEmptyOrNull ==
                                                true ||
                                            cardName == "Card5"
                                        ? 0.height
                                        : CompanyLogo(
                                            false,
                                            cardDetail,
                                            isEdit,
                                            constraints: constraints,
                                          ),
                                    cardName == "Card5"
                                        ? 0.height
                                        : CardTitle(false, cardDetail, isEdit,
                                            constraints: constraints),
                                    CardAddress(cardDetail, isEdit,
                                        constraints: constraints),
                                    CardMobile(cardDetail, isEdit,
                                        constraints: constraints),
                                    CardEmail(cardDetail, isEdit,
                                        constraints: constraints)
                                  ],
                                );
                              })));
                    }),
                  ],
                ))));
  }
}
