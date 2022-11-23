import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uia/screens/profile/components/payment_methods.dart';
import 'package:uia/screens/profile/components/refer_earn.dart';
import 'package:uia/screens/profile/components/withdrawal.dart';
import 'package:uia/services/current_user_change_notifier.dart';
import 'package:uia/services/payement_method_notifier.dart';
import 'package:uia/services/wallet_transactions_notifier.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uia/models/transactions.dart' as tr;
import '../../../core/constants/constants.dart';
import '../../../models/User.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../services/authentication/authentication_service.dart';
import '../../../services/data_streams/user_stream.dart';
import '../../../services/database/user_database_helper.dart';

class Wallet extends StatefulWidget {
  const Wallet({
    Key? key,
  }) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  final UserStream userStream = UserStream();
  @override
  void initState() {
    super.initState();
    currentUserChangeNotifier.setCurrentUser(true);
    paymentMethodChangeNotifier.setPaymentMethod();
    walletTransactionsChangeNotifier.setTransactions();
    userStream.init();
  }

  @override
  void dispose() {
    userStream.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> paymentImages = {
      'GCash': 'assets/images/gcash.png',
      'JazzCash': 'assets/images/jazz.png',
      'PayPal': 'assets/images/paypal.png',
      'Paytm': 'assets/images/paytm.png',
      'PIX': 'assets/images/pix.png'
    };
    return FutureBuilder<UserData>(
        future: UserDatabaseHelper().getUserDataFromId(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            String? url = AuthenticationService().currentUser?.photoURL;
            return user!.activated == true
                ? Scaffold(
                    // appBar: AppBar(
                    //   elevation: 3,
                    //   backgroundColor: Colors.white,
                    //   title: const Text(
                    //     "Wallet 💵",
                    //     style: TextStyle(color: Colors.black),
                    //   ),
                    //   automaticallyImplyLeading: true,
                    //   centerTitle: true,
                    //   iconTheme: IconThemeData(color: Colors.black),
                    // ),
                    body: Padding(
                      padding: const EdgeInsets.all(AppDefaults.padding),
                      child: SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            StreamBuilder<
                                    DocumentSnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection("users")
                                    .doc(user.email)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Container();
                                  } else {
                                    DocumentSnapshot<Map<String, dynamic>>?
                                        item = snapshot.data;

                                    return Card(
                                      elevation: 4,
                                      color: AppColors.primary,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15.0, vertical: 10),
                                        child: Container(
                                            child: Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Text("TOTAL BALANCE",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headline5
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.015,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                ),
                                                Text(
                                                    "\$${item!.get('cash').toStringAsFixed(4)}",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headline5
                                                        ?.copyWith(
                                                            color: Colors.white,
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.04,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold)),
                                              ],
                                            ),
                                          ],
                                        )),
                                      ),
                                    );
                                  }
                                }),

                            // AnimatedBuilder(
                            //   animation: currentUserChangeNotifier,
                            //   builder: (context, child) {
                            //     return currentUserChangeNotifier
                            //                 .currentUserData !=
                            //             null
                            //         ? Card(
                            //             elevation: 4,
                            //             color: AppColors.primary,
                            //             child: Padding(
                            //               padding: const EdgeInsets.symmetric(
                            //                   horizontal: 15.0, vertical: 10),
                            //               child: Container(
                            //                   child: Column(
                            //                 children: [
                            //                   Column(
                            //                     crossAxisAlignment:
                            //                         CrossAxisAlignment.center,
                            //                     children: [
                            //                       Center(
                            //                         child: Text("TOTAL BALANCE",
                            //                             style: Theme.of(context)
                            //                                 .textTheme
                            //                                 .headline5
                            //                                 ?.copyWith(
                            //                                     color: Colors
                            //                                         .black,
                            //                                     fontSize: MediaQuery.of(
                            //                                                 context)
                            //                                             .size
                            //                                             .height *
                            //                                         0.015,
                            //                                     fontWeight:
                            //                                         FontWeight
                            //                                             .bold)),
                            //                       ),
                            //                       Text(
                            //                           "\$${(currentUserChangeNotifier.currentUserData!.dollars).toStringAsFixed(4)}",
                            //                           style: Theme.of(context)
                            //                               .textTheme
                            //                               .headline5
                            //                               ?.copyWith(
                            //                                   color:
                            //                                       Colors.white,
                            //                                   fontSize: MediaQuery.of(
                            //                                               context)
                            //                                           .size
                            //                                           .height *
                            //                                       0.04,
                            //                                   fontWeight:
                            //                                       FontWeight
                            //                                           .bold)),
                            //                     ],
                            //                   ),
                            //                 ],
                            //               )),
                            //             ),
                            //           )
                            //         : Container();
                            //   },
                            // ),

                            // Center(
                            //   child: Text("TOTAL BALANCE",
                            //       style: Theme.of(context)
                            //           .textTheme
                            //           .headline5
                            //           ?.copyWith(
                            //               color: Colors.grey,
                            //               fontSize: MediaQuery.of(context)
                            //                       .size
                            //                       .height *
                            //                   0.015,
                            //               fontWeight: FontWeight.bold)),
                            // ),
                            // Text("\$${(user.dollars).toStringAsFixed(4)}",
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .headline5
                            //         ?.copyWith(
                            //             color: AppColors.primary,
                            //             fontSize:
                            //                 MediaQuery.of(context).size.height *
                            //                     0.04,
                            //             fontWeight: FontWeight.bold)),

                            SizedBox(
                              height: 10,
                            ),
                            AnimatedBuilder(
                              animation: paymentMethodChangeNotifier,
                              builder: (context, child) {
                                return paymentMethodChangeNotifier
                                            .paymentMethodData !=
                                        null
                                    ? optionCardLong2(
                                        AppColors.primary,
                                        'Country: ${paymentMethodChangeNotifier.paymentMethodData!['paymentMethod']["country"]}',
                                        'Method: ${paymentMethodChangeNotifier.paymentMethodData!['paymentMethod']["id"]}(${paymentMethodChangeNotifier.paymentMethodData!['paymentMethod']["details"]['payeeAccountNo']}) ',
                                        'Withdraw',
                                        'Change',
                                        paymentImages[
                                            paymentMethodChangeNotifier
                                                    .paymentMethodData![
                                                'paymentMethod']["id"]]!,
                                        '100 🥇',
                                        () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Withdrawal()));
                                        },
                                        () {
                                          showModalBottomSheet(
                                              isScrollControlled: true,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10))),
                                              context: context,
                                              builder: (context) =>
                                                  PaymentMethods());
                                        },
                                      )
                                    : optionCardLong(
                                        AppColors.primary,
                                        'Select a payment method!️️',
                                        'Get your cash in your account instantly!',
                                        'Choose',
                                        'assets/images/wallet.png',
                                        '100 🥇', () {
                                        showModalBottomSheet(
                                            isScrollControlled: true,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10))),
                                            context: context,
                                            builder: (context) =>
                                                PaymentMethods());
                                      });
                              },
                            ),
                            // FutureBuilder<Map<String, dynamic>?>(
                            //     future:
                            //         UserDatabaseHelper().getPaymentMethod(),
                            //     builder: (BuildContext context,
                            //         AsyncSnapshot<dynamic> snapshot) {
                            //       if (snapshot.hasData) {
                            //         return optionCardLong2(
                            //           AppColors.primary,
                            //           'Country: ${snapshot.data['paymentMethod']["country"]}',
                            //           'Method: ${snapshot.data['paymentMethod']["id"]}(${snapshot.data['paymentMethod']["details"]['payeeAccountNo']}) ',
                            //           'Withdraw',
                            //           'Change',
                            //           paymentImages[snapshot
                            //               .data['paymentMethod']["id"]]!,
                            //           '100 🥇',
                            //           () {},
                            //           () {
                            //             showModalBottomSheet(
                            //                 isScrollControlled: true,
                            //                 shape: RoundedRectangleBorder(
                            //                     borderRadius:
                            //                         BorderRadius.only(
                            //                             topLeft:
                            //                                 Radius.circular(
                            //                                     10),
                            //                             topRight:
                            //                                 Radius.circular(
                            //                                     10))),
                            //                 context: context,
                            //                 builder: (context) =>
                            //                     PaymentMethods());
                            //           },
                            //         );
                            //       } else {
                            //         return optionCardLong(
                            //             AppColors.primary,
                            //             'Select a payment method!️️',
                            //             'Get your cash in your account instantly!',
                            //             'Choose',
                            //             'assets/images/wallet.png',
                            //             '100 🥇', () {
                            //           showModalBottomSheet(
                            //               isScrollControlled: true,
                            //               shape: RoundedRectangleBorder(
                            //                   borderRadius: BorderRadius.only(
                            //                       topLeft:
                            //                           Radius.circular(10),
                            //                       topRight:
                            //                           Radius.circular(10))),
                            //               context: context,
                            //               builder: (context) =>
                            //                   PaymentMethods());
                            //         });
                            //       }
                            //     }),
                            SizedBox(
                              height: 15,
                            ),
                            Text("Recent Transactions".toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    ?.copyWith(
                                        color: Colors.grey,
                                        fontSize:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                        fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 15,
                            ),

                            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                                stream: FirebaseFirestore.instance
                                    .collection("userTransactions")
                                    .doc('aviralhtc2015@gmail.com')
                                    .collection('details')
                                    .orderBy('date', descending: true)
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Expanded(
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'assets/images/noTransactions.png',
                                              // height:100,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.5,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text('No Recent Transactions Found')
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    List<
                                            QueryDocumentSnapshot<
                                                Map<String, dynamic>>>? items =
                                        snapshot.data?.docs;

                                    return Expanded(
                                      child: Container(
                                        color: Colors.white,
                                        // height:
                                        //     MediaQuery.of(context).size.height * 2,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: ListView.builder(
                                            // physics:
                                            //     NeverScrollableScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            itemCount: items!.length,
                                            itemBuilder: (context, index) {
                                              return transactionCard(
                                                FontAwesomeIcons.dollarSign,
                                                items[index]
                                                    .get('amount')
                                                    .toString(),
                                                items[index].get('date'),
                                                items[index].get('state'),
                                                items[index].get('orderId'),
                                                items[index].get('time'),
                                              );
                                            }),
                                      ),
                                    );
                                  }
                                }),

                            // FutureBuilder<List<tr.Transaction>>(
                            //   future:
                            //       UserDatabaseHelper().getUserTransactions(),
                            //   builder: (BuildContext context,
                            //       AsyncSnapshot<dynamic> snapshot) {
                            //     if (snapshot.hasData &&
                            //         snapshot.data.length != 0) {
                            //       return Expanded(
                            //         child: Container(
                            //           color: Colors.white,
                            //           // height:
                            //           //     MediaQuery.of(context).size.height * 2,
                            //           width: MediaQuery.of(context).size.width,
                            //           child: ListView.builder(
                            //               // physics:
                            //               //     NeverScrollableScrollPhysics(),
                            //               scrollDirection: Axis.vertical,
                            //               itemCount: snapshot.data?.length,
                            //               itemBuilder: (context, index) {
                            //                 return transactionCard(
                            //                   FontAwesomeIcons.dollarSign,
                            //                   snapshot.data[index].amount
                            //                       .toString(),
                            //                   snapshot.data[index].date,
                            //                   snapshot.data[index].state,
                            //                   snapshot.data[index].orderId,
                            //                   snapshot.data[index].time,
                            //                 );
                            //               }),
                            //         ),
                            //       );
                            //     } else {
                            //       return Expanded(
                            //         child: Container(
                            //           child: Column(
                            //             mainAxisAlignment:
                            //                 MainAxisAlignment.center,
                            //             children: [
                            //               Image.asset(
                            //                 'assets/images/noTransactions.png',
                            //                 // height:100,
                            //                 width: MediaQuery.of(context)
                            //                         .size
                            //                         .width *
                            //                     0.5,
                            //               ),
                            //               SizedBox(
                            //                 height: 10,
                            //               ),
                            //               Text('No Recent Transactions Found')
                            //             ],
                            //           ),
                            //         ),
                            //       );
                            //     }
                            //   },
                            // ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Scaffold(
                    backgroundColor: AppColors.secondary,
                    body: Column(
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
          return Scaffold(body: Center(child: const Text('Loading...')));
        });
  }

  Widget optionCardLong(Color color, String text, String line1, String btnText,
      String anim, String reward, void Function() onTap) {
    return SizedBox(
      child: Card(
        elevation: 4,
        color: AppColors.primary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Container(
              child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(text,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(line1,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    color: Colors.white,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                      ),

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
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: AppColors.orange),
                child: InkWell(
                  onTap: onTap,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 12),
                    child: Center(
                      child: Text(btnText,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  Widget optionCardLong2(
    Color color,
    String text,
    String line1,
    String btnText,
    String btnText2,
    String anim,
    String reward,
    void Function() onTap,
    void Function() onTap2,
  ) {
    return SizedBox(
      child: Card(
        elevation: 4,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Container(
              child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Text(text,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(line1,
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                ?.copyWith(
                                    color: AppColors.primary,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold)),
                      ),

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
                    width: 100,
                  ),
                  // anim != ''
                  //     ? SizedBox(
                  //         height: 70, child: CircleAvatar(backgroundColor: Colors.white, backgroundImage:AssetImage(anim), radius: 50,))
                  //     : Container(),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: AppColors.primary),
                      child: InkWell(
                        onTap: onTap2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 12),
                          child: Center(
                            child: Text(btnText2,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: AppColors.primary),
                      child: InkWell(
                        onTap: onTap,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 12),
                          child: Center(
                            child: Text(btnText,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    ?.copyWith(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
        ),
      ),
    );
  }

  Widget transactionCard(icon, amount, date, status, orderId, Timestamp time) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Card(
          child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: CircleAvatar(
                        backgroundColor: status == 'approved'
                            ? Colors.lightGreen.withOpacity(0.2)
                            : status == 'pending'
                                ? AppColors.green.withOpacity(0.2)
                                : status == 'paid'
                                    ? Colors.green.withOpacity(0.2)
                                    : Colors.red.withOpacity(0.2),
                        child: Icon(
                          icon,
                          color: status == 'approved'
                              ? Colors.lightGreen
                              : status == 'pending'
                                  ? AppColors.green
                                  : status == 'paid'
                                      ? Colors.green
                                      : Colors.red,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(orderId.toString().split("LuckyCube")[1],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Text('${status.toString().toUpperCase()}',
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('\$${amount}',
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          Text('${timeago.format(time.toDate())}',
                              style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ]))),
    );
  }
}
