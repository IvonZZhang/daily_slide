// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:daily_slide/models/pattern_model.dart';
import 'package:flutter/material.dart';
import 'package:daily_slide/themes/app_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:daily_slide/widgets/pattern_pad.dart';
import 'package:provider/provider.dart';

class TrainingPageWidget extends StatefulWidget {
  const TrainingPageWidget({Key? key}) : super(key: key);

  @override
  _TrainingPageWidgetState createState() => _TrainingPageWidgetState();
}

class _TrainingPageWidgetState extends State<TrainingPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  double _currentSliderValue = 1;

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
          child: ChangeNotifierProvider(
            create: (context) => PatternModel(),
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
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: PatternPadStatic(
                            dimension: 3,
                            relativePadding: 1,
                            selectedColor: AppThemeData.patternDotSelectedColor,
                            notSelectedColor: AppThemeData.patternDotNotSelectedColor,
                            pointRadius: 14,
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
                    Text(_currentSliderValue.toStringAsFixed(2), style: const TextStyle(color: Colors.white),),
                  ],
                ),
                // Builder(
                //   builder: (context) {
                //     return Slider(
                //       value: _currentSliderValue,
                //       max: 3.0,
                //       min: 0.0,
                //       label: _currentSliderValue.toStringAsFixed(2),
                //       onChanged: (double value) {
                //         var patternModel = context.read<PatternModel>();
                //         patternModel.padding = value;
                //         setState(() {
                //           _currentSliderValue = value;
                //         });
                //       }
                //     );
                //   }
                // ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width - 16,
                      minHeight: MediaQuery.of(context).size.width - 16,
                    ),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: PatternPad(
                        dimension: 3,
                        relativePadding: 1,
                        selectedColor: AppThemeData.patternDotSelectedColor,
                        notSelectedColor: AppThemeData.patternDotNotSelectedColor,
                        pointRadius: 31.25,
                        strokeWidth: 10,
                        showInput: true,
                        fillPoints: true,
                        showDiameter: false,
                        showInterdistance: false,
                        onInputComplete: (List<int> pattern) =>
                            debugPrint("pattern is ${pattern.toString()}}"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
