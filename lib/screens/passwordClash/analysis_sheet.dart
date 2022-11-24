import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:uia/screens/profile/components/refer_earn.dart';
import 'package:uia/services/payement_method_notifier.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/constants.dart';
import '../../../models/User.dart';
import '../../../services/authentication/authentication_service.dart';
import '../../../services/data_streams/user_stream.dart';
import '../../../services/database/user_database_helper.dart';

class AnalysisSheet extends StatefulWidget {
  Map gameDetails;
  AnalysisSheet({Key? key, required this.gameDetails}) : super(key: key);

  @override
  State<AnalysisSheet> createState() => _AnalysisSheetState();
}

class _AnalysisSheetState extends State<AnalysisSheet> {
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
    return Padding(
      padding: const EdgeInsets.all(AppDefaults.padding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Row(
              children: [
                Spacer(),
                Text(
                  '${double.parse(widget.gameDetails['score11'].toString()).round() + double.parse(widget.gameDetails['score12'].toString()).round() + double.parse(widget.gameDetails['score13'].toString()).round()}  ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Lottie.asset('assets/pics/fight.json', height: 30),
                Text(
                  '  ${double.parse(widget.gameDetails['score21'].toString()).round() + double.parse(widget.gameDetails['score22'].toString()).round() + double.parse(widget.gameDetails['score23'].toString()).round()}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Spacer(),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
                color:  double.parse(widget.gameDetails['score11'].toString())
                    .round()> double.parse(widget.gameDetails['score21'].toString())
                    .round()? Colors.red.withOpacity(0.5): Colors.green.withOpacity(0.5),
                border: Border.all(color:  double.parse(widget.gameDetails['score11'].toString())
                    .round()> double.parse(widget.gameDetails['score21'].toString())
                    .round()? Colors.red: Colors.green, width: 2),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      double.parse(widget.gameDetails['score11'].toString())
                          .round()
                          .toString(),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.gameDetails['ans11'],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
                color:  double.parse(widget.gameDetails['score11'].toString())
                    .round()< double.parse(widget.gameDetails['score21'].toString())
                    .round()? Colors.red.withOpacity(0.5): Colors.green.withOpacity(0.5),
                border: Border.all(color:  double.parse(widget.gameDetails['score11'].toString())
                    .round()< double.parse(widget.gameDetails['score21'].toString())
                    .round()? Colors.red: Colors.green, width: 2),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      double.parse(widget.gameDetails['score21'].toString())
                          .round()
                          .toString(),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.gameDetails['ans21'],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
                color:  double.parse(widget.gameDetails['score11'].toString())
                    .round()> double.parse(widget.gameDetails['score21'].toString())
                    .round()? Colors.red.withOpacity(0.5): Colors.green.withOpacity(0.5),
                border: Border.all(color:  double.parse(widget.gameDetails['score11'].toString())
                    .round()> double.parse(widget.gameDetails['score21'].toString())
                    .round()? Colors.red: Colors.green, width: 2),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      double.parse(widget.gameDetails['score12'].toString())
                          .round()
                          .toString(),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.gameDetails['ans12'],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
                color:  double.parse(widget.gameDetails['score11'].toString())
                    .round()< double.parse(widget.gameDetails['score21'].toString())
                    .round()? Colors.red.withOpacity(0.5): Colors.green.withOpacity(0.5),
                border: Border.all(color:  double.parse(widget.gameDetails['score11'].toString())
                    .round()< double.parse(widget.gameDetails['score21'].toString())
                    .round()? Colors.red: Colors.green, width: 2),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      double.parse(widget.gameDetails['score22'].toString())
                          .round()
                          .toString(),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.gameDetails['ans22'],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
                color:  double.parse(widget.gameDetails['score11'].toString())
                    .round()> double.parse(widget.gameDetails['score21'].toString())
                    .round()? Colors.red.withOpacity(0.5): Colors.green.withOpacity(0.5),
                border: Border.all(color:  double.parse(widget.gameDetails['score11'].toString())
                    .round()> double.parse(widget.gameDetails['score21'].toString())
                    .round()? Colors.red: Colors.green, width: 2),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      double.parse(widget.gameDetails['score13'].toString())
                          .round()
                          .toString(),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.gameDetails['ans13'],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 30,
            decoration: BoxDecoration(
                color:  double.parse(widget.gameDetails['score11'].toString())
                    .round()< double.parse(widget.gameDetails['score21'].toString())
                    .round()? Colors.red.withOpacity(0.5): Colors.green.withOpacity(0.5),
                border: Border.all(color:  double.parse(widget.gameDetails['score11'].toString())
                    .round()< double.parse(widget.gameDetails['score21'].toString())
                    .round()? Colors.red: Colors.green, width: 2),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      double.parse(widget.gameDetails['score23'].toString())
                          .round()
                          .toString(),
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    widget.gameDetails['ans23'],
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                color: AppColors.primary),
            child: InkWell(
              onTap: () {Navigator.pop(context);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 12),
                child: Center(
                  child: Text('Close',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          )

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
    );
  }

  String? country;
  bool emailValid = true;
  bool numbValid = true;
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(color: Colors.grey),
    gapPadding: 10,
  );
  OutlineInputBorder outlineInputBorderFocused = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(color: AppColors.primary),
    gapPadding: 10,
  );
  UnderlineInputBorder underlineInputBorder = UnderlineInputBorder(
    borderSide: BorderSide(color: AppColors.primary),
  );
  Widget buildCountryField() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorderFocused,
        border: outlineInputBorder,
        hintText: "Select your country",
        labelText: "Country",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        setState(() {
          // switch(value) {
          //   case 'India' :
          //     method = 'Paytm';
          //     break;
          //   case 'Pakistan' :
          //     method = 'JazzCash';
          //     break;
          //   case 'Brazil' :
          //     method = 'PayPal';
          //     break;
          //   case 'Philippines' :
          //     method = 'PayPal';
          //     break;
          //   case 'Other Countries' :
          //     method = 'PayPal';
          //     break;
          // }

          country = value.toString();
        });
      },
      items: ['India', 'Pakistan', 'Philippines', 'Brazil', 'Global']
          .map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  String? method;
  Widget buildMethodsField() {
    return DropdownButtonFormField(
      decoration: InputDecoration(
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorderFocused,
        border: outlineInputBorder,
        hintText: "Select a payment method",
        labelText: "Payment Method",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) {
        setState(() {
          method = value.toString();
        });
      },
      items: country == 'India'
          ? [
              'Paytm',
            ].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList()
          : country == 'Pakistan'
              ? ['JazzCash'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()
              : country == 'Philippines'
                  ? [
                      'GCash',
                      'PayPal',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()
                  : country == 'Brazil'
                      ? [
                          'PIX',
                          'PayPal',
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()
                      : ['PayPal'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
    );
  }

  final TextEditingController accountNo = TextEditingController();
  final TextEditingController name = TextEditingController();

  Widget buildAccountNoField() {
    return TextFormField(
      controller: accountNo,
      enabled: country == null || method == null ? false : true,
      keyboardType: method == 'PayPal'
          ? TextInputType.emailAddress
          : method == 'Paytm'
              ? TextInputType.phone
              : TextInputType.number,
      decoration: InputDecoration(
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorderFocused,
        border: outlineInputBorder,
        hintText: method == 'PayPal'
            ? "Enter your email"
            : method == "Paytm"
                ? "Enter your phone number"
                : "Enter your account number",
        labelText: method == 'PayPal'
            ? "Your PayPal Email"
            : method == "Paytm"
                ? "Your Paytm Phone Number"
                : "Account/Phone No as per payment method",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      validator: (value) {
        if (accountNo.text.isEmpty) {
          return 'This field is mandatory!';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget buildAccountNameField() {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: TextFormField(
        enabled: country == null || method == null ? false : true,
        controller: name,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          enabledBorder: outlineInputBorder,
          focusedBorder: outlineInputBorderFocused,
          border: outlineInputBorder,
          hintText: "Enter your name",
          labelText: "Name associated with account",
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        validator: (value) {
          if (accountNo.text.isEmpty) {
            return 'This field is mandatory!';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
}
