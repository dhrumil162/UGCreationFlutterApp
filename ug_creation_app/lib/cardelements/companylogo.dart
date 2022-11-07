// ignore_for_file: invalid_use_of_protected_member, must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ugbussinesscard/models/carddetail.dart';
import 'package:ugbussinesscard/resizable_utils/movable_item.dart';
import 'package:ugbussinesscard/resizable_utils/responsive_util.dart';
import 'package:ugbussinesscard/ui/defaultcard.dart';
import 'package:ugbussinesscard/utils/helper.dart';

class CompanyLogo extends StatelessWidget {
  final bool isFront;
  final bool isEdit;
  final bool isHome;
  final CardDetail? cardDetail;
  final BoxConstraints? constraints;

  const CompanyLogo(this.isFront, this.cardDetail, this.isEdit,
      {GlobalKey? key, this.isHome = false, this.constraints})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var conWidth = constraints?.constrainWidth();
    return MoveableItem(
        isMovable: isEdit,
        onMoveStop: (p0) {
          DefaultCard.of(context)?.setState(() {
            if (isFront) {
              cardDetail?.frontImagePosition = p0;
            } else {
              cardDetail?.backImagePosition = p0;
            }
          });
        },
        xPosition: isFront
            ? getCalculatedUnit(cardDetail?.frontImagePosition?.left,
                cardDetail?.deviceWidth, conWidth)
            : getCalculatedUnit(cardDetail?.backImagePosition?.left,
                cardDetail?.deviceWidth, conWidth),
        yPosition: isFront
            ? (cardDetail?.frontImagePosition?.top)! * (isHome ? .5 : 1)
            : (cardDetail?.backImagePosition?.top)! * (isHome ? .5 : 1),
        child: ResponsiveUtil(
          onResize: (p0) {
            DefaultCard.of(context)?.setState(() {
              if (isFront) {
                cardDetail?.frontImageSize = p0;
              } else {
                cardDetail?.backImageSize = p0;
              }
            });
          },
          disabled: !isEdit,
          builder: (context, constraints) {
            return Image.file(
              File(cardDetail?.user?.companyLogo ?? ""),
              height: isFront
                  ? (cardDetail?.frontImageSize?.height)! * (isHome ? .5 : 1)
                  : (cardDetail?.backImageSize?.height)! * (isHome ? .5 : 1),
              width: isFront
                  ? getCalculatedUnit(cardDetail?.frontImageSize?.width,
                      cardDetail?.deviceWidth, conWidth)
                  : getCalculatedUnit(cardDetail?.backImageSize?.width,
                      cardDetail?.deviceWidth, conWidth),
              fit: BoxFit.fill,
            );
          },
        ));
  }
}
