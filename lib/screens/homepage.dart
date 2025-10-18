import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:fractals/modules/line.dart';
import 'package:fractals/painter.dart';
import 'package:fractals/utility_functions/fractal_tree.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double currentSlider1Value = 0;
  double currentSlider2Value = 0;
  late Offset canvasSize;
  double deltaAngle = 0;
  List<Line>? _points;
  SendPort? drawFractal;
  Timer? debounce;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      canvasSize = Offset(MediaQuery.sizeOf(context).width, 600);
      initIsolate();
    });
  }

  void initIsolate() async {
    final receivePort = ReceivePort();
    final isolate = await Isolate.spawn(generateFractal, receivePort.sendPort);
    drawFractal = await receivePort.first as SendPort;
    requestFractal();
  }

  void requestFractal() async {
    final responsePort = ReceivePort();

    drawFractal!.send({
      'sendPort': responsePort.sendPort,
      'canvasSize': canvasSize,
      'deltaAngle': deltaAngle,
    });

    final points = await responsePort.first as List<Line>;
    setState(() {
      _points = points;
    });

    responsePort.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            spacing: 10,
            children: [
              ClipRRect(
                child: Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: 600,
                  child: CustomPaint(
                    painter: _points == null ? null : Painter(points: _points!),
                  ),
                ),
              ),
              Column(
                children: [
                  Slider(
                    min: -180,
                    max: 180,
                    divisions: 360,
                    label: currentSlider1Value.round().toString(),
                    value: currentSlider1Value,
                    onChanged: (value) {
                      setState(() {
                        currentSlider1Value = value;
                        deltaAngle = value;
                        requestFractal();
                      });
                    },
                  ),
                  Slider(
                    label: currentSlider2Value.toString(),
                    value: currentSlider2Value,
                    onChanged: (value) {
                      setState(() {
                        currentSlider2Value = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void generateFractal(SendPort mainSendPort) {
  final port = ReceivePort();
  mainSendPort.send(port.sendPort);

  port.listen((args) {
    final int branchLength = 90;
    final deltaAngle = args['deltaAngle'];
    final Offset canvasSize = args['canvasSize'];
    SendPort response = args['sendPort'];

    Offset lastPoint = Offset(
      (canvasSize.dx / 2) - 20,
      (canvasSize.dy - 1) - branchLength,
    );

    final points = fractalTree(
      lastPoint: lastPoint,
      branchLength: branchLength,
      deltaAngle: deltaAngle,
      angle: 90,
      points: [],
    );
    response.send(points);
  });
}
