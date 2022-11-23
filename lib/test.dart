// // import 'dart:async';
// //
// // import 'package:flutter/material.dart';
// // import 'package:flutter_pollfish/flutter_pollfish.dart';
// //
// // void main() => runApp(MyApp());
// //
// // // Pollfish basic configuration options
// // const String androidApiKey = '4c6e23e5-77d2-461d-95c7-6a0e20be6743';
// // const String iOSApiKey = 'IOS_API_KEY';
// // const bool releaseMode = false;
// //
// // class MyApp extends StatefulWidget {
// //   @override
// //   _MyAppState createState() => _MyAppState();
// // }
// //
// // class _MyAppState extends State<MyApp> {
// //   String _logText = '';
// //
// //   bool _showButton = false;
// //   bool _completedSurvey = false;
// //   int _currentIndex = 0;
// //   int _cpa = 0;
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     initPollfish();
// //   }
// //
// //   @override
// //   void dispose() {
// //     FlutterPollfish.instance.removeListeners();
// //     super.dispose();
// //   }
// //
// //   Future<void> initPollfish() async {
// //     String logText = 'Initializing Pollfish...';
// //
// //     _showButton = false;
// //     _completedSurvey = false;
// //
// //     final offerwallMode = _currentIndex == 2;
// //
// //     FlutterPollfish.instance.init(
// //         androidApiKey: androidApiKey,
// //         iosApiKey: iOSApiKey,
// //         rewardMode: true,
// //         releaseMode: releaseMode,
// //         offerwallMode: offerwallMode);
// //
// //     FlutterPollfish.instance
// //         .setPollfishSurveyReceivedListener(onPollfishSurveyReceived);
// //
// //     FlutterPollfish.instance
// //         .setPollfishSurveyCompletedListener(onPollfishSurveyCompleted);
// //
// //     FlutterPollfish.instance.setPollfishOpenedListener(onPollfishOpened);
// //
// //     FlutterPollfish.instance.setPollfishClosedListener(onPollfishClosed);
// //
// //     FlutterPollfish.instance
// //         .setPollfishSurveyNotAvailableListener(onPollfishSurveyNotAvailable);
// //
// //     FlutterPollfish.instance
// //         .setPollfishUserRejectedSurveyListener(onPollfishUserRejectedSurvey);
// //
// //     FlutterPollfish.instance
// //         .setPollfishUserNotEligibleListener(onPollfishUserNotEligible);
// //
// //     setState(() {
// //       _logText = logText;
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //           appBar: AppBar(
// //             title: findCurrentTitle(_currentIndex),
// //           ),
// //           body: Center(
// //               child: new Container(
// //                   padding: new EdgeInsets.all(20.0),
// //                   child: new Column(
// //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                       crossAxisAlignment: CrossAxisAlignment.center,
// //                       children: <Widget>[
// //                         Text('$_logText\n'),
// //                         (_showButton && !_completedSurvey)
// //                             ? new RawMaterialButton(
// //                           onPressed: () {
// //                             FlutterPollfish.instance.show();
// //                           },
// //                           child: new Text(
// //                               (_currentIndex == 0)
// //                                   ? 'Complete a Survey and Earn $_cpa Credits'
// //                                   : 'Offerwall - Take Surveys',
// //                               style: new TextStyle(
// //                                   color: Colors.white, fontSize: 16.0)),
// //                           shape: new RoundedRectangleBorder(),
// //                           elevation: 2.0,
// //                           fillColor: Colors.blue,
// //                           padding: const EdgeInsets.all(15.0),
// //                         )
// //                             : (_currentIndex % 2 == 1 &&
// //                             !_showButton &&
// //                             _completedSurvey)
// //                             ? Container(
// //                           child: new Text('You earned $_cpa Credits'),
// //                         )
// //                             : Container()
// //                       ]))),
// //           bottomNavigationBar: BottomNavigationBar(
// //               onTap: onTabTapped,
// //               currentIndex: _currentIndex,
// //               items: [
// //                 new BottomNavigationBarItem(
// //                   icon: Icon(Icons.card_giftcard),
// //                   label: 'Rewarded Survey',
// //                 ),
// //                 new BottomNavigationBarItem(
// //                     icon: Icon(Icons.local_offer), label: 'Offerwall')
// //               ])),
// //     );
// //   }
// //
// //   void onTabTapped(int index) {
// //     setState(() {
// //       _currentIndex = index;
// //     });
// //     initPollfish();
// //   }
// //
// //   Text findCurrentTitle(int currentIndex) {
// //     if (_currentIndex == 0) {
// //       return const Text('Pollfish Rewarded Integration');
// //     } else {
// //       return const Text('Pollfish Offerwall Integration');
// //     }
// //   }
// //
// //   // Pollfish notification functions
// //
// //   void onPollfishSurveyReceived(SurveyInfo? surveyInfo) => setState(() {
// //     if (surveyInfo == null) {
// //       _logText = 'Offerwall Ready';
// //     } else {
// //       _logText =
// //       'Survey Received: - ${surveyInfo.toString().replaceAll("\n", " ")}';
// //       _cpa = surveyInfo.surveyCPA ?? 0;
// //     }
// //
// //     print(_logText);
// //
// //     _completedSurvey = false;
// //     _showButton = true;
// //   });
// //
// //   void onPollfishSurveyCompleted(SurveyInfo? surveyInfo) => setState(() {
// //     _logText = 'Survey Completed: - ${surveyInfo.toString()}';
// //
// //     print(_logText);
// //
// //     if (_currentIndex == 1) {
// //       _showButton = false;
// //       _completedSurvey = true;
// //     }
// //   });
// //
// //   void onPollfishOpened() => setState(() {
// //     _logText = 'Survey Panel Open';
// //
// //     print(_logText);
// //   });
// //
// //   void onPollfishClosed() => setState(() {
// //     _logText = 'Survey Panel Closed';
// //
// //     print(_logText);
// //   });
// //
// //   void onPollfishSurveyNotAvailable() => setState(() {
// //     _logText = 'Survey Not Available';
// //
// //     print(_logText);
// //
// //     _showButton = false;
// //     _completedSurvey = false;
// //   });
// //
// //   void onPollfishUserRejectedSurvey() => setState(() {
// //     _logText = 'User Rejected Survey';
// //
// //     print(_logText);
// //
// //     if (_currentIndex == 1) {
// //       _showButton = false;
// //       _completedSurvey = false;
// //     }
// //   });
// //
// //   void onPollfishUserNotEligible() => setState(() {
// //     _logText = 'User Not Eligible';
// //
// //     print(_logText);
// //
// //     if (_currentIndex == 1) {
// //       _showButton = false;
// //       _completedSurvey = false;
// //     }
// //   });
// // }
//
// StreamController<String> androidIdController =
//     StreamController<String>.broadcast();
// Stream<String> androidIdStream = androidIdController.stream;
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//
//   bool _jailBroken = false;
//   bool _developerMode = false;
//   bool _vpnActive = false;
//
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
//   Connectivity()
//       .onConnectivityChanged
//       .listen((ConnectivityResult result) async {
//     if (result == ConnectivityResult.mobile ||
//         result == ConnectivityResult.wifi) {
//       while (true) {
//         try {
//           final internet = await InternetAddress.lookup('google.com');
//           if (internet.isNotEmpty && internet[0].rawAddress.isNotEmpty) {
//             androidIdStream.listen((String accountDeviceID) async {
//               print('New Android Id for Account : $accountDeviceID');
//               if (accountDeviceID != currentDeviceID) {
//                 await signOut();
//                 runApp(MyApp());
//               } else {
//                 try {
//                   _vpnActive = await CheckVpnConnection.isVpnActive();
//                 } catch (e) {
//                   print(e);
//                   _vpnActive = false;
//                 }
//                 try {
//                   _jailBroken = await FlutterJailbreakDetection.jailbroken;
//                   _developerMode =
//                       await FlutterJailbreakDetection.developerMode;
//                   print("Jailbreak - $_jailBroken");
//                   print("Developer - $_developerMode");
//                 } catch (e) {
//                   print(e);
//                   _jailBroken = false;
//                   _developerMode = false;
//                 }
//                 if (_jailBroken || _developerMode) {
//                   runApp(RootedDevice());
//                 } else if (_vpnActive) {
//                   runApp(VpnConnected());
//                 } else {
//                   runApp(MyApp());
//                 }
//               }
//             }, onDone: () {
//               print('Android ID Stream closed');
//             });
//             androidIdController.sink.add(currentDeviceID);
//           } else {
//             runApp(NotConnectedApp());
//           }
//         } on SocketException catch (_) {
//           runApp(NotConnectedApp());
//         }
//         await Future.delayed(Duration(seconds: 30));
//       }
//     } else {
//       runApp(NotConnectedApp());
//     }
//   });
// }
