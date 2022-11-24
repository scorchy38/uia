import 'package:uia/core/constants/app_colors.dart';
import 'package:uia/screens/passwordClash/start_screen.dart';
import 'package:uia/screens/surveys/components/webview.dart';
import 'package:uia/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import 'package:flutter_pollfish/flutter_pollfish.dart';

import '../../homepage.dart';
import '../game/game.dart';
import '../home_page.dart';
import '../passwordClash/startGameScreen.dart';
import 'components/item_tile.dart';

// Pollfish basic configuration options
const String androidApiKey = '4c6e23e5-77d2-461d-95c7-6a0e20be6743';
const bool releaseMode = false;

class OrderPage extends StatefulWidget {
  const OrderPage({Key? key}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String _logText = '';

  bool _showButton = false;
  bool _completedSurvey = false;
  int _currentIndex = 0;
  int _cpa = 0;

  @override
  void initState() {
    super.initState();
    initPollfish();
  }

  @override
  void dispose() {
    FlutterPollfish.instance.removeListeners();
    super.dispose();
  }

  Future<void> initPollfish() async {
    String logText = 'Initializing Pollfish...';

    _showButton = false;
    _completedSurvey = false;

    final offerwallMode = _currentIndex == 2;

    FlutterPollfish.instance.init(
        androidApiKey: androidApiKey,
        iosApiKey: 'iOSApiKey',
        rewardMode: true,
        releaseMode: releaseMode,
        offerwallMode: offerwallMode);

    FlutterPollfish.instance
        .setPollfishSurveyReceivedListener(onPollfishSurveyReceived);

    FlutterPollfish.instance
        .setPollfishSurveyCompletedListener(onPollfishSurveyCompleted);

    FlutterPollfish.instance.setPollfishOpenedListener(onPollfishOpened);

    FlutterPollfish.instance.setPollfishClosedListener(onPollfishClosed);

    FlutterPollfish.instance
        .setPollfishSurveyNotAvailableListener(onPollfishSurveyNotAvailable);

    FlutterPollfish.instance
        .setPollfishUserRejectedSurveyListener(onPollfishUserRejectedSurvey);

    FlutterPollfish.instance
        .setPollfishUserNotEligibleListener(onPollfishUserNotEligible);

    setState(() {
      _logText = logText;
    });
  }
  String age = 'Select Age';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.white,
        title: const Text("Games️", style: TextStyle(
          color: Colors.black
        ),),
        centerTitle: true,
        // leading: const Text(''),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [

          Expanded(
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
              ),
              children: [

                SurveyTile(
                    'Perfect Game',
                    'Identify the theft',
                    'assets/images/link.png',
                        '7-10',
                        () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FoodStylePage()));

                }),SurveyTile(
                    'Stranger\'s Call',
                    'OTP Skills',
                    'assets/images/wallet.png',
                    '4-6',() {
                  _launchURL(context, 'https://studio.code.org/projects/applab/XHH5FtCXrSZwFJ62G59YkjhSezR3ndrB7vPp1gkEipU');

                }),
                SurveyTile(
                    'Identify Bad Link',
                    'OTP Skills',
                    'assets/images/zombie_.png',
                    '4-6',() {
                  _launchURL(context, 'https://studio.code.org/projects/applab/pllrD1tdhlV0i03CoXc_nEjgdz8K6-v_FlRJ6JYzyX4');

                }),
                SurveyTile('Virus Run', 'Virus Protection',
                    'assets/images/virus.png',
                    '11-15',() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Home()));
                    }),

                SurveyTile('Hackers v/s Us', 'Cyber Crimes Learning',
                    'assets/images/hacker.png', '7-10', () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HP()));

                    })
                ,SurveyTile('Password Clash', 'Fight With a Friend',
                    'assets/images/clash.png',  '11-15', () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StartScreen()));
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    initPollfish();
  }

  Text findCurrentTitle(int currentIndex) {
    if (_currentIndex == 0) {
      return const Text('Pollfish Rewarded Integration');
    } else {
      return const Text('Pollfish Offerwall Integration');
    }
  }

  // Pollfish notification functions

  void onPollfishSurveyReceived(SurveyInfo? surveyInfo) => setState(() {
        if (surveyInfo == null) {
          _logText = 'Offerwall Ready';
        } else {
          _logText =
              'Survey Received: - ${surveyInfo.toString().replaceAll("\n", " ")}';
          _cpa = surveyInfo.surveyCPA ?? 0;
        }

        print(_logText);

        _completedSurvey = false;
        _showButton = true;
      });

  void onPollfishSurveyCompleted(SurveyInfo? surveyInfo) => setState(() {
        _logText = 'Survey Completed: - ${surveyInfo.toString()}';

        print(_logText);

        if (_currentIndex == 1) {
          _showButton = false;
          _completedSurvey = true;
        }
      });

  void onPollfishOpened() => setState(() {
        _logText = 'Survey Panel Open';

        print(_logText);
      });

  void onPollfishClosed() => setState(() {
        _logText = 'Survey Panel Closed';

        print(_logText);
      });

  void onPollfishSurveyNotAvailable() => setState(() {
        _logText = 'Survey Not Available';

        print(_logText);

        _showButton = false;
        _completedSurvey = false;
      });

  void onPollfishUserRejectedSurvey() => setState(() {
        _logText = 'User Rejected Survey';

        print(_logText);

        if (_currentIndex == 1) {
          _showButton = false;
          _completedSurvey = false;
        }
      });

  void onPollfishUserNotEligible() => setState(() {
        _logText = 'User Not Eligible';

        print(_logText);

        if (_currentIndex == 1) {
          _showButton = false;
          _completedSurvey = false;
        }
      });
  void _launchURL(BuildContext context, String url) async {
    try {
      await launch(
        url,

        customTabsOption: const CustomTabsOption(
          toolbarColor: AppColors.primary,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,


          // animation: CustomTabsAnimation.slideIn(),
          // // or user defined animation.
          // animation: const CustomTabsAnimation(
          //   startEnter: 'slide_up',
          //   startExit: 'android:anim/fade_out',
          //   endEnter: 'android:anim/fade_in',
          //   endExit: 'slide_down',
          // ),
          extraCustomTabs: <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
