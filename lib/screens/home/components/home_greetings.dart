import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:uia/main.dart';
import 'package:uia/screens/game/game.dart';
import 'package:uia/services/current_user_change_notifier.dart';
import 'package:uia/services/data_streams/user_stream.dart';
import 'package:uia/services/database/user_database_helper.dart';
import 'package:emojis/emoji.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import '../../../core/constants/constants.dart';
import '../../../models/User.dart';
import '../../../services/authentication/authentication_service.dart';
import '../../entrypoint/entrypoint_ui.dart';
import '../../profile/components/wallet.dart';

class HomeGreetings extends StatefulWidget {
  const HomeGreetings({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeGreetings> createState() => _HomeGreetingsState();
}

class _HomeGreetingsState extends State<HomeGreetings> {
  final UserStream userStream = UserStream();
  // StreamingSharedPreferences? preferences;
  initialize() async {
    String status = await AuthenticationService().getLocalAuthStatus();
    if (status == 'LoggedIn') currentUserChangeNotifier.setCurrentUser(true);
  }

  @override
  void initState() {
    super.initState();

    initialize();
    userStream.init();
  }

  @override
  void dispose() {
    userStream.dispose();

    super.dispose();
  }

  bool vpn = false;
  bool internet = false;
  bool root = false;
  bool developerMode = false;

  @override
  Widget build(BuildContext context) {
    // getSecurityStatus();

    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: PreferenceBuilder<bool>(
          preference: preferences!.getBool('securityCheck', defaultValue: true),
          builder: (BuildContext context, bool counter) {
            print('Sec Check ${counter}');
            return AnimatedBuilder(
              animation: currentUserChangeNotifier,
              builder: (context, child) {
                String? url = AuthenticationService().currentUser?.photoURL ??
                    "https://www.alchinlong.com/wp-content/uploads/2015/09/sample-profile.png";
                return currentUserChangeNotifier.currentUserData == null
                    ? Container(
                        child: Center(
                          child: Text('Loading...'),
                        ),
                      )
                    : Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    preferences!
                                        .setBool('securityCheck', false);
                                  },
                                  child: CircleAvatar(
                                    backgroundColor: AppColors.primary,
                                    radius: 43,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(url!),
                                      radius: 40,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 30),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Welcome, ${currentUserChangeNotifier.currentUserData!.name.split(" ")[0]}!",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            ?.copyWith(
                                                color: AppColors.primary,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.025,
                                                fontWeight: FontWeight.bold)),
                                    currentUserChangeNotifier
                                                .currentUserData!.activated ==
                                            true
                                        ? InkWell(
                                            onTap: () {
                                              launch("https://stormy-walnut-516.notion.site/Cyber-Wiki-ed6a114b6703457580f97bc769581945");
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             const Wallet()));
                                            },
                                            child: Card(
                                              elevation: 3,
                                              color: AppColors.primary,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 10),
                                                child: Container(
                                                  height: 15,
                                                  child: Center(
                                                    child: Text(
                                                        "Quick Glossary 🔡",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline6
                                                            ?.copyWith(
                                                                color: AppColors
                                                                    .text,
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Row(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.3,
                                                child: Text(
                                                  currentUserChangeNotifier
                                                      .currentUserData!.uid,
                                                  style: TextStyle(
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Clipboard.setData(ClipboardData(
                                                      text:
                                                          "${currentUserChangeNotifier.currentUserData!.uid}"));
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          'User Id Copied to Clipboard!');
                                                },
                                                child: Icon(
                                                  Icons.copy,
                                                  color: Colors.grey,
                                                  size: 15,
                                                ),
                                              ),
                                            ],
                                          )
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            Container(
                              height: 80,
                              width: double.infinity,
                              // (MediaQuery.of(context).size.width / 2) * 0.75
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.42,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0, vertical: 15),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                    // "${currentUserChangeNotifier.currentUserData!.userRank}",
                                                  "1st",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        ?.copyWith(
                                                            color: Colors.amber,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                Text("Rank",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        ?.copyWith(
                                                            fontSize: 16,
                                                            color: Colors.amber,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                                // "🪙",
                                                "🥇",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.copyWith(
                                                        fontSize: 30,
                                                        color:
                                                            AppColors.primary,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(color: Colors.amber),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.amber.withOpacity(0.1),
                                          Colors.amber.withOpacity(0.6),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.42,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18.0, vertical: 15),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                    // "${currentUserChangeNotifier.currentUserData!.tickets}",
                                                  "2/10",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        ?.copyWith(
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                                Text("Lessons",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline6
                                                        ?.copyWith(
                                                            fontSize: 16,
                                                            color: Colors.blue,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                              ],
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("📚",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline6
                                                    ?.copyWith(
                                                        fontSize: 30,
                                                        color:
                                                            AppColors.primary,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(color: Colors.blue),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.blue.withOpacity(0.1),
                                          Colors.blue.withOpacity(0.6),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            // Text("${user.tickets} 🎟",
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .headline6
                            //         ?.copyWith(
                            //         color: AppColors.primary,
                            //         fontWeight: FontWeight.bold)),
                            // Container(
                            //   child: Text("${userData.gold} 🪙",
                            //       style: Theme.of(context)
                            //           .textTheme
                            //           .headline6
                            //           ?.copyWith(
                            //           color:
                            //           AppColors.primary,
                            //           fontWeight:
                            //           FontWeight.bold)),
                            // ),

                            // Card(
                            //   elevation: 3,
                            //   color: AppColors.primary,
                            //   child: Padding(
                            //     padding: const EdgeInsets.symmetric(
                            //         horizontal: 10.0, vertical: 10),
                            //     child: Container(
                            //       height: 35,
                            //       width: double.infinity,
                            //       // (MediaQuery.of(context).size.width / 2) * 0.75
                            //       child: Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceEvenly,
                            //         children: [
                            //           Text("${user?.tickets} 🎟",
                            //               style: Theme.of(context)
                            //                   .textTheme
                            //                   .headline6
                            //                   ?.copyWith(color: AppColors.text, fontWeight: FontWeight.bold)),
                            //           SizedBox(
                            //             width: 8,
                            //           ),
                            //           Text("${user?.gold} 🥇",
                            //               style: Theme.of(context)
                            //                   .textTheme
                            //                   .headline6
                            //                   ?.copyWith(color: AppColors.text, fontWeight: FontWeight.bold)),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // )
                            // Spacer(),
                            // InkWell(
                            //   onTap: () {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => FoodStylePage()));
                            //   },
                            //   child: Card(
                            //     elevation: 3,
                            //     color: AppColors.primary,
                            //     child: Padding(
                            //       padding: const EdgeInsets.symmetric(
                            //           horizontal: 10.0, vertical: 10),
                            //       child: Container(
                            //         height: 35,
                            //         width:
                            //         (MediaQuery.of(context).size.width / 2) * 0.75,
                            //         child: Center(
                            //           child: Text("Play Now 🎲",
                            //               style: Theme.of(context)
                            //                   .textTheme
                            //                   .headline6
                            //                   ?.copyWith(
                            //                       color: AppColors.text,
                            //                       fontSize: 18, fontWeight: FontWeight.bold)),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      );
              },
            );
          }),
    );
  }
}
