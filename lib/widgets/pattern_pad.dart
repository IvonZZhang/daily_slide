import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:daily_slide/models/pattern_model.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;

Offset calcCirclePosition(
    int n, Size size, int dimension, double relativePadding) {
  final o = size.width > size.height
      ? Offset((size.width - size.height) / 2, 0)
      : Offset(0, (size.height - size.width) / 2);
  return o +
      Offset(
        size.shortestSide /
            (dimension - 1 + relativePadding * 2) *
            (n % dimension + relativePadding),
        size.shortestSide /
            (dimension - 1 + relativePadding * 2) *
            (n ~/ dimension + relativePadding),
      );
}

class PatternPad extends StatefulWidget {
  /// Count of points horizontally and vertically.
  final int dimension;

  /// Padding of points area relative to distance between points.
  final double relativePadding;

  /// Color of selected points.
  final Color? selectedColor;

  /// Color of not selected points.
  final Color notSelectedColor;

  /// Radius of points.
  final double pointRadius;

  /// Width of stroke
  final double strokeWidth;

  /// Whether show user's input and highlight selected points.
  final bool showInput;

  // Needed distance from input to point to select point.
  final int selectThreshold;

  // Whether fill points.
  final bool fillPoints;

  // Whether show a line indicating the diameter of circle
  final bool showDiameter;

  // Whether show a line indicating the interdistance between two adjascent circle
  final bool showInterdistance;

  /// Callback that called when user's input complete. Called if user selected one or more points.
  final Function(List<int>) onInputComplete;

  /// Creates [PatternPad] with given params.
  const PatternPad({
    Key? key,
    this.dimension = 3,
    this.relativePadding = 0.7,
    this.selectedColor, // Theme.of(context).primaryColor if null
    this.notSelectedColor = Colors.black45,
    this.pointRadius = 10,
    this.strokeWidth = 2,
    this.showInput = true,
    this.selectThreshold = 25,
    this.fillPoints = false,
    this.showDiameter = false,
    this.showInterdistance = false,
    required this.onInputComplete,
  }) : super(key: key);

  @override
  _PatternPadState createState() => _PatternPadState();
}

class _PatternPadState extends State<PatternPad> {
  List<int> used = [];
  Offset? currentPoint;

  ui.Image? rulerImageVertical;
  ui.Image? rulerImageHorizontal;
  bool isImageloaded = false;

  @override
  void initState() {
    super.initState();
    initImages();
  }

  Future initImages() async {
    final ByteData data = await DefaultAssetBundle.of(context).load('assets/ruler.png');
    rulerImageVertical = await loadImage(Uint8List.view(data.buffer));
    rulerImageHorizontal = await rotatedImage(image: rulerImageVertical!, angle: 1.574);
  }

  Future<ui.Image> loadImage(Uint8List img) async {
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(img, (ui.Image img) {
      setState(() {
        isImageloaded = true;
      });
      return completer.complete(img);
    });
    return completer.future;
  }

  Future<ui.Image> rotatedImage({required ui.Image image, required double angle}) {
    var pictureRecorder = ui.PictureRecorder();
    Canvas canvas = Canvas(pictureRecorder);

    final double r =
        sqrt(image.width * image.width + image.height * image.height) / 2;
    final alpha = atan(image.height / image.width);
    final gama = alpha + angle;
    final shiftY = r * sin(gama);
    final shiftX = r * cos(gama);
    final translateX = image.width / 2 - shiftX;
    final translateY = image.height / 2 - shiftY;
    canvas.translate(translateX, translateY);
    canvas.rotate(angle);
    canvas.drawImage(image, Offset.zero, Paint());

    return pictureRecorder.endRecording().toImage(image.width, image.height);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanEnd: (DragEndDetails details) {
        if (used.isNotEmpty) {
          widget.onInputComplete(used);
        }
        setState(() {
          used = [];
          currentPoint = null;
        });
      },
      onPanUpdate: (DragUpdateDetails details) {
        RenderBox referenceBox = context.findRenderObject() as RenderBox;
        Offset localPosition =
            referenceBox.globalToLocal(details.globalPosition);

        Offset circlePosition(int n) => calcCirclePosition(
              n,
              referenceBox.size,
              widget.dimension,
              widget.relativePadding,
            );

        setState(() {
          currentPoint = localPosition;
          for (int i = 0; i < widget.dimension * widget.dimension; ++i) {
            final toPoint = (circlePosition(i) - localPosition).distance;
            if (!used.contains(i) && toPoint < widget.selectThreshold) {
              used.add(i);
            }
          }
        });
      },
      child: Consumer<PatternModel> (
        builder: (context, patternModel, child) {
          return CustomPaint(
            painter: _LockPainter(
              dimension: widget.dimension,
              used: used,
              currentPoint: currentPoint,
              relativePadding: patternModel.padding,
              selectedColor: widget.selectedColor ?? Theme.of(context).primaryColor,
              notSelectedColor: widget.notSelectedColor,
              pointRadius: widget.pointRadius,
              strokeWidth: widget.strokeWidth,
              showInput: widget.showInput,
              fillPoints: widget.fillPoints,
              showDiameter: widget.showDiameter,
              showInterdistance: widget.showInterdistance,
              rulerImageVertical: rulerImageVertical!,
              rulerImageHorizontal: rulerImageHorizontal!,
            ),
            size: Size.infinite,
          );
        }
      ),
    );
  }
}

