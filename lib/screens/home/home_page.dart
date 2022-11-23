import 'package:uia/core/constants/app_colors.dart';
import 'package:uia/screens/home/components/home_options.dart';
import 'package:flutter/material.dart';
// import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../models/notifications.dart';
import '../../services/database/user_database_helper.dart';
import '../entrypoint/entrypoint_ui.dart';
import 'components/home_greetings.dart';
import 'components/home_header.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    checkForInitialMessage();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
      });
    });
    registerNotification();
    super.initState();
  }

  bool vpn = false;
  bool internet = false;
  bool root = false;
  bool developerMode = false;
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;

  Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  void registerNotification() async {
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    print('User granted permission');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');

      // Parse the message received
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
      });

      if (_notificationInfo != null) {
        // For displaying the notification as an overlay
        showSimpleNotification(
          Text(
            _notificationInfo!.title!,
            style: const TextStyle(color: Colors.black),
          ),
          leading: const NotificationBadge(totalNotifications: 1),
          subtitle: Text(
            _notificationInfo!.body!,
            style: const TextStyle(color: Colors.black),
          ),
          background: Colors.white,
          duration: Duration(seconds: 5),
        );
      }
    });
  }

  // For handling notification when the app is in terminated state
  checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      PushNotification notification = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );

      setState(() {
        _notificationInfo = notification;
      });
    }
  }


  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Exit App'),
            content: Text('Do you want to exit?'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                //return false when click on "NO"
                child: Text('No'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                //return true when click on "Yes"
                child: Text('Yes'),
              ),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        backgroundColor: AppColors.background.withOpacity(0.8),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                // HomeHeader(),
                HomeGreetings(),
                HomeOptions()
                // CategorySelection(),
                // HomeSuggestionSection(),
                // SizedBox(height: 16),
                // NearbyResturants(),
                // HomeSuggestionSection(),
                // SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
