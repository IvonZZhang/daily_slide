import 'package:flutter/foundation.dart';

class PatternModel extends ChangeNotifier {
  double relativePadding = 1;

  double get padding => relativePadding;

  set padding(double padding) {
    relativePadding = padding;
    notifyListeners();
  }
}