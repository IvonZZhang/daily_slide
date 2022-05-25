import 'package:flutter/material.dart';
import 'themes/app_theme.dart';
import 'package:daily_slide/pages/home_page.dart';
import 'package:daily_slide/pages/training_page.dart';
import 'package:daily_slide/pages/calibration_page.dart';

void main() {
  runApp(const DailySlideApp());
}

// const ColorScheme myColorScheme = ColorScheme(
//   brightness: Brightness.dark,
//   primary: Color(0xFF90CAF9),
//   onPrimary: Color(0xFFFF5963), // TODO
//   secondary: Color(0xFF39D2C0),
//   onSecondary: Color(0xFF39D2CC), // TODO
//   tertiary: Color(0xFFEE8B60),
//   error: Colors.red,
//   onError: Colors.redAccent,
//   background: Color(0xFF5c5c5c),
//   onBackground: Color(0xFF1D2429),
//   surface: Colors.white,
//   onSurface: Colors.white38
// );

// const TextTheme myTextTheme = TextTheme(
//   titleLarge:
// )

class DailySlideApp extends StatelessWidget {
  const DailySlideApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Slide',
      theme: AppThemeData.lightThemeData,
      darkTheme: AppThemeData.darkThemeData,
      // home: HomePageWidget(key: key),
      // home: TrainingPageWidget(key: key),
      home: CalibrationPageWidget(key: key),
    );
  }
}