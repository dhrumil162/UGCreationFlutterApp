// ignore_for_file: invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ugbussinesscard/models/carddetail.dart';
import 'package:ugbussinesscard/models/text_model.dart';
import 'package:ugbussinesscard/text_widget/text_box.dart';
import 'package:ugbussinesscard/ui/defaultcard.dart';
import 'package:ugbussinesscard/utils/constants.dart';
import 'package:ugbussinesscard/utils/helper.dart';

class CardAddress extends StatelessWidget {
  final bool isEdit;
  final CardDetail? cardDetail;
  final BoxConstraints? constraints;

  const CardAddress(this.cardDetail, this.isEdit, {Key? key, this.constraints})
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
      angle: cardDetail?.backAddressStyle?.angle,
      onMoveStop: (p0) {
        DefaultCard.of(context)?.setState(() {
          cardDetail?.backAddressStyle?.left = p0.left;
          cardDetail?.backAddressStyle?.top = p0.top;
        });
      },
      onSizeChange: (p0) {
        DefaultCard.of(context)?.setState(() {
          cardDetail?.backAddressStyle?.scale = p0;
        });
      },
      onRotate: (p0) {
        DefaultCard.of(context)?.setState(() {
          cardDetail?.backAddressStyle?.angle = p0;
        });
      },
      onTextStyleEdited: (p0) {
        DefaultCard.of(context)?.setState(() {
          cardDetail?.backAddressStyle?.textStyle = p0;
        });
      },
      onTextChange: (p0) {
        cardDetail?.user?.address = p0;
      },
      onTap: () {},
      newText: TextModel(
          name: "${cardDetail?.user?.address}",
          textStyle: getFontStyle(cardDetail?.backAddressStyle?.textStyle,
              cardDetail, conWidth, conHeight),
          top: getCalculatedUnit(cardDetail?.backAddressStyle?.top ?? 45,
              cardDetail?.deviceHeight, conHeight)!,
          isSelected: true,
          scale: cardDetail?.backAddressStyle?.scale ?? 1,
          left: getCalculatedUnit(cardDetail?.backAddressStyle?.left ?? 130,
              cardDetail?.deviceWidth, conWidth)!),
    );
  }
}
