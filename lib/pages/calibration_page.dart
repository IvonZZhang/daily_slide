// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:daily_slide/models/pattern_model.dart';
import 'package:flutter/material.dart';
import 'package:daily_slide/themes/app_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:daily_slide/widgets/pattern_pad.dart';
import 'package:provider/provider.dart';

class CalibrationPageWidget extends StatefulWidget {
  const CalibrationPageWidget({Key? key}) : super(key: key);

  @override
  _CalibrationPageWidgetState createState() => _CalibrationPageWidgetState();
}

class _CalibrationPageWidgetState extends State<CalibrationPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppThemeData.appBarColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Fit to your phone',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: AppThemeData.appBarTextColor,
            fontSize: 22,
          ),
        ),
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: AppThemeData.primaryBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ChangeNotifierProvider(
            create: (context) => PatternModel(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox.square(
                  child: const Text("a"),
                ),
                ListView(
                  children: const [
                    ListTile(
                      title: Text("Something"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
