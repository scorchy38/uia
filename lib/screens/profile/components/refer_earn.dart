import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_share/social_share.dart';

import '../../../core/constants/app_colors.dart';
import '../../../models/User.dart';
import '../../../services/data_streams/user_stream.dart';
import '../../../services/database/user_database_helper.dart';

class ReferEarn extends StatefulWidget {
  const ReferEarn({Key? key}) : super(key: key);

  @override
  _ReferEarnState createState() => _ReferEarnState();
}

class _ReferEarnState extends State<ReferEarn> {
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder<UserData>(
          future: UserDatabaseHelper().getUserDataFromId(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              {
                return snapshot.data!.activated
                    ? Column(
                        children: [
                          Spacer(),
                          Image.asset('assets/illustration/refer.jpg'),
                          SizedBox(
                            height: 30,
                          ),
                          Text("Invite your friends and get \$0.01",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              "Share the code below and ask them to enter it while they sign up. Earn \$0.01 when your friend signs up. Your friend also gets \$0.02!",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: DottedBorder(
                              borderType: BorderType.Rect,
                              dashPattern: [
                                6,
                                6,
                              ],
                              color: Colors.black.withOpacity(0.4),
                              radius: Radius.circular(12),
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${snapshot.data?.rc}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 24)),
                                  InkWell(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(
                                          text: "${snapshot.data?.rc}"));
                                      Fluttertoast.showToast(
                                          msg: 'Code Copied to Clipboard!');
                                    },
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.copy,
                                        ),
                                        Text(' Copy Code',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                ?.copyWith(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.normal,
                                                )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: AppColors.primary),
                            child: InkWell(
                              onTap: () {
                                SocialShare.shareOptions(
                                  "Hey! Use my referral code \*${snapshot.data?.rc}\* to sign up to the app Lucky Dice and earn \$0.02 instantly!\n\n\nhttps://play.google.com/store/apps/details?id=com.rayole.mathplus&hl=en_IN&gl=US",
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 12),
                                child: Text('Share',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                          Spacer(),
                        ],
                      )
                    : Container(
                        color: AppColors.secondary,
                        child: Column(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                'Your account is not activated yet.\nPlease download Lucky Dice Activator app to continue playing game.',
                                style: TextStyle(
                                    fontSize: 21,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      );
              }
            } else {
              return const Center(child: Text('Loading...'));
            }
          }),
    );
  }
}
