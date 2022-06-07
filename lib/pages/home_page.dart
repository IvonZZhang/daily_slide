import 'package:flutter/material.dart';
import 'package:daily_slide/themes/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
    // textStyle: const TextStyle(fontSize: 20, color: AppThemeData.primaryBodyTextColor),
    textStyle: GoogleFonts.lato(textStyle: const TextStyle(fontSize: 20, color: AppThemeData.primaryBodyTextColor)),
    minimumSize: const Size.fromHeight(50),
    primary: AppThemeData.buttonColor,
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: AppThemeData.appBarColor,
        iconTheme: const IconThemeData(
          color: AppThemeData.appBarTextColor,
        ),
        automaticallyImplyLeading: true,
        title: Text(
          'Daily Slide',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontFamily: 'Poppins',
                color: AppThemeData.appBarTextColor,
              ),
        ),
        actions: const [],
        centerTitle: false,
        elevation: 4,
      ),
      backgroundColor: AppThemeData.primaryBackgroundColor,
      drawer: Drawer(
        elevation: 16,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
          decoration: const BoxDecoration(
            color: AppThemeData.primaryBackgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.network(
                'https://picsum.photos/seed/887/600',
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.24,
                fit: BoxFit.cover,
              ),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.settings,
                          color: AppThemeData.primaryBodyIconColor,
                        ),
                        title: Text("Settings", style: TextStyle(color: AppThemeData.primaryBodyTextColor),),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: ListTile(
                        leading: const Icon(
                          Icons.settings,
                          color: AppThemeData.primaryBodyIconColor,
                        ),
                        title: const Text("Fit to my screen", style: TextStyle(color: AppThemeData.primaryBodyTextColor),),
                        onTap: () {
                          Navigator.pushNamed(context, '/calibration');
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: ListTile(
                        leading: Icon(
                          Icons.arrow_back,
                          color: AppThemeData.primaryBodyIconColor,
                        ),
                        title: Text('Close', style: TextStyle(color: AppThemeData.primaryBodyTextColor),),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AppThemeData.primaryBackgroundColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 5.0, color: Colors.white),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: SizedBox(
                        width: 40.0,
                        height: 400.0,
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.lightBlue,
                            shape: BoxShape.rectangle,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: AppThemeData.primaryBackgroundColor,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            debugPrint('Button pressed ...');
                          },
                          child: const Text('Daily Training'),
                          style: _buttonStyle,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            debugPrint('Button pressed ...');
                          },
                          child: const Text('Training History'),
                          style: _buttonStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
