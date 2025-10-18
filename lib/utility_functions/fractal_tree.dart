import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fractals/modules/line.dart';

List<Line> fractalTree({
  required Offset lastPoint,
  required branchLength,
  required deltaAngle,
  angle,
  required List<Line> points,
}) {
  if (branchLength <= 2) {
    return points;
  }

  Offset branch = Offset(
    lastPoint.dx + (branchLength * cos(toRadians(angle))),
    lastPoint.dy - (branchLength * sin(toRadians(angle))),
  );

  points.add(Line(start: lastPoint, end: branch));

  fractalTree(
    lastPoint: branch,
    branchLength: branchLength * 0.72,
    deltaAngle: deltaAngle,
    angle: angle + deltaAngle,
    points: points,
  );

  fractalTree(
    lastPoint: branch,
    branchLength: branchLength * 0.72,
    deltaAngle: deltaAngle,
    angle: angle - deltaAngle,
    points: points,
  );

  return points;
}

double toRadians(angle) => angle * (pi / 180);
