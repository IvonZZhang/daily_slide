// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:daily_slide/themes/app_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:daily_slide/widgets/pattern_pad.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:daily_slide/constants.dart' as constants;

class TrainingPageWidget extends StatefulWidget {
  const TrainingPageWidget({Key? key}) : super(key: key);

  @override
  _TrainingPageWidgetState createState() => _TrainingPageWidgetState();
}

class _TrainingPageWidgetState extends State<TrainingPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppThemeData.appBarColor,
        automaticallyImplyLeading: false,
        title: const Text(
          'Training',
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
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      color: AppThemeData.primaryBackgroundColor,
                      child: const AutoSizeText(
                        'Instructions Instructions Instructions Instructions Instructions Instructions Instructions Instructions Instructions Instructions Instructions Instructions Instructions Instructions Instructions Instructions ',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width*2/3,
                      ),
                      child: const AspectRatio(
                        aspectRatio: 1,
                        child: PatternPadStatic(
                          dimension: 3,
                          selectedColor: AppThemeData.patternDotSelectedColor,
                          notSelectedColor: AppThemeData.patternDotNotSelectedColor,
                          strokeWidth: 7,
                          showInput: true,
                          fillPoints: true,
                          pattern: [7, 6, 3, 0, 4, 1, 5],
                        ),
                      ),
                    ),
                    const Text("Pattern 8/12")
                  ],
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      var mediaQuery = MediaQuery.of(context);
                      var physicalPixelWidth = mediaQuery.size.width *
                          mediaQuery.devicePixelRatio;
                      var physicalPixelHeight = mediaQuery.size.height *
                          mediaQuery.devicePixelRatio;
                      debugPrint(
                          "mediaQuery.size.width is ${mediaQuery.size.width}");
                      debugPrint(
                          "physicalPixelWidth is $physicalPixelWidth");
                      debugPrint(
                          "mediaQuery.size.height is ${mediaQuery.size.height}");
                      debugPrint(
                          "physicalPixelHeight is $physicalPixelHeight");
                      debugPrint(
                          "mediaQuery.devicePixelRatio is ${mediaQuery.devicePixelRatio}");
                    },
                    child: const Text("SHOW ME", style: TextStyle(color: Colors.white),)),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width - 16,
                    minHeight: MediaQuery.of(context).size.width - 16,
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: FutureBuilder(
                      future: SharedPreferences.getInstance(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Text('Loading');
                        } else {
                          if (snapshot.hasData) {
                            final SharedPreferences prefs = snapshot.data as SharedPreferences;
                            double userPointRadius = prefs.getDouble(constants.userPointRadius) ?? constants.defaultPointRadius;
                            double userRelativePadding = prefs.getDouble(constants.userRelativePadding) ?? constants.defaultRelativePadding;
                            debugPrint("userPointRadius     is ${userPointRadius}\n");
                            debugPrint("userRelativePadding is ${userRelativePadding}\n");
                            return PatternPad(
                              dimension: 3,
                              relativePadding: userRelativePadding,
                              selectedColor: AppThemeData.patternDotSelectedColor,
                              notSelectedColor: AppThemeData.patternDotNotSelectedColor,
                              pointRadius: userPointRadius,
                              strokeWidth: 10,
                              showInput: true,
                              fillPoints: true,
                              onInputComplete: (List<int> pattern) =>
                                  debugPrint("pattern is ${pattern.toString()}}"),
                            );
                          } else {
                            return const Text("Something is wrong.\nPlease retry.");
                          }
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
