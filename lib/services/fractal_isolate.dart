import 'dart:isolate';
import 'package:flutter/widgets.dart';
import '../models/line.dart';
import '../utils/fractal_tree.dart';

class FractalIsolate {
  late Offset canvasSize;
  double deltaAngle = 0;
  double depth = 0;
  List<Line>? points;
  SendPort? drawFractal;

  FractalIsolate({
    required this.canvasSize,
    this.deltaAngle = 0,
    this.depth = 0,
  });

  Future<void> initIsolate() async {
    final receivePort = ReceivePort();
    await Isolate.spawn(generateFractal, receivePort.sendPort);
    drawFractal = await receivePort.first as SendPort;
  }

  void generateFractal(SendPort mainSendPort) {
    final port = ReceivePort();
    mainSendPort.send(port.sendPort);

    port.listen((args) {
      final int branchLength = 90;
      final deltaAngle = args['deltaAngle'];
      final double depth = args['depth'];
      final Offset canvasSize = args['canvasSize'];
      SendPort response = args['sendPort'];

      Offset lastPoint = Offset(
        (canvasSize.dx / 2) - 1,
        (canvasSize.dy - 1) - branchLength,
      );

      final points = fractalTree(
        lastPoint: lastPoint,
        branchLength: branchLength,
        deltaAngle: deltaAngle,
        angle: 90,
        depth: depth,
        points: [],
      );
      response.send(points);
    });
  }

  void requestFractal(void Function(List<Line>) onPointsUpdated) async {
    final responsePort = ReceivePort();

    drawFractal!.send({
      'sendPort': responsePort.sendPort,
      'canvasSize': canvasSize,
      'depth': depth,
      'deltaAngle': deltaAngle,
    });

    responsePort.listen((data) {
      final lines = data as List<Line>;
      points = lines;

      onPointsUpdated(points!);
      responsePort.close();
    });
  }
}
