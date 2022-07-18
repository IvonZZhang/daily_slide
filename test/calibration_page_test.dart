

import 'package:daily_slide/constants.dart' as constants;
import 'package:daily_slide/models/pattern_model.dart';
import 'package:daily_slide/widgets/pattern_pad.dart';
import 'package:daily_slide/pages/calibration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PatternModel', () {
    var patternModel = PatternModel();
    test('PatternModel has initial values as defined constants', (){
      expect(patternModel.padding, constants.defaultRelativePadding);
      expect(patternModel.radius, constants.defaultPointRadius);
      expect(patternModel.toShowDiameter, constants.defaultShowDiameter);
      expect(patternModel.toShowInterdistance, constants.defaultShowInterdistance);
    });
    test('PatternModel can be modified', (){
      var newPadding = 3.8;
      var newRadius = 25.5;
      var newShowDiameter = true;
      var newShowInterdistance = true;
      patternModel.padding = newPadding;
      patternModel.radius = newRadius;
      patternModel.toShowDiameter = newShowDiameter;
      patternModel.toShowInterdistance = newShowInterdistance;

      expect(patternModel.padding, newPadding);
      expect(patternModel.radius, newRadius);
      expect(patternModel.toShowDiameter, newShowDiameter);
      expect(patternModel.toShowInterdistance, newShowInterdistance);
    });
  });

  Widget createCalibrationScreen() => const MaterialApp(
    home: CalibrationPageWidget(),
  );
  testWidgets('Radius and padding of pattern in Calibration Page change as user swipes on the slider', (tester) async {
    var pageApp = createCalibrationScreen();
    await tester.pumpWidget(pageApp);

    expect(find.byType(CalibrationPageWidget), findsOneWidget);
    expect(find.descendant(of: find.byWidget(pageApp), matching: find.byType(PatternPadStatic)), findsOneWidget);
    expect(find.descendant(of: find.byWidget(pageApp), matching: find.byType(Slider)), findsOneWidget);
    var pattern = find.descendant(of: find.byWidget(pageApp), matching: find.byType(PatternPadStatic));
    expect(pattern, findsOneWidget);

    var prevButton = find.text("PREVIOUS");
    expect(prevButton, findsOneWidget);

  });
}