import 'package:flutter/cupertino.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:ugbussinesscard/models/carddetail.dart';
import 'package:ugbussinesscard/utils/helper.dart';

Widget card5FrontShapes(BoxConstraints constraints, CardDetail? cardDetail) {
  return Stack(
    children: [
      Positioned(
        top: getCalculatedUnit(
            -5, cardDetail?.deviceHeight, constraints.constrainHeight()),
        right: getCalculatedUnit(
            -4, cardDetail?.deviceWidth, constraints.constrainWidth()),
        child: Transform.rotate(
            angle: 0,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                height: getCalculatedUnit(
                    85, cardDetail?.deviceHeight, constraints.constrainHeight()),
                width: getCalculatedUnit(
                    140, cardDetail?.deviceWidth, constraints.constrainWidth()),
                color: blackColor,
              ),
            )),
      ),
      Positioned(
        top: getCalculatedUnit(
            28, cardDetail?.deviceHeight, constraints.constrainHeight()),
        right: getCalculatedUnit(
            -25, cardDetail?.deviceWidth, constraints.constrainWidth()),
        child: Transform.rotate(
            angle: 1.58 ,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                height: getCalculatedUnit(
                    80, cardDetail?.deviceHeight, constraints.constrainHeight()),
                width: getCalculatedUnit(
                    125, cardDetail?.deviceWidth, constraints.constrainWidth()),
                color: blackColor,
              ),
            )),
      ),
      Positioned(
        bottom: 0,
        right: getCalculatedUnit(
            -210, cardDetail?.deviceWidth, constraints.constrainWidth()),
        child: Transform.rotate(
            angle: 3.14,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                height: getCalculatedUnit(160, cardDetail?.deviceHeight,
                    constraints.constrainHeight()),
                width: getCalculatedUnit(
                    390, cardDetail?.deviceWidth, constraints.constrainWidth()),
                color: const Color(0xfff6d200),
              ),
            )),
      ),
    ],
  );
}

Widget card5BackShapes(BoxConstraints constraints, CardDetail? cardDetail) {
  return Stack(
    children: [
      Positioned(
        top: getCalculatedUnit(
            -5, cardDetail?.deviceHeight, constraints.constrainHeight()),
        left: getCalculatedUnit(
            -4, cardDetail?.deviceWidth, constraints.constrainWidth()),
        child: Transform.rotate(
            angle: 0,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                height: getCalculatedUnit(
                    85, cardDetail?.deviceHeight, constraints.constrainHeight()),
                width: getCalculatedUnit(
                    155, cardDetail?.deviceWidth, constraints.constrainWidth()),
                color: blackColor,
              ),
            )),
      ),
      Positioned(
        top: getCalculatedUnit(
            23, cardDetail?.deviceHeight, constraints.constrainHeight()),
        left: getCalculatedUnit(
            -30, cardDetail?.deviceWidth, constraints.constrainWidth()),
        child: Transform.rotate(
            angle: -1.58,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                height: getCalculatedUnit(
                    95, cardDetail?.deviceHeight, constraints.constrainHeight()),
                width: getCalculatedUnit(
                    140, cardDetail?.deviceWidth, constraints.constrainWidth()),
                color: blackColor,
              ),
            )),
      ),
      Positioned(
        bottom: getCalculatedUnit(
            -20, cardDetail?.deviceHeight, constraints.constrainHeight()),
        left: getCalculatedUnit(
            -136, cardDetail?.deviceWidth, constraints.constrainWidth()),
        child: Transform.rotate(
            angle: 3.18,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                height: getCalculatedUnit(265, cardDetail?.deviceHeight,
                    constraints.constrainHeight()),
                width: getCalculatedUnit(
                    415, cardDetail?.deviceWidth, constraints.constrainWidth()),
                color: const Color(0xfff6d200),
              ),
            )),
      ),
      Positioned(
        bottom: 0,
        right: getCalculatedUnit(
            -120, cardDetail?.deviceWidth, constraints.constrainWidth()),
        child: Transform.rotate(
            angle: 3.14,
            child: ClipPath(
              clipper: TriangleClipper(),
              child: Container(
                height: getCalculatedUnit(
                    90, cardDetail?.deviceHeight, constraints.constrainHeight()),
                width: getCalculatedUnit(
                    240, cardDetail?.deviceWidth, constraints.constrainWidth()),
                color: const Color(0xfff6d200),
              ),
            )),
      ),
    ],
  );
}
