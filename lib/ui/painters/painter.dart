import 'package:flutter/material.dart';
import '../../models/line.dart';

class Painter extends CustomPainter {
  final List<Line> points;

  Painter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    Paint body = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    for (Line line in points) {
      canvas.drawLine(line.start, line.end, body);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
