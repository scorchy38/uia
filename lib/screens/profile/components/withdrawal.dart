import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uia/screens/profile/components/payment_methods.dart';
import 'package:uia/screens/profile/components/refer_earn.dart';
import 'package:uia/services/current_user_change_notifier.dart';
import 'package:uia/services/payement_method_notifier.dart';
import 'package:uia/services/wallet_transactions_notifier.dart';
import 'package:uia/wrappers/authentication_wrapper.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:future_progress_dialog/future_progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uia/models/transactions.dart' as tr;
import '../../../core/constants/constants.dart';
import '../../../models/User.dart';
import '../../../services/authentication/authentication_service.dart';
import '../../../services/data_streams/user_stream.dart';
import '../../../services/database/user_database_helper.dart';

class Withdrawal extends StatefulWidget {
  const Withdrawal({
    Key? key,
  }) : super(key: key);

  @override
  State<Withdrawal> createState() => _WithdrawalState();
}

class _WithdrawalState extends State<Withdrawal> {
  final UserStream userStream = UserStream();
  @override
  void initState() {
    super.initState();
    paymentMethodChangeNotifier.setPaymentMethod();
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
                    //     "Withdrawal💵",
                    //     style: TextStyle(color: Colors.black),
                    //   ),
                    //   automaticallyImplyLeading: true,
                    //   centerTitle: true,
                    //   iconTheme: IconThemeData(color: Colors.black),
                    // ),
                    body: Padding(
                      padding: const EdgeInsets.all(AppDefaults.padding),
                      child: SafeArea(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                    "Withdraw Dollars to your bank account",
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline5
                                        ?.copyWith(
                                            color: Colors.black,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.023,
                                            fontWeight: FontWeight.bold)),
                              ),

                              SizedBox(
                                height: 15,
                              ),
                              AnimatedBuilder(
                                animation: currentUserChangeNotifier,
                                builder: (context, child) {
                                  return currentUserChangeNotifier
                                              .currentUserData !=
                                          null
                                      ? Card(
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
                                                      child: Text(
                                                          "CURRENT BALANCE",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .headline5
                                                              ?.copyWith(
                                                                  color: Colors
                                                                      .black,
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
                                                        "\$${(currentUserChangeNotifier.currentUserData!.dollars).toStringAsFixed(4)}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headline5
                                                            ?.copyWith(
                                                                color: Colors
                                                                    .white,
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
                                        )
                                      : Container();
                                },
                              ),
                              // Text("\$${user.dollars.toStringAsFixed(5)}",
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .headline5
                              //         ?.copyWith(
                              //             color: AppColors.primary,
                              //             fontSize: MediaQuery.of(context)
                              //                     .size
                              //                     .height *
                              //                 0.025,
                              //             fontWeight: FontWeight.bold)),
                              // Text("Current Balance",
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .headline5
                              //         ?.copyWith(
                              //             color: Colors.grey,
                              //             fontSize: MediaQuery.of(context)
                              //                     .size
                              //                     .height *
                              //                 0.02,
                              //             fontWeight: FontWeight.normal)),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                  "Money would be deposited in the following bank account:",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline5
                                      ?.copyWith(
                                          color: Colors.grey,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                          fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 15,
                              ),
                              AnimatedBuilder(
                                animation: paymentMethodChangeNotifier,
                                builder: (context, child) {
                                  return optionCardLong2(
                                      AppColors.primary,
                                      'Country: ${paymentMethodChangeNotifier.paymentMethodData!['paymentMethod']["country"]}',
                                      'Method: ${paymentMethodChangeNotifier.paymentMethodData!['paymentMethod']["id"]}',
                                      'Account No: ${paymentMethodChangeNotifier.paymentMethodData!['paymentMethod']["details"]['payeeAccountNo']}',
                                      '',
                                      '',
                                      paymentImages[paymentMethodChangeNotifier
                                              .paymentMethodData![
                                          'paymentMethod']["id"]]!,
                                      '100 🥇',
                                      () {},
                                      () {},
                                      user.dollars);
                                },
                              ),

                              SizedBox(
                                height: 15,
                              ),
                              Card(
                                child: Container(
                                  color: AppColors.orange.withOpacity(0.2),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      children: [
                                        Icon(
                                          EvaIcons.info,
                                          color: AppColors.orange,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.735,
                                          child: Text(
                                              "We don't charge any fees for Dollar Withdrawals.\nWithdrawal can take upto 48 hours to process.",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline5
                                                  ?.copyWith(
                                                      color: AppColors.orange,
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.02,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              // Text(
                              //     "${("Select the amount you wish to withdraw").toUpperCase()}",
                              //     style: Theme.of(context)
                              //         .textTheme
                              //         .headline5
                              //         ?.copyWith(
                              //             color: Colors.grey,
                              //             fontSize: MediaQuery.of(context)
                              //                     .size
                              //                     .height *
                              //                 0.019,
                              //             fontWeight: FontWeight.bold)),
                              // // Row(
                              // //   children: [
                              // //     discountCard("25", user.dollars),
                              // //     discountCard("50", user.dollars),
                              // //     discountCard("75", user.dollars),
                              // //     discountCard("100", user.dollars),
                              // //   ],
                              // // ),
                              // SizedBox(
                              //   height: 15,
                              // ),
                              // buildAmountDropDownField(),
                              //
                              // // buildAmountField(),
                              // SizedBox(
                              //   height: 10,
                              // ),
                              // Container(
                              //   width: double.infinity,
                              //   decoration: BoxDecoration(
                              //       borderRadius:
                              //           BorderRadius.all(Radius.circular(10)),
                              //       color: AppColors.primary),
                              //   child: InkWell(
                              //     onTap: () {
                              //       bool status = false;
                              //       UserDatabaseHelper()
                              //           .cloudWithdraw(double.parse(amt));
                              //       if (double.parse(amt) >= 5 &&
                              //           amt != '0' &&
                              //           double.parse(amt) <= user.dollars) {
                              //         showDialog(
                              //           context: context,
                              //           builder: (context) {
                              //             return FutureProgressDialog(
                              //               Future.delayed(const Duration(
                              //                   milliseconds: 2000)),
                              //               message: const Text(
                              //                   "Request Processing..."),
                              //             );
                              //           },
                              //         );
                              //         Future.delayed(
                              //             const Duration(milliseconds: 1000),
                              //             () {
                              //           walletTransactionsChangeNotifier
                              //               .setTransactions();
                              //         });
                              //         Future.delayed(
                              //             const Duration(milliseconds: 1000),
                              //             () {
                              //           currentUserChangeNotifier
                              //               .setCurrentUser();
                              //         });
                              //         Future.delayed(
                              //             const Duration(milliseconds: 2000),
                              //             () {
                              //           walletTransactionsChangeNotifier
                              //               .setTransactions();
                              //           currentUserChangeNotifier
                              //               .setCurrentUser();
                              //           Navigator.of(context).pop();
                              //           Fluttertoast.showToast(
                              //               msg: 'Request Successful!');
                              //         });
                              //       } else {
                              //         Fluttertoast.showToast(
                              //             msg:
                              //                 'Amount cannot be greater than your total balance!');
                              //       }
                              //     },
                              //     child: Padding(
                              //       padding: const EdgeInsets.symmetric(
                              //           horizontal: 30.0, vertical: 12),
                              //       child: Center(
                              //         child: Text('Request',
                              //             style: Theme.of(context)
                              //                 .textTheme
                              //                 .headline6
                              //                 ?.copyWith(
                              //                     color: Colors.white,
                              //                     fontSize: 16,
                              //                     fontWeight: FontWeight.bold)),
                              //       ),
                              //     ),
                              //   ),
                              // )

                              // Container(
                              //   color: Colors.white,
                              //   height: MediaQuery.of(context).size.height,
                              //   width: MediaQuery.of(context).size.width,
                              //   child: ListView.builder(
                              //       scrollDirection: Axis.vertical,
                              //       itemCount: snapshot.data?.length,
                              //       itemBuilder: (context, index) {
                              //         return userCard(index, snapshot.data![index]['display_picture'], snapshot.data![index]['name'], snapshot.data![index]['gold']);
                              //       }
                              //   ),
                              // ),
                            ],
                          ),
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

  TextEditingController amount = TextEditingController();
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(color: Colors.grey),
    gapPadding: 10,
  );
  OutlineInputBorder outlineInputBorderFocused = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(color: Colors.grey),
    gapPadding: 10,
  );
  UnderlineInputBorder underlineInputBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
  );

  Widget buildAmountField() {
    return TextFormField(
      controller: amount,
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorderFocused,
        border: outlineInputBorder,
        hintText: "Enter amount",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (amount.text.isEmpty) {
          return 'This field is mandatory!';
        }
        if (double.parse(amount.text) <= 5) {
          return 'Minimum amount for withdrawal is \$5!';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget discountCard(String value, double dollars) {
    return InkWell(
      onTap: () {
        setState(() {
          amount.text = ((int.parse(value) / 100) * dollars).toString();
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.2,
        child: Card(
          color: Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text("$value%",
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.grey,
                      fontSize: MediaQuery.of(context).size.height * 0.019,
                      fontWeight: FontWeight.bold)),
            ),
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
                                    color: Colors.white,
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
                                    color: AppColors.orange,
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

  String amt = '0';
  Widget buildAmountDropDownField() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorderFocused,
        border: outlineInputBorder,
        hintText: "Select amount",
        labelText: "Amount",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        setState(() {
          amt = value.toString().split('\$')[1];
          print(amt);
        });
      },
      items: [
        '\$5',
        '\$10',
        '\$15',
        '\$20',
        '\$25',
        '\$50',
        '\$100',
        '\$150',
        '\$150'
      ].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget optionCardLong2(
      Color color,
      String text,
      String line1,
      String line2,
      String btnText,
      String btnText2,
      String anim,
      String reward,
      void Function() onTap,
      void Function() onTap2,
      double dollars) {
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
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(line2,
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
              Text(
                  "${("Select the amount you wish to withdraw").toUpperCase()}",
                  style: Theme.of(context).textTheme.headline5?.copyWith(
                      color: Colors.grey,
                      fontSize: MediaQuery.of(context).size.height * 0.019,
                      fontWeight: FontWeight.bold)),
              // Row(
              //   children: [
              //     discountCard("25", user.dollars),
              //     discountCard("50", user.dollars),
              //     discountCard("75", user.dollars),
              //     discountCard("100", user.dollars),
              //   ],
              // ),
              SizedBox(
                height: 15,
              ),
              buildAmountDropDownField(),

              // buildAmountField(),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: AppColors.primary),
                child: InkWell(
                  onTap: () {
                    bool status = false;
                    UserDatabaseHelper().cloudWithdraw(double.parse(amt));
                    if (double.parse(amt) >= 5 &&
                        amt != '0' &&
                        double.parse(amt) <= dollars) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return FutureProgressDialog(
                            Future.delayed(const Duration(milliseconds: 2000)),
                            message: const Text("Request Processing..."),
                          );
                        },
                      );
                      // Future.delayed(const Duration(milliseconds: 1000), () {
                      //   walletTransactionsChangeNotifier.setTransactions();
                      // });

                      Future.delayed(const Duration(milliseconds: 2000), () {
                        walletTransactionsChangeNotifier.setTransactions();
                      });
                      Future.delayed(const Duration(milliseconds: 1000), () {
                        currentUserChangeNotifier.setCurrentUser(true);
                      });
                      Future.delayed(const Duration(milliseconds: 2000), () {
                        Navigator.of(context).pop();
                        Fluttertoast.showToast(msg: 'Request Successful!');
                      });
                    } else {
                      Fluttertoast.showToast(
                          msg:
                              'Amount cannot be greater than your total balance!');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 12),
                    child: Center(
                      child: Text('Request',
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
              // Row(
              //   children: [
              //     Expanded(
              //       child: Container(
              //         width: double.infinity,
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.all(Radius.circular(10)),
              //             color: AppColors.primary),
              //         child: InkWell(
              //           onTap: onTap2,
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 30.0, vertical: 12),
              //             child: Center(
              //               child: Text(btnText2,
              //                   style: Theme.of(context)
              //                       .textTheme
              //                       .headline6
              //                       ?.copyWith(
              //                           color: Colors.white,
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.bold)),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //     SizedBox(
              //       width: 10,
              //     ),
              //     Expanded(
              //       child: Container(
              //         width: double.infinity,
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.all(Radius.circular(10)),
              //             color: AppColors.primary),
              //         child: InkWell(
              //           onTap: onTap,
              //           child: Padding(
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 30.0, vertical: 12),
              //             child: Center(
              //               child: Text(btnText,
              //                   style: Theme.of(context)
              //                       .textTheme
              //                       .headline6
              //                       ?.copyWith(
              //                           color: Colors.white,
              //                           fontSize: 16,
              //                           fontWeight: FontWeight.bold)),
              //             ),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // )
            ],
          )),
        ),
      ),
    );
    return SizedBox(
      child: Container(
          child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
              SizedBox(
                height: 10,
              ),
              Text(line1,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: AppColors.primary,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
              SizedBox(
                height: 10,
              ),
              Text(line2,
                  style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: AppColors.primary,
                      fontSize: 17,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      )),
    );
  }

  Widget transactionCard(amount, date, status, orderId, Timestamp time) {
    return Card(
        color: status == 'approved'
            ? Colors.green
            : status == 'pending'
                ? AppColors.green
                : status == 'paid'
                    ? Colors.green
                    : Colors.red,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Amount:',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                )),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.116,
                            ),
                            Text("\$${amount}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Status:',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                )),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.145,
                            ),
                            Text(status.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Last Update:',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                )),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.04,
                            ),
                            Text('${time.toDate()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Order Placed:',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                )),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.015,
                            ),
                            Text(
                                DateTime.fromMillisecondsSinceEpoch(date)
                                    .toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Order ID:',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                )),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.09,
                            ),
                            Text(orderId,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                )),
                          ],
                        ),
                      ],
                    ),
                  )
                ])));
  }
}
