// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:daily_slide/models/pattern_model.dart';
import 'package:flutter/material.dart';
import 'package:daily_slide/themes/app_theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:daily_slide/constants.dart' as constants;
import 'package:daily_slide/widgets/pattern_pad.dart';
import 'package:provider/provider.dart';

class CalibrationPageWidget extends StatefulWidget {
  const CalibrationPageWidget({Key? key}) : super(key: key);

  @override
  _CalibrationPageWidgetState createState() => _CalibrationPageWidgetState();
}

class _CalibrationPageWidgetState extends State<CalibrationPageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _lastPage = 1;

  static const double diameterSliderMin = 10.0;
  static const double diameterSliderMax = 50.0;
  static const double interdistanceSliderMin = 0.1;
  static const double interdistanceSliderMax = 3.0;
  double _diameterSliderValue = constants.defaultPointRadius;
  double _interdistanceSliderValue = interdistanceSliderMax - constants.defaultRelativePadding;

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
            create: (context) => PatternModel()..init(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6,
                  child: SizedBox.square(
                    child: Consumer(
                      builder: (context, patternModel, child) {
                        return PatternPadStatic(
                          dimension: 3,
                          selectedColor: AppThemeData.patternDotSelectedColor,
                          notSelectedColor: AppThemeData.patternDotNotSelectedColor,
                          strokeWidth: 10,
                          pointRadius: context.watch<PatternModel>().radius,
                          relativePadding: context.watch<PatternModel>().padding,
                          showInput: context.watch<PatternModel>().toShowDiameter,
                          showInterdistance: context.watch<PatternModel>().toShowInterdistance,
                        );
                      }
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: PageView(
                    controller: _pageController,
                    // Disable page navigation via swipe
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Column( // Page 1: Intro
                        children: [
                          const Text("Please take a ruler and follow the instructions to fit the pattern to the size of your screen."),
                        ],
                      ),
                      Column( // Page 2: Diameter
                        // mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: Cross,
                        children: [
                          const Text("Please adjust the diameter to 1 cm."),
                          Builder(
                            builder: (context) {
                              return Slider(
                                min: diameterSliderMin,
                                max: diameterSliderMax,
                                value: _diameterSliderValue,
                                onChanged: (double value) {
                                  var patternModel = context.read<PatternModel>();
                                  patternModel.radius = value;
                                  setState(() {
                                    _diameterSliderValue = value;
                                  });
                                },
                              );
                            }
                          )
                        ],
                      ),
                      Column( // Page 3: Inter-distance
                        children: [
                          const Text("Please adjust the distance to 1.3 cm."),
                          Builder(
                            builder: (context) {
                              return Slider(
                                min: 0,
                                max: interdistanceSliderMax - interdistanceSliderMin,
                                value: _interdistanceSliderValue,
                                onChanged: (double value) {
                                  var patternModel = context.read<PatternModel>();
                                  patternModel.padding = interdistanceSliderMax - value;
                                  setState(() {
                                    _interdistanceSliderValue = value;
                                  });
                                },
                              );
                            }
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Ink(
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(),
                          color: Colors.blueGrey,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton.icon(
                            onPressed: _currentPage != 0 ? () {
                              _pageController.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                              setState(() {
                                _currentPage--;
                              });
                              var patternModel = context.read<PatternModel>();
                              if (_currentPage == 0) {
                                patternModel.toShowInterdistance = false;
                                patternModel.toShowDiameter = false;
                              } else if (_currentPage == 1) {
                                patternModel.toShowInterdistance = false;
                                patternModel.toShowDiameter = true;
                              }
                            } : null,
                            icon: const Icon(Icons.arrow_back_ios),
                            label: const Text("PREVIOUS"),
                          ),
                        ),
                      ),
                      Ink(
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(),
                          color: Colors.blueGrey,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton.icon(
                            onPressed: _currentPage != _lastPage ? () {
                              _pageController.nextPage(curve: Curves.easeIn, duration: const Duration(milliseconds: 200));
                              setState(() {
                                _currentPage++;
                              });
                              var patternModel = context.read<PatternModel>();
                              if (_currentPage == 1) {
                                patternModel.toShowInterdistance = false;
                                patternModel.toShowDiameter = true;
                              } else if (_currentPage == 2) {
                                patternModel.toShowInterdistance = true;
                                patternModel.toShowDiameter = false;
                              }
                            } : () {
                              debugPrint("Configuration finished!");
                              Navigator.pop(context);
                            },
                            icon: Icon(_currentPage == _lastPage ? Icons.check : Icons.arrow_forward_ios),
                            label: _currentPage == _lastPage ? const Text("FINISH") : const Text("NEXT"),
                          ),
                        ),
                      ),
                    ],
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
