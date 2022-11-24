import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uia/screens/auth/login_page.dart';
import 'package:uia/screens/profile/components/edit_profile.dart';
import 'package:uia/screens/profile/components/leaderboard.dart';
import 'package:uia/screens/profile/components/refer_earn.dart';
import 'package:uia/screens/profile/components/wallet.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

import '../../../core/constants/constants.dart';
import '../../../models/User.dart';
import '../../../services/authentication/authentication_service.dart';
import '../../../services/data_streams/user_stream.dart';
import '../../../services/database/user_database_helper.dart';
import '../../../wrappers/authentication_wrapper.dart';

class UserDataPage extends StatefulWidget {
  const UserDataPage({
    Key? key,
  }) : super(key: key);

  @override
  State<UserDataPage> createState() => _UserDataPageState();
}

class _UserDataPageState extends State<UserDataPage> {
  final UserStream userStream = UserStream();
  @override
  void initState() {
    super.initState();

    userStream.init();
  }

  @override
  void dispose() {
    userStream.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppDefaults.padding),
        child: FutureBuilder<UserData>(
            future: UserDatabaseHelper().getUserDataFromId(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data;
                print(user!.toMap());
                String? url = user?.dpUrl;
                return Container(
                  child: Column(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 51,
                            backgroundColor: AppColors.primary.withOpacity(0.7),
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 50,
                              child: CircleAvatar(
                                backgroundColor:
                                    AppColors.primary.withOpacity(0.7),
                                radius: 41,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 40,
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(url!),
                                    radius: 35,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("${user?.name}",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  ?.copyWith(
                                      color: Colors.black,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.024,
                                      fontWeight: FontWeight.bold)),
                          // Text("~Rank 1000",
                          //     style: Theme.of(context)
                          //         .textTheme
                          //         .headline5
                          //         ?.copyWith(
                          //         color: AppColors.primary,
                          //         fontSize: MediaQuery.of(context).size.height * 0.02, fontWeight: FontWeight.normal )),
                          const SizedBox(height: 10),

                          // user!.activated == true
                          //     ? Row(
                          //         children: [
                          //           InkWell(
                          //             onTap: () {
                          //               Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                       builder: (context) =>
                          //                           const Wallet()));
                          //             },
                          //             child: Card(
                          //               elevation: 3,
                          //               color: AppColors.complimentary,
                          //               child: Padding(
                          //                 padding: const EdgeInsets.symmetric(
                          //                     horizontal: 10.0, vertical: 10),
                          //                 child: Container(
                          //                   height: 30,
                          //                   width: MediaQuery.of(context)
                          //                           .size
                          //                           .width *
                          //                       0.375,
                          //                   child: Center(
                          //                     child: Text("Wallet 💵",
                          //                         style: Theme.of(context)
                          //                             .textTheme
                          //                             .headline6
                          //                             ?.copyWith(
                          //                                 color: AppColors.text,
                          //                                 fontSize: 18,
                          //                                 fontWeight:
                          //                                     FontWeight.bold)),
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //           InkWell(
                          //             onTap: () {
                          //               Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                       builder: (context) =>
                          //                           const ReferEarn()));
                          //             },
                          //             child: Card(
                          //               elevation: 3,
                          //               color: AppColors.complimentary,
                          //               child: Padding(
                          //                 padding: const EdgeInsets.symmetric(
                          //                     horizontal: 10.0, vertical: 10),
                          //                 child: Container(
                          //                   height: 30,
                          //                   width: MediaQuery.of(context)
                          //                           .size
                          //                           .width *
                          //                       0.375,
                          //                   child: Center(
                          //                     child: Text("Refer & Earn 💰",
                          //                         style: Theme.of(context)
                          //                             .textTheme
                          //                             .headline6
                          //                             ?.copyWith(
                          //                                 color: AppColors.text,
                          //                                 fontSize: 18,
                          //                                 fontWeight:
                          //                                     FontWeight.bold)),
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       )
                          //     : Container(),
                          // const SizedBox(
                          //   height: 10,
                          // ), // user!.activated == true
                          //     ? Row(
                          //         children: [
                          //           InkWell(
                          //             onTap: () {
                          //               Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                       builder: (context) =>
                          //                           const Wallet()));
                          //             },
                          //             child: Card(
                          //               elevation: 3,
                          //               color: AppColors.complimentary,
                          //               child: Padding(
                          //                 padding: const EdgeInsets.symmetric(
                          //                     horizontal: 10.0, vertical: 10),
                          //                 child: Container(
                          //                   height: 30,
                          //                   width: MediaQuery.of(context)
                          //                           .size
                          //                           .width *
                          //                       0.375,
                          //                   child: Center(
                          //                     child: Text("Wallet 💵",
                          //                         style: Theme.of(context)
                          //                             .textTheme
                          //                             .headline6
                          //                             ?.copyWith(
                          //                                 color: AppColors.text,
                          //                                 fontSize: 18,
                          //                                 fontWeight:
                          //                                     FontWeight.bold)),
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //           InkWell(
                          //             onTap: () {
                          //               Navigator.push(
                          //                   context,
                          //                   MaterialPageRoute(
                          //                       builder: (context) =>
                          //                           const ReferEarn()));
                          //             },
                          //             child: Card(
                          //               elevation: 3,
                          //               color: AppColors.complimentary,
                          //               child: Padding(
                          //                 padding: const EdgeInsets.symmetric(
                          //                     horizontal: 10.0, vertical: 10),
                          //                 child: Container(
                          //                   height: 30,
                          //                   width: MediaQuery.of(context)
                          //                           .size
                          //                           .width *
                          //                       0.375,
                          //                   child: Center(
                          //                     child: Text("Refer & Earn 💰",
                          //                         style: Theme.of(context)
                          //                             .textTheme
                          //                             .headline6
                          //                             ?.copyWith(
                          //                                 color: AppColors.text,
                          //                                 fontSize: 18,
                          //                                 fontWeight:
                          //                                     FontWeight.bold)),
                          //                   ),
                          //                 ),
                          //               ),
                          //             ),
                          //           ),
                          //         ],
                          //       )
                          //     : Container(),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          // ),
                          user?.activated == true
                              ? profileOption(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage()));
                                }, EvaIcons.creditCardOutline, '   Login to Get Certificate')
                              : Container(),
                          // user?.activated == true
                          //     ? profileOption(() {
                          //         Navigator.push(
                          //             context,
                          //             MaterialPageRoute(
                          //                 builder: (context) =>
                          //                     const ReferEarn()));
                          //       }, EvaIcons.peopleOutline, '   Refer & Earn')
                          //     : Container(),
                          profileOption(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Leaderboard()));
                          }, EvaIcons.awardOutline, '   Leaderboard'),
                          profileOption(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const EditProfile()));
                          }, EvaIcons.editOutline, '   Edit Profile'),
                          user?.activated == true
                              ? profileOption(() {
                                  launcher.launchUrl(
                                      Uri.parse(
                                          'https://play.google.com/store/apps/details?id=com.rayole.lucky.dice'),
                                      mode: launcher
                                          .LaunchMode.externalApplication);
                                }, EvaIcons.barChart2Outline, '   Rate Us')
                              : Container(),
                          // profileOption(() async {
                          //   await UserDatabaseHelper().updateUserDeviceId('NA');
                          //   AuthenticationService().signOutGoogle();
                          //   AuthenticationService().signOut();
                          //   AuthenticationService()
                          //       .setLocalAuthStatus('NotLoggedIn');
                          //   Navigator.pushReplacement(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) =>
                          //               AuthenticationWrapper()));
                          // }, EvaIcons.unlockOutline, '   Logout'),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                print(snapshot.error);

                return Center(child: Text(snapshot.error.toString()));
              }

              return Center(
                  child: Text('Loading... ${snapshot.connectionState}'));
            }),
      ),
    );
  }

  StackTrace? stackTrace;
  Widget profileOption(onTap, icon, name) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                flex: 5,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: Icon(
                        icon,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(name,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        )),
                  ],
                )),
            Flexible(
              flex: 2,
              child: Icon(
                EvaIcons.arrowIosForwardOutline,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
