// ignore_for_file: invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:ugbussinesscard/models/carddetail.dart';
import 'package:ugbussinesscard/models/text_model.dart';
import 'package:ugbussinesscard/text_widget/text_box.dart';
import 'package:ugbussinesscard/ui/defaultcard.dart';
import 'package:ugbussinesscard/utils/constants.dart';
import 'package:ugbussinesscard/utils/helper.dart';

class CardTitle extends StatelessWidget {
  final bool isFront;
  final bool isEdit;
  final CardDetail? cardDetail;
  final BoxConstraints? constraints;

  const CardTitle(this.isFront, this.cardDetail, this.isEdit,
      {Key? key, this.constraints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var conWidth = constraints?.constrainWidth();
    var conHeight = constraints?.constrainHeight();
    return TextEditingBox(
      fonts: fonts,
      boundHeight: conWidth ?? 0,
      boundWidth: conHeight ?? 0,
      isSelected: isEdit,
      angle: isFront
          ? cardDetail?.frontTitleStyle?.angle
          : cardDetail?.backTitleStyle?.angle,
      onMoveStop: (p0) {
        DefaultCard.of(context)?.setState(() {
          if (isFront) {
            cardDetail?.frontTitleStyle?.left = p0.left;
            cardDetail?.frontTitleStyle?.top = p0.top;
          } else {
            cardDetail?.backTitleStyle?.left = p0.left;
            cardDetail?.backTitleStyle?.top = p0.top;
          }
        });
      },
      onSizeChange: (p0) {
        DefaultCard.of(context)?.setState(() {
          if (isFront) {
            cardDetail?.frontTitleStyle?.scale = p0;
          } else {
            cardDetail?.backTitleStyle?.scale = p0;
          }
        });
      },
      onRotate: (p0) {
        DefaultCard.of(context)?.setState(() {
          if (isFront) {
            cardDetail?.frontTitleStyle?.angle = p0;
          } else {
            cardDetail?.backTitleStyle?.angle = p0;
          }
        });
      },
      onTextStyleEdited: (p0) {
        DefaultCard.of(context)?.setState(() {
          if (isFront) {
            cardDetail?.frontTitleStyle?.textStyle = p0;
          } else {
            cardDetail?.backTitleStyle?.textStyle = p0;
          }
        });
      },
      onTextChange: (p0) {
        cardDetail?.user?.name = p0;
      },
      onTap: () {},
      newText: TextModel(
          name: "${cardDetail?.user?.name}",
          textStyle: isFront
              ? getFontStyle(cardDetail?.frontTitleStyle?.textStyle, cardDetail,
                  conWidth, conHeight)
              : getFontStyle(cardDetail?.backTitleStyle?.textStyle, cardDetail,
                  conWidth, conHeight),
          top: isFront
              ? getCalculatedUnit(cardDetail?.frontTitleStyle?.top ?? 5,
                  cardDetail?.deviceHeight, conHeight)!
              : getCalculatedUnit(cardDetail?.backTitleStyle?.top ?? 5,
                  cardDetail?.deviceHeight, conHeight)!,
          isSelected: true,
          scale: isFront
              ? cardDetail?.frontTitleStyle?.scale ?? 1
              : cardDetail?.backTitleStyle?.scale ?? 1,
          left: isFront
              ? getCalculatedUnit(cardDetail?.frontTitleStyle?.left ?? 130,
                  cardDetail?.deviceWidth, conWidth)!
              : getCalculatedUnit(cardDetail?.backTitleStyle?.left ?? 130,
                  cardDetail?.deviceWidth, conWidth)!),
    );
  }
}
