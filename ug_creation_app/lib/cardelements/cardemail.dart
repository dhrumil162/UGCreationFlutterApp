// ignore_for_file: invalid_use_of_protected_member
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ugbussinesscard/models/carddetail.dart';
import 'package:ugbussinesscard/models/text_model.dart';
import 'package:ugbussinesscard/text_widget/text_box.dart';
import 'package:ugbussinesscard/ui/defaultcard.dart';
import 'package:ugbussinesscard/utils/constants.dart';
import 'package:ugbussinesscard/utils/helper.dart';

class CardEmail extends StatelessWidget {
  final bool isEdit;
  final CardDetail? cardDetail;
  final BoxConstraints? constraints;

  const CardEmail(this.cardDetail, this.isEdit, {Key? key, this.constraints})
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
      angle: cardDetail?.backEmailStyle?.angle,
      onMoveStop: (p0) {
        DefaultCard.of(context)?.setState(() {
          cardDetail?.backEmailStyle?.left = p0.left;
          cardDetail?.backEmailStyle?.top = p0.top;
        });
      },
      onSizeChange: (p0) {
        DefaultCard.of(context)?.setState(() {
          cardDetail?.backEmailStyle?.scale = p0;
        });
      },
      onRotate: (p0) {
        DefaultCard.of(context)?.setState(() {
          cardDetail?.backEmailStyle?.angle = p0;
        });
      },
      onTextStyleEdited: (p0) {
        DefaultCard.of(context)?.setState(() {
          cardDetail?.backEmailStyle?.textStyle = p0;
        });
      },
      onTextChange: (p0) {
        cardDetail?.user?.email = p0;
      },
      onTap: () {},
      newText: TextModel(
          name: "${cardDetail?.user?.email}",
          textStyle: getFontStyle(cardDetail?.backEmailStyle?.textStyle,
              cardDetail, conWidth, conHeight),
          top: getCalculatedUnit(cardDetail?.backEmailStyle?.top ?? 180,
              cardDetail?.deviceHeight, conHeight)!,
          isSelected: true,
          scale: cardDetail?.backEmailStyle?.scale ?? 1,
          left: getCalculatedUnit(cardDetail?.backEmailStyle?.left ?? 130,
              cardDetail?.deviceWidth, conWidth)!),
    );
  }
}
