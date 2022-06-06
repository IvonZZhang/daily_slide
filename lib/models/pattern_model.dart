import 'package:flutter/foundation.dart';

class PatternModel extends ChangeNotifier {
  double relativePadding = 1;
  double pointRadius = 31.25;

  double get padding => relativePadding;

  set padding(double padding) {
    relativePadding = padding;
    notifyListeners();
  }

  double get radius => pointRadius;

  set radius(double radius) {
    pointRadius = radius;
    notifyListeners();
  }
}