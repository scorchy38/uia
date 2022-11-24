import 'dart:math';
import 'package:uia/homepage.dart';
import 'package:uia/screens/game/components/main_game.dart';
import 'package:uia/screens/game/game.dart';
import 'package:uia/screens/home/home_page.dart';
import 'package:uia/screens/home_page.dart';
import 'package:uia/screens/passwordClash/pcGameScreen.dart';
import 'package:uia/screens/passwordClash/startGameScreen.dart';
import 'package:uia/screens/surveys/components/item_tile.dart';
import 'package:uia/services/current_user_change_notifier.dart';
import 'package:uia/services/data_streams/user_stream.dart';
import 'package:uia/services/database/user_database_helper.dart';
import 'package:emojis/emoji.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import '../../../core/constants/constants.dart';
import '../../../models/User.dart';
import '../../../services/authentication/authentication_service.dart';
import '../../profile/components/leaderboard.dart';
import '../../profile/components/refer_earn.dart';
import '../../surveys/surveys.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class HomeOptions extends StatefulWidget {
  const HomeOptions({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeOptions> createState() => _HomeOptionsState();
}

class _HomeOptionsState extends State<HomeOptions> {
  final UserStream userStream = UserStream();
  @override
  void initState() {
    generateFourNumbers();
    getRatedStatusNow();

    currentUserChangeNotifier.setCurrentUser(true);
    super.initState();
    userStream.init();
  }

  @override
  void dispose() {
    userStream.dispose();
    super.dispose();
  }

  String _logText = '';

  bool _showButton = false;
  bool _completedSurvey = false;
  int _currentIndex = 0;
  int _cpa = 0;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Text findCurrentTitle(int currentIndex) {
    if (_currentIndex == 0) {
      return const Text('Pollfish Rewarded Integration');
    } else {
      return const Text('Pollfish Offerwall Integration');
    }
  }

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

  bool? isRewardedVideoAvailable = false;
  bool isInterstitialVideoAvailable = false;

  bool? rated;
  void getRatedStatusNow() async {
    rated = await getRatingStatus();
    print('=============$rated');
  }

  int? n1;
  int? n2;
  int? n3;
  int? n4;
  generateFourNumbers() {
    var random = Random();
    n1 = random.nextInt(2);
    n2 = random.nextInt(3);
    n3 = random.nextInt(4);
    n4 = random.nextInt(5);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData>(
        future: UserDatabaseHelper().getUserDataFromId(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            String? url = AuthenticationService().currentUser?.photoURL;
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDefaults.padding - 2),
                    child: Row(
                      // scrollDirection: Axis.horizontal,
                      children: [
                        optionCard(
                            AppColors.primary,
                            ' Play Now',
                            'EARN UPTO',
                            'Play now',
                            'assets/images/diceLogo.png',
                            '50 Points📈', () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderPage()));
                        }),
                        optionCard(
                          AppColors.primary,
                          'Videos/Comics',
                          'AND EARN',
                          'Watch Now',
                          'assets/images/coin.png',
                          '5 Points📈',
                          () async {},
                        ),
                      ],
                    ),
                  ),
                  user!.activated == true
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppDefaults.padding - 2),
                          child: Row(
                            children: [
                              // optionCardHorizontal(
                              //     AppColors.primary,
                              //     'Refer & Earn️',
                              //     'UP TO',
                              //     'Go Now',
                              //     'assets/images/playstore.png',
                              //     '\$0.01 ', () {
                              //   Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //           builder: (context) => ReferEarn()));
                              // })
                            ],
                          ),
                        )
                      : Container(),

                  Container(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: GridView(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                      ),
                      children: [
                        SurveyTile('Perfect Game', 'Good Links vs Bad Links',
                            'assets/images/link.png', '7-10', () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FoodStylePage()));
                        }),
                        SurveyTile('Virus Run', 'Virus Protection',
                            'assets/images/virus.png', '11-15', () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        }),
                        SurveyTile('Hackers v/s Us', 'Cyber Crimes Learning',
                            'assets/images/hacker.png', '7-10', () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => HP()));
                        }),
                        SurveyTile('Password Clash', 'Fight With a Friend',
                            'assets/images/clash.png', '11-15', () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StartGameScreen()));
                        }),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Container(
                  //     width: double.infinity,
                  //     decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.all(Radius.circular(10)),
                  //         color: AppColors.primary),
                  //     child: InkWell(
                  //       onTap: () {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => OrderPage()));
                  //       },
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 30.0, vertical: 12),
                  //         child: Center(
                  //           child: Text('See More',
                  //               style: Theme.of(context)
                  //                   .textTheme
                  //                   .headline6
                  //                   ?.copyWith(
                  //                       color: Colors.white,
                  //                       fontSize: 14.5,
                  //                       fontWeight: FontWeight.bold)),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            );
          }
          return const Text('');
        });
  }

  Widget optionCard(Color color, String text, String line1, String btnText,
      String anim, String reward, void Function() onTap) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.46,
            child: Card(
              elevation: 4,
              color: Colors.white,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        Text(text,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                        SizedBox(
                          height: 30,
                        ),
                        // Text(line1,
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .headline6
                        //         ?.copyWith(
                        //             color: AppColors.primary,
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 10,
                        ),
                        // Container(
                        //   decoration: BoxDecoration(
                        //       borderRadius:
                        //           BorderRadius.all(Radius.circular(35)),
                        //       color: AppColors.primary.withOpacity(0.4)),
                        //   child: Padding(
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 22.0, vertical: 12),
                        //     child: Text('$reward',
                        //         style: Theme.of(context)
                        //             .textTheme
                        //             .headline6
                        //             ?.copyWith(
                        //                 color: AppColors.primary,
                        //                 fontSize: 18,
                        //                 fontWeight: FontWeight.bold)),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 30,
                        // ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: AppColors.primary),
                          child: InkWell(
                            onTap: onTap,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30.0, vertical: 12),
                              child: Text(btnText,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      ?.copyWith(
                                          color: Colors.white,
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.bold)),
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            ),
          ),
        ),
        anim != ''
            ? Padding(
                padding: const EdgeInsets.only(bottom: 90.0),
                child: SizedBox(
                    height: 70,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Image.asset(
                        anim,
                        height: 50,
                      ),
                      radius: 50,
                    )),
              )
            : Container(),
      ],
    );
  }

  Widget optionCardHorizontal(Color color, String text, String line1,
      String btnText, String anim, String reward, void Function() onTap) {
    return InkWell(
      onTap: rated! && text == 'Rate Us⭐'
          ? () {
              Fluttertoast.showToast(msg: 'Already Redeemed!');
            }
          : onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.46,
        child: Card(
          elevation: 4,
          color: rated! && text == 'Rate Us⭐' ? Colors.grey[350] : Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(text,
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22)),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(line1,
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: rated! && text == 'Rate Us⭐'
                                ? Colors.white
                                : AppColors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 10,
                    ),

                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(35)),
                          color: AppColors.primary.withOpacity(0.4)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22.0, vertical: 12),
                        child: Text('$reward',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ),
                    // SizedBox(
                    //   height: 30,
                    // ),
                  ],
                ),
                // anim != ''
                //     ? SizedBox(
                //         height: 70, child: CircleAvatar(backgroundColor: Colors.white, backgroundImage:AssetImage(anim), radius: 50,))
                //     : Container(),

                // Container(
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.all(Radius.circular(10)),
                //     color: AppColors.orange
                //   ),
                //
                //   child:InkWell(
                //     onTap: onTap,
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12),
                //       child: Text(btnText,
                //           style: Theme.of(context).textTheme.headline6?.copyWith(
                //               color: Colors.white,
                //               fontSize: 16,
                //               fontWeight: FontWeight.bold)),
                //     ),
                //   ),
                //
                // )
              ],
            )),
          ),
        ),
      ),
    );
  }

  Widget optionCardLong(Color color, String text, String line1, String btnText,
      String anim, String reward, void Function() onTap) {
    return SizedBox(
      child: Card(
        elevation: 4,
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Container(
              child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  height: 70,
                  child: CircleAvatar(
                    backgroundColor: AppColors.white,
                    child: Image.asset(
                      anim,
                      height: 50,
                    ),
                    radius: 30,
                  )),

              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(text,
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                  line1 != ''
                      ? SizedBox(
                          height: 10,
                        )
                      : SizedBox(),
                  line1 != ''
                      ? Text(line1,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold))
                      : SizedBox(),

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

              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: AppColors.primary),
                child: InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 12),
                    child: Text(btnText,
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              )
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

  Future<bool?> getRatingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? status = prefs.getBool('rated');
    if (status == null) return false;

    return status;
  }

  void setRatedStatus() async {
    UserDatabaseHelper().cloudRateUs();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rated', true);
  }
}