@immutable
class _LockPainter extends CustomPainter {
  final int dimension;
  final List<int> used;
  final Offset? currentPoint;
  final double relativePadding;
  final double pointRadius;
  final double strokeWidth;
  final bool showInput;
  final bool showInterdistance;
  final bool showDiameter;

  final Paint circlePaint;
  final Paint selectedPaint;
  final Paint lineIndicatorPaint;

  final ui.Image rulerImageVertical;
  final ui.Image rulerImageHorizontal;

  static const double RULER_IMAGE_RATIO = 1.822;

  _LockPainter({
    required this.dimension,
    required this.used,
    this.currentPoint,
    required this.relativePadding,
    required Color selectedColor,
    required Color notSelectedColor,
    required this.pointRadius,
    required this.strokeWidth,
    required this.showInput,
    required bool fillPoints,
    this.showInterdistance = false,
    this.showDiameter = false,
    required this.rulerImageVertical,
    required this.rulerImageHorizontal,
  })   : circlePaint = Paint()
          ..color = notSelectedColor
          ..style = fillPoints ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
        selectedPaint = Paint()
          ..color = selectedColor
          ..style = fillPoints ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth,
        lineIndicatorPaint = Paint()
          ..color = Colors.black87
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.butt
          ..strokeWidth = 6;



  @override
  void paint(Canvas canvas, Size size) {
    Offset circlePosition(int n) =>
        calcCirclePosition(n, size, dimension, relativePadding);

    for (int i = 0; i < dimension; ++i) {
      for (int j = 0; j < dimension; ++j) {
        canvas.drawCircle(
          circlePosition(i * dimension + j),
          pointRadius,
          showInput && used.contains(i * dimension + j)
              ? selectedPaint
              : circlePaint,
        );
      }
    }

    if (showInput) {
      for (int i = 0; i < used.length - 1; ++i) {
        canvas.drawLine(
          circlePosition(used[i]),
          circlePosition(used[i + 1]),
          selectedPaint,
        );
      }

      final currentPoint = this.currentPoint;
      if (used.isNotEmpty && currentPoint != null) {
        canvas.drawLine(
          circlePosition(used[used.length - 1]),
          currentPoint,
          selectedPaint,
        );
      }
    }

    if (showDiameter) {
      canvas.drawLine(
        circlePosition(0) + Offset(-pointRadius, 0),
        circlePosition(0) + Offset(pointRadius, 0),
        lineIndicatorPaint,
      );

      paintImage(
        canvas: canvas,
        rect: Rect.fromPoints(circlePosition(0) + Offset(-pointRadius, -pointRadius-(2*pointRadius/RULER_IMAGE_RATIO)),
                              circlePosition(0) + Offset(pointRadius, (2*pointRadius/RULER_IMAGE_RATIO)-pointRadius)),
        image: rulerImageHorizontal,
        fit: BoxFit.fill
      );
    }

    if (showInterdistance) {
      canvas.drawLine(
        circlePosition(0),
        circlePosition(3),
        lineIndicatorPaint
      );

      paintImage(
        canvas: canvas,
        rect: Rect.fromPoints(circlePosition(0) + Offset(-pointRadius-(4*pointRadius/RULER_IMAGE_RATIO), 0),
                              circlePosition(3) + Offset(-pointRadius, 0)),
        image: rulerImageVertical,
        fit: BoxFit.fill
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}