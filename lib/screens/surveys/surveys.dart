import 'package:uia/core/constants/app_colors.dart';
import 'package:uia/screens/surveys/components/webview.dart';
import 'package:uia/test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

import 'package:flutter_pollfish/flutter_pollfish.dart';

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
          DropdownButton<String>(
            value: 'Select Age',
            items: <String>['Select Age', '4-6 Years', '7-11 Years', '12-15 Years'].map((String value) {
              return DropdownMenuItem<String>(

                value: value,
                child: Text(value),
              );
            }).toList(),
            style: TextStyle(
                color: Colors.black
            ),
            onChanged: (_) {},
          ),
          Expanded(
            child: GridView(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
              ),
              children: [

                SurveyTile(
                    'MineSweeper',
                    'Good Links vs Bad Links',
                    'assets/images/pollfish.png', () {

                }),
                SurveyTile('PacMan', 'Virus Protection',
                    'assets/images/pollfish.png', () {
                      _launchURL(context,
                          'https://offers.cpx-research.com/index.php?app_id=11003&ext_user_id=vkumarsaraswat@gmail.com&username=vkumarsaraswat@gmail.com&email=vkumarsaraswat@gmail.com');
                    }),

                SurveyTile('Plants vs Zombies', 'Cyber Crimes Learning',
                    'assets/images/pollfish.png', () {
                      _launchURL(context,
                          'https://surveywall.wannads.com?apiKey=62977e52beb71489487945&userId=vkumarsaraswat@gmail.com');
                    })
                ,SurveyTile('Password Clash', 'Fight With a Friend',
                    'assets/images/pollfish.png', () {
                      _launchURL(context,
                          'https://offers.monlix.com/?appid=2909&userid=vkumarsaraswat@gmail.com');
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
