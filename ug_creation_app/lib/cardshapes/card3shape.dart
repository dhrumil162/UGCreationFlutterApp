import 'package:flutter/material.dart';
import 'package:ugbussinesscard/utils/constants.dart';

Widget card3Shape(
    double? height, double? conWidth, double? cardwidth, double? width) {
  return Positioned(
    bottom: 0,
    child: CustomPaint(
      size: Size((width! * conWidth!) / cardwidth!, height!),
      painter: Card3CurvedPainter(),
    ),
  );
}

class Card3CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.4980000, size.height * -0.2199333);
    path_0.cubicTo(
        size.width * -0.4470000,
        size.height * 0.7532667,
        size.width * 1.180500,
        size.height * 0.3800000,
        size.width * -0.4457400,
        size.height * 1.486667);
    path_0.lineTo(size.width * -0.2745000, size.height * 1.553267);
    path_0.lineTo(0, 0);
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
