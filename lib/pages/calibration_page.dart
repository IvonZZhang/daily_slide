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

  final PageController _pageController = PageController();
  int _currentPage = 0;

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
                Expanded(
                  flex: 6,
                  child: SizedBox.square(
                    child: PatternPad(
                      dimension: 3,
                      relativePadding: 1,
                      selectedColor: AppThemeData.patternDotSelectedColor,
                      notSelectedColor: AppThemeData.patternDotNotSelectedColor,
                      pointRadius: 31.25,
                      strokeWidth: 10,
                      showInput: true,
                      fillPoints: true,
                      showDiameter: _currentPage==0,
                      showInterdistance: _currentPage==1,
                      onInputComplete: (List<int> pattern) =>
                          debugPrint("pattern is ${pattern.toString()}}"),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Column( // Page 1: Diameter
                        // mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: Cross,
                        children: [
                          const Text("Please adjust the diameter to 1 cm."),
                          Slider(value: 1, onChanged: (double value) {}, )
                        ],
                      ),
                      Column( // Page 2: Inter-distance
                        children: [
                          const Text("Please adjust the distance to 1.3 cm."),
                          Slider(value: 1, onChanged: (double value) {})
                        ],
                      ),
                      Column( // Page 3: Something else
                        children: [
                          const Text("Please adjust something else."),
                          Slider(value: 1, onChanged: (double value) {})
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
                          shape: CircleBorder(),
                          color: Colors.blueGrey,
                        ),
                        child: IconButton(
                          onPressed: (){
                            _pageController.previousPage(duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
                            setState(() {
                              _currentPage--;
                            });
                          },
                          icon: const Icon(Icons.arrow_back),
                          color: Colors.blueAccent,
                        ),
                      ),
                      IconButton(
                        onPressed: (){
                          _pageController.nextPage(curve: Curves.easeIn, duration: const Duration(milliseconds: 200));
                          setState(() {
                            _currentPage++;
                          });
                        },
                        icon: const Icon(Icons.arrow_forward),
                        color: Colors.blueAccent,
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
