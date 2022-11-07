import 'package:flutter/material.dart';

Widget card4Shape(
    double? height, double? conWidth, double? cardwidth, double? width) {
  return Positioned(
    bottom: 0,
    child: CustomPaint(
      size: Size((width! * conWidth!) / cardwidth!, height!),
      painter: Card4CurvedPainter(),
    ),
  );
}

class Card4CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 1.221740, size.height * -0.5599333);
    path_0.cubicTo(
        size.width * -0.1907400,
        size.height * 0.4199333,
        size.width * 0.5204800,
        size.height * 1.026600,
        size.width * 1.146740,
        size.height * 1.459933);
    path_0.lineTo(size.width, size.height);
    path_0.lineTo(size.width, 0);
    path_0.close();

    Paint paint0Stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    paint0Stroke.color = Colors.transparent.withOpacity(0);
    canvas.drawPath(path_0, paint0Stroke);

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xff5b48a4);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
