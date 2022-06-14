import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:daily_slide/constants.dart' as constants;

class PatternModel extends ChangeNotifier {

  double relativePadding = constants.defaultRelativePadding;
  double pointRadius = constants.defaultPointRadius;
  bool   showDiameter = false;
  bool   showInterdistance = false;

  void init() async {
    final prefs = await SharedPreferences.getInstance();
    relativePadding = prefs.getDouble(constants.userRelativePadding) ?? constants.defaultRelativePadding;
    pointRadius = prefs.getDouble(constants.userPointRadius) ?? constants.defaultPointRadius;
    showDiameter = prefs.getBool('userShowDiameter') ?? false;
    showInterdistance = prefs.getBool('userInterdistance') ?? false;
    notifyListeners();
  }

  void updateSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(constants.userRelativePadding, relativePadding);
    prefs.setDouble(constants.userPointRadius, pointRadius);
    prefs.setBool('userShowDiameter', showDiameter);
    prefs.setBool('userInterdistance', showInterdistance);
  }

  double get padding => relativePadding;

  set padding(double padding) {
    relativePadding = padding;
    updateSharedPreferences();
    notifyListeners();
  }

  double get radius => pointRadius;

  set radius(double radius) {
    pointRadius = radius;
    updateSharedPreferences();
    notifyListeners();
  }

  bool get toShowDiameter => showDiameter;

  set toShowDiameter(bool toShow) {
    showDiameter = toShow;
    updateSharedPreferences();
    notifyListeners();
  }

  bool get toShowInterdistance => showInterdistance;

  set toShowInterdistance(bool toShow) {
    showInterdistance = toShow;
    updateSharedPreferences();
    notifyListeners();
  }
}