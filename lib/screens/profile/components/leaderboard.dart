import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uia/screens/profile/components/refer_earn.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polygon/flutter_polygon.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_functions/cloud_functions.dart';

import '../../../core/constants/constants.dart';
import '../../../models/User.dart';
import '../../../services/authentication/authentication_service.dart';
import '../../../services/data_streams/user_stream.dart';
import '../../../services/database/user_database_helper.dart';

class Leaderboard extends StatefulWidget {
  const Leaderboard({
    Key? key,
  }) : super(key: key);

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  final UserStream userStream = UserStream();
  UserData? userDet;
  getUserDetails() async {
    setState(() async {
      userDet = await UserDatabaseHelper().getUserDataFromId();
    });
  }

  @override
  void initState() {
    getUserDetails();
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
      'getServerTime',
      options: HttpsCallableOptions(
        timeout: const Duration(seconds: 10),
      ),
    );

    try {
      final result = callable().then((value) {
        setState(() {
          _start = (value.data['leadTime'] / 1000).floor();
        });

        print(value.data['leadTime']);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('ERROR: $e'),
        ),
      );
    }
    super.initState();
    startTimer();
    userStream.init();
  }

  Timer? _timer;
  int _start = 5000;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();

    userStream.dispose();
    _timer?.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map>>(
        future: UserDatabaseHelper().getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            String? url = AuthenticationService().currentUser?.photoURL;
            return Scaffold(
              appBar: AppBar(
                elevation: 3,
                backgroundColor: Colors.white,
                title: const Text(
                  "Leaderboard 🏆️",
                  style: TextStyle(color: Colors.black),
                ),
                automaticallyImplyLeading: true,
                centerTitle: true,
              ),
              body: Padding(
                padding: const EdgeInsets.all(AppDefaults.padding),
                child: SafeArea(
                  child: Column(
                    children: [
                      optionCardLong(
                          AppColors.primary,
                          userDet!.activated == false
                              ? ''
                              : 'Cyber Smart!👑️️',
                          'Ends in: ${(_start ~/ 3600)}h ${((_start - (_start ~/ 3600) * 3600)) ~/ 60}m ${_start - ((_start ~/ 3600) * 3600) - ((((_start - (_start ~/ 3600) * 3600)) ~/ 60) * 60)}s ',

                          'Go Now',
                          'assets/images/board.png',
                          '100 🥇',
                          () {}),
                      Expanded(
                        child: Container(
                          color: Colors.white,
                          // height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: FutureBuilder<UserData>(
                              future: UserDatabaseHelper().getUserDataFromId(),
                              builder: (context, snap) {
                                if (snap.hasData) {
                                  {
                                    return snap.data!.activated
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: snapshot.data?.length,
                                            itemBuilder: (context, index) {
                                              return userCard(
                                                  index,
                                                  snapshot.data![index]
                                                      ['profileImage'],
                                                  snapshot.data![index]['name'],
                                                  snapshot.data![index]
                                                      ['coins'],
                                                  true);
                                            })
                                        : ListView.builder(
                                            scrollDirection: Axis.vertical,
                                            itemCount: snapshot.data?.length,
                                            itemBuilder: (context, index) {
                                              return userCard(
                                                  index,
                                                  snapshot.data![index]
                                                      ['profileImage'],
                                                  snapshot.data![index]['name'],
                                                  snapshot.data![index]
                                                      ['coins'],
                                                  false);
                                            });
                                  }
                                } else {
                                  return const Center(
                                      child: Text('Loading...'));
                                }
                              }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Scaffold(body: Center(child: const Text('Loading...')));
        });
  }

  Widget userCard(rank, url, name, gold, showAmount) {
    return Container(
      height: 100,
      child: Card(
        elevation:
            AuthenticationService().currentUser?.displayName == name ? 12 : 2,
        color: Colors.white,
        shape: AuthenticationService().currentUser?.displayName == name
            ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
            : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                  flex: 5,
                  child: Row(
                    children: [
                    CircleAvatar(
                        backgroundColor: AppColors.primary,
                        radius: 27,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(url!),
                          radius: 25,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.335,
                            child: Text(name,
                                style: TextStyle(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                )),
                          ),
                          (rank >= 0 && rank <= 9) && showAmount
                              ? Text('${rew[rank + 1] * 100} Points',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ))
                              : Text('Number ${rank + 1}',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  )),
                        ],
                      ),
                    ],
                  )),
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text('',
                    //     style: TextStyle(
                    //       color: AppColors.primary,
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 18,
                    //     )),
                    //🥇
                    Text('⭐️',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  var rew = [0, 1, 0.5, 0.5, 0.25, 0.25, 0.1, 0.1, 0.1, 0.1, 0.1];
  Widget optionCardLong(Color color, String text, String line1, String btnText,
      String anim, String reward, void Function() onTap) {
    return SizedBox(
      child: Card(
        elevation: 4,
        color: AppColors.primary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Container(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(line1,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),

                  // Container(
                  //   decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.all(Radius.circular(35)),
                  //       color: AppColors.orange.withOpacity(0.4)
                  //   ),
                  //
                  //   child:Padding(
                  //     padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 12),
                  //     child: Text('$reward',
                  //         style: Theme.of(context).textTheme.headline6?.copyWith(
                  //             color: Colors.white,
                  //             fontSize: 18,
                  //             fontWeight: FontWeight.bold)),
                  //   ),
                  //
                  // ),
                  // SizedBox(
                  //   height: 30,
                  // ),
                ],
              ),

              Image.asset(
                anim,
                height: 100,
              ),
              // anim != ''
              //     ? SizedBox(
              //         height: 70, child: CircleAvatar(backgroundColor: Colors.white, backgroundImage:AssetImage(anim), radius: 50,))
              //     : Container(),
            ],
          )),
        ),
      ),
    );
  }
}
