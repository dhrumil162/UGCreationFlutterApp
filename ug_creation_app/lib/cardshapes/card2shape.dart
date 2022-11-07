import 'package:flutter/material.dart';
import 'package:ugbussinesscard/utils/constants.dart';

Widget card2Shape(double? height, double? conHeight,
    double? cardHeight, double? width) {
  return Positioned(
    bottom: 0,
    child: CustomPaint(
      size: Size(width!, (height! * conHeight!) / cardHeight!),
      painter: Card2CurvedPainter(),
    ),
  );
}

class Card2CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.3332667);
    path_0.cubicTo(
        size.width * 0.3000000,
        size.height,
        size.width * 0.6996200,
        size.height * -0.3332667,
        size.width * 1.162980,
        size.height * 0.08666667);
    path_0.lineTo(size.width, size.height);
    path_0.lineTo(0, size.height);
    path_0.close();

    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint0Stroke.color = Colors.transparent.withOpacity(0);
    canvas.drawPath(path_0, paint0Stroke);

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = appMatColor.withOpacity(0.8);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
