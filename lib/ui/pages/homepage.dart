import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:fractals/services/fractal_isolate.dart';
import 'package:fractals/models/line.dart';
import 'package:fractals/ui/painters/painter.dart';

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
  double depth = 0;
  List<Line>? _points;
  SendPort? drawFractal;
  late FractalIsolate isolate;
  late Future<void> isolateInitialized;

  @override
  void initState() {
    super.initState();
    canvasSize = Offset.zero;
    isolate = FractalIsolate(canvasSize: canvasSize);
    isolateInitialized = isolate.initIsolate();
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
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return FutureBuilder(
                        future: isolateInitialized,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            try {
                              isolate.canvasSize = Offset(
                                constraints.maxWidth,
                                constraints.maxHeight,
                              );
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          }
                          return CustomPaint(
                            painter: _points == null
                                ? null
                                : Painter(points: _points!),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Text('Angle'),
                      Expanded(
                        child: Slider(
                          min: -180,
                          max: 180,
                          divisions: 360,
                          label: currentSlider1Value.round().toString(),
                          value: currentSlider1Value,
                          onChanged: (value) {
                            setState(() {
                              currentSlider1Value = value;
                              isolate.deltaAngle = value;
                            });
                            isolate.requestFractal((data) {
                              setState(() {
                                _points = data;
                              });
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Text('Depth'),
                      Expanded(
                        child: Slider(
                          min: 0,
                          max: 12,
                          divisions: 12,
                          value: currentSlider2Value,
                          onChanged: (value) {
                            setState(() {
                              currentSlider2Value = value;
                              isolate.depth = value;
                            });
                            isolate.requestFractal((data) {
                              setState(() {
                                _points = data;
                              });
                            });
                          },
                        ),
                      ),
                    ],
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
