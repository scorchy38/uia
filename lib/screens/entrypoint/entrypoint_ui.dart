import 'dart:developer';

import 'package:animations/animations.dart';
import 'package:uia/core/constants/app_colors.dart';
import 'package:uia/screens/profile/components/leaderboard.dart';
import 'package:uia/services/database/user_database_helper.dart';
import 'package:uia/wrappers/authentication_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/notifications.dart';
import '../../services/authentication/authentication_service.dart';
import '../auth/error_page.dart';
import '../game/game.dart';
import '../home/home_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';
import '../profile/profile_page.dart';
import '../surveys/surveys.dart';

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

class EntryPointUI extends StatefulWidget {
  const EntryPointUI({Key? key}) : super(key: key);

  @override
  State<EntryPointUI> createState() => _EntryPointUIState();
}

class _EntryPointUIState extends State<EntryPointUI> {
  int _currentPage = 0;
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;

  _onMenuChanged(int v) {
    _currentPage = v;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    AuthenticationService().setLocalAuthStatus('LoggedIn');
    checkForInitialMessage();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      PushNotification notification = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );
      log(message.data['title']);
      log(message.data['body']);

      setState(() {
        _notificationInfo = notification;
      });
    });
    registerNotification();
  }

  bool vpn = false;
  bool internet = false;

  void registerNotification() async {
    _messaging = FirebaseMessaging.instance;

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
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
    } else {
      print('User declined or has not accepted permission');
    }
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

  bool root = false;
  bool developerMode = false;

  final List<Widget> _screens = [
    const HomePage(),
     Scaffold(
      appBar: AppBar(
        title: Text("Videos"),
      ),
    ),
    // const FoodStylePage(),
    const Leaderboard(),
    const Scaffold(),

    // const OrderPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    if (!vpn && !internet && !root && developerMode || true) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageTransitionSwitcher(
          transitionBuilder: ((child, primaryAnimation, secondaryAnimation) =>
              SharedAxisTransition(
                animation: primaryAnimation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                child: child,
              )),
          child: _screens[_currentPage],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: _onMenuChanged,
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.dice,
                    color: _currentPage == 0 ? AppColors.primary : Colors.grey),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.video,
                    color: _currentPage == 1 ? AppColors.primary : Colors.grey),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.trophy,
                    color: _currentPage == 2 ? AppColors.primary : Colors.grey),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.book,
                    color: _currentPage == 3 ? AppColors.primary : Colors.grey),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(FontAwesomeIcons.user,
                    color: _currentPage == 4 ? AppColors.primary : Colors.grey),
              ),
              label: '',
            ),
          ],
        ),
      );
    } else {
      return ErrorPage(
        vpn: vpn,
        developerMode: developerMode,
        internet: internet,
        root: root,
        deviceIdCheck: true,
        // activatedCheck: true,
        // updateCheck: true,
      );
    }
  }
}

class NotificationBadge extends StatelessWidget {
  final int totalNotifications;

  const NotificationBadge({required this.totalNotifications});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      child: const CircleAvatar(
        backgroundImage: AssetImage('assets/dice/logo.png'),
      ),
    );
  }
}
