// ignore_for_file: invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ugbussinesscard/models/carddetail.dart';
import 'package:ugbussinesscard/models/text_model.dart';
import 'package:ugbussinesscard/text_widget/text_box.dart';
import 'package:ugbussinesscard/ui/defaultcard.dart';
import 'package:ugbussinesscard/utils/constants.dart';
import 'package:ugbussinesscard/utils/helper.dart';

class CardMobile extends StatelessWidget {
  final bool isEdit;
  final CardDetail? cardDetail;
  final BoxConstraints? constraints;

  const CardMobile(this.cardDetail, this.isEdit, {Key? key, this.constraints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var conWidth = constraints?.constrainWidth();
    var conHeight = constraints?.constrainHeight();
    return TextEditingBox(
      fonts: fonts,
      boundHeight: context.height(),
      boundWidth: context.width(),
      isSelected: isEdit,
      angle: cardDetail?.backMobileStyle?.angle,
      onMoveStop: (p0) {
        DefaultCard.of(context)?.setState(() {
          cardDetail?.backMobileStyle?.left = p0.left;
          cardDetail?.backMobileStyle?.top = p0.top;
        });
      },
      onSizeChange: (p0) {
        DefaultCard.of(context)?.setState(() {
          cardDetail?.backMobileStyle?.scale = p0;
        });
      },
      onRotate: (p0) {
        DefaultCard.of(context)?.setState(() {
          cardDetail?.backMobileStyle?.angle = p0;
        });
      },
      onTextStyleEdited: (p0) {
        DefaultCard.of(context)?.setState(() {
          cardDetail?.backMobileStyle?.textStyle = p0;
        });
      },
      onTextChange: (p0) {
        cardDetail?.user?.phone = p0;
      },
      onTap: () {},
      newText: TextModel(
          name: "${cardDetail?.user?.phone}",
          textStyle: getFontStyle(cardDetail?.backMobileStyle?.textStyle,
              cardDetail, conWidth, conHeight),
          top: getCalculatedUnit(cardDetail?.backMobileStyle?.top ?? 160,
              cardDetail?.deviceHeight, conHeight)!,
          isSelected: true,
          scale: cardDetail?.backMobileStyle?.scale ?? 1,
          left: getCalculatedUnit(cardDetail?.backMobileStyle?.left ?? 130,
              cardDetail?.deviceWidth, conWidth)!),
    );
  }
}
