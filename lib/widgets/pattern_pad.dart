import 'package:flutter/material.dart';
import 'package:daily_slide/models/pattern_model.dart';
import 'package:provider/provider.dart';

final Paint lineIndicatorPaint = Paint()
          ..color = Colors.black87
          ..style = PaintingStyle.fill
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 4;

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

void drawLineSegmentWithArrow(Canvas canvas, Offset p1, Offset p2, bool horizontal, {String labelText="", double arrowLength=10}) {
  const double labelFontSize = 20;

  const labelStyle = TextStyle(
    color: Colors.black,
    fontSize: labelFontSize,
    fontWeight: FontWeight.bold,
  );

  final labelSpan = TextSpan(
    text: labelText,
    style: labelStyle,
  );

  final labelPainter = TextPainter(
    text: labelSpan,
    textDirection: TextDirection.ltr
  );

  labelPainter.layout(
    minWidth: 0,
    maxWidth: labelFontSize*labelText.length
  );

  canvas.drawLine(p1, p2, lineIndicatorPaint);
  if (horizontal) {
    // Two arrows
    canvas.drawLine(p1, p1 + Offset(arrowLength, arrowLength), lineIndicatorPaint);
    canvas.drawLine(p1, p1 + Offset(arrowLength, -arrowLength), lineIndicatorPaint);
    canvas.drawLine(p2, p2 + Offset(-arrowLength, arrowLength), lineIndicatorPaint);
    canvas.drawLine(p2, p2 + Offset(-arrowLength, -arrowLength), lineIndicatorPaint);

    // Label text
    labelPainter.paint(canvas, p1 + Offset(arrowLength - 2, -arrowLength - labelFontSize - 2));
  } else {
    // Two arrows
    canvas.drawLine(p1, p1 + Offset(arrowLength, arrowLength), lineIndicatorPaint);
    canvas.drawLine(p1, p1 + Offset(-arrowLength, arrowLength), lineIndicatorPaint);
    canvas.drawLine(p2, p2 + Offset(arrowLength, -arrowLength), lineIndicatorPaint);
    canvas.drawLine(p2, p2 + Offset(-arrowLength, -arrowLength), lineIndicatorPaint);

    // Label text
    labelPainter.paint(canvas, Offset(p1.dx + labelFontSize/2, (p1.dy+p2.dy)/2 - labelFontSize/2));
  }
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
              pointRadius: patternModel.radius,
              strokeWidth: widget.strokeWidth,
              showInput: widget.showInput,
              fillPoints: widget.fillPoints,
              showDiameter: widget.showDiameter,
              showInterdistance: widget.showInterdistance,
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
  })   : circlePaint = Paint()
          ..color = notSelectedColor
          ..style = fillPoints ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeWidth = strokeWidth,
        selectedPaint = Paint()
          ..color = selectedColor
          ..style = fillPoints ? PaintingStyle.fill : PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth;

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
      drawLineSegmentWithArrow(
        canvas,
        circlePosition(0) + Offset(-pointRadius, -pointRadius),
        circlePosition(0) + Offset(pointRadius, -pointRadius),
        true,
        labelText: "1 cm",
      );
    }

    if (showInterdistance) {
      drawLineSegmentWithArrow(
        canvas,
        circlePosition(0),
        circlePosition(3),
        false,
        labelText: "1.3 cm",
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class PatternPadStatic extends StatelessWidget {
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

  /// Pattern to show statically
  final List<int> pattern;

  /// Creates [PatternPadStatic] with given params.
  const PatternPadStatic({
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
    this.pattern = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _LockPainter(
        dimension: dimension,
        used: pattern,
        relativePadding: relativePadding,
        selectedColor: selectedColor ?? Theme.of(context).primaryColor,
        notSelectedColor: notSelectedColor,
        pointRadius: pointRadius,
        strokeWidth: strokeWidth,
        showInput: showInput,
        fillPoints: fillPoints,
        showDiameter: false,
        showInterdistance: false,
      ),
      size: Size.infinite,
    );
  }
}