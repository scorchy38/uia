import 'package:uia/core/constants/app_colors.dart';
import 'package:uia/core/themes/app_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_colors.dart';

class VPNError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lucky Dice',
      theme: AppThemes.light,
      home: ErrorPage(
          vpn: true,
          internet: true,
          developerMode: false,
          root: false,
          deviceIdCheck: true),
    );
  }
}

class InternetError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lucky Dice',
      theme: AppThemes.light,
      home: ErrorPage(
          vpn: true,
          internet: false,
          developerMode: false,
          root: false,
          deviceIdCheck: true),
    );
  }
}

class DeveloperError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lucky Dice',
      theme: AppThemes.light,
      home: ErrorPage(
          vpn: true,
          internet: true,
          developerMode: true,
          root: false,
          deviceIdCheck: true),
    );
  }
}

//pushing
class ErrorPage extends StatefulWidget {
  const ErrorPage({
    Key? key,
    required this.vpn,
    required this.internet,
    required this.developerMode,
    required this.root,
    required this.deviceIdCheck,
    // required this.activatedCheck,
    // required this.updateCheck
  }) : super(key: key);

  final bool vpn;
  final bool internet;
  final bool developerMode;
  final bool root;
  final bool deviceIdCheck;
  // final bool activatedCheck;
  // final bool updateCheck;

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        color: Colors.white,
        child:
            // widget.updateCheck == true
            //     ?
            // Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Image.asset(
            //             'assets/illustration/update.png',
            //             height: MediaQuery.of(context).size.height * 0.4,
            //           ),
            //           SizedBox(
            //             height: MediaQuery.of(context).size.height * 0.1,
            //           ),
            //           Padding(
            //             padding: const EdgeInsets.symmetric(horizontal: 40),
            //             child: Text(
            //               'A new update is available on Play store.\nPlease update app to continue playing game.',
            //               style: TextStyle(
            //                   fontSize: 21,
            //                   color: Colors.black,
            //                   fontWeight: FontWeight.bold),
            //               textAlign: TextAlign.center,
            //             ),
            //           ),
            //           SizedBox(
            //             height: MediaQuery.of(context).size.height * 0.05,
            //           ),
            //           Container(
            //             height: MediaQuery.of(context).size.height * 0.05,
            //             width: MediaQuery.of(context).size.width * 0.725,
            //             decoration: const BoxDecoration(
            //                 borderRadius: BorderRadius.all(Radius.circular(10)),
            //                 color: AppColors.orange),
            //             child: Center(
            //               child: Text('Update App',
            //                   style: Theme.of(context)
            //                       .textTheme
            //                       .headline6
            //                       ?.copyWith(
            //                           color: Colors.white,
            //                           fontSize: 16,
            //                           fontWeight: FontWeight.bold)),
            //             ),
            //           ),
            //         ],
            //       )
            //     :
            // widget.activatedCheck == false ?
            // Column(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           Image.asset(
            //             'assets/illustration/logout_from_device.png',
            //             height: MediaQuery.of(context).size.height * 0.4,
            //           ),
            //           SizedBox(
            //             height: MediaQuery.of(context).size.height * 0.1,
            //           ),
            //           Padding(
            //             padding: const EdgeInsets.symmetric(horizontal: 40),
            //             child: Text(
            //               'Your account is not activated yet.\nPlease download Lucky Dice Activator app to continue playing game.',
            //               style: TextStyle(
            //                   fontSize: 21,
            //                   color: Colors.white,
            //                   fontWeight: FontWeight.bold),
            //               textAlign: TextAlign.center,
            //             ),
            //           )
            //         ],
            //       ) :
            widget.deviceIdCheck == false
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/illustration/logout_from_device.png',
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          'Your account is logged in on another device.\nPlease logout from previous device to continue earning rewards!',
                          style: TextStyle(
                              fontSize: 21,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  )
                : widget.internet == false
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/illustration/internet_required.svg',
                            height: MediaQuery.of(context).size.height * 0.4,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Text(
                              'Internet Connection is required to play Lucky Dice.\nPlease connect to a stable internet connection to continue earning rewards!',
                              style: TextStyle(
                                  fontSize: 21,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      )
                    : widget.developerMode == true || widget.root == true
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/illustration/dev_options.svg',
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                  'Your device is rooted or has developer options enabled.\nPlease unroot your mobile or disable developer options to continue earning rewards!',
                                  style: TextStyle(
                                      fontSize: 21,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/illustration/vpn_enabled.png',
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Text(
                                  'A VPN connection has been detected on your device.\nPlease disconnect from VPN and connect to another internet connection to continue earning rewards!',
                                  style: TextStyle(
                                      fontSize: 21,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
      ),
    );
  }
}
