import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uia/models/user.dart';
import 'package:uia/screens/profile/components/refer_earn.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/constants.dart';
// import '../../../models/User.dart';
import '../../../services/authentication/authentication_service.dart';
import '../../../services/data_streams/user_stream.dart';
import '../../../services/database/user_database_helper.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final UserStream userStream = UserStream();
  bool editing = false;
  TextEditingController nameController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
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
      // appBar: AppBar(
      //   elevation: 3,
      //   backgroundColor: Colors.white,
      //   title: const Text("Edit Profile 👤", style: TextStyle(color: Colors.black),),
      //   automaticallyImplyLeading: true,
      //   centerTitle: true,
      //   iconTheme: IconThemeData(color: Colors.black),
      //
      // ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where('email',
                  isEqualTo: AuthenticationService().currentUser?.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: const Text('Loading...'));
            else {
              UserData userData = UserData.fromMap(
                  snapshot.data!.docs[0].data() as Map<String, dynamic>,
                  id: snapshot.data!.docs[0].id);
              log(snapshot.data!.docs[0].data().toString());
              nameController.text = userData.name;
              ageController.text = userData.age.toString();
              emailController.text = userData.email.toString();
              return Padding(
                padding: const EdgeInsets.all(AppDefaults.padding),
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.white,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            CircleAvatar(
                              backgroundColor: AppColors.primary,
                              radius: 53,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(userData.dpUrl),
                                radius: 50,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            // Text("${userData.name}",
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .headline5
                            //         ?.copyWith(
                            //             color: AppColors.primary,
                            //             fontSize:
                            //                 MediaQuery.of(context).size.height *
                            //                     0.028,
                            //             fontWeight: FontWeight.bold)),
                            TextField(
                                controller: nameController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        // style: BorderStyle.solid,
                                        width: 2,
                                        color:
                                            AppColors.primary), //<-- SEE HERE
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        // style: BorderStyle.solid,
                                        width: 2,
                                        color:
                                            AppColors.primary), //<-- SEE HERE
                                  ),
                                  labelText: 'Full Name',
                                ),
                                onChanged: (newValue) {
                                  // nameController.text = newValue;
                                }),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025,
                            ),
                            TextField(
                                controller: ageController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        // style: BorderStyle.solid,
                                        width: 2,
                                        color:
                                            AppColors.primary), //<-- SEE HERE
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        // style: BorderStyle.solid,
                                        width: 2,
                                        color:
                                            AppColors.primary), //<-- SEE HERE
                                  ),
                                  labelText: 'Age',
                                ),
                                onChanged: (newValue) {
                                  // nameController.text = newValue;
                                }),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025,
                            ),
                            TextField(
                                controller: emailController,
                                enabled: false,
                                decoration: InputDecoration(
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        // style: BorderStyle.solid,
                                        width: 2,
                                        color:
                                            AppColors.primary), //<-- SEE HERE
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        // style: BorderStyle.solid,
                                        width: 2,
                                        color:
                                            AppColors.primary), //<-- SEE HERE
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: BorderSide(
                                        // style: BorderStyle.solid,
                                        width: 2,
                                        color:
                                            AppColors.primary), //<-- SEE HERE
                                  ),
                                  labelText: 'Email Address',
                                ),
                                onChanged: (newValue) {
                                  // nameController.text = newValue;
                                }),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            InkWell(
                              onTap: () async {
                                await UserDatabaseHelper().updateUserData(
                                    nameController.text, ageController.text);
                                Fluttertoast.showToast(
                                    msg: "Profile Updated",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    fontSize: 16.0);
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                width: MediaQuery.of(context).size.width * 0.8,
                                decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    color: AppColors.primary),
                                child: Center(
                                  child: Text('Update Profile',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      // child: ListView.builder(
                      //     scrollDirection: Axis.vertical,
                      //     itemCount: snapshot.data?.length,
                      //     itemBuilder: (context, index) {
                      //       return userCard(
                      //           index,
                      //           snapshot.data![index]['profileImage'],
                      //           snapshot.data![index]['name'],
                      //           snapshot.data![index]['coins']);
                      //     }),
                    ),
                  ),
                ),
              );
            }
          }),
    );
  }

  Widget userCard(rank, url, name, gold) {
    return Card(
      color: AuthenticationService().currentUser?.displayName != name
          ? AppColors.primary
          : Colors.green,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
                flex: 5,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.complimentary,
                      radius: 21,
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(url!),
                        radius: 18,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            )),
                        Text('$gold 🥇',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            )),
                      ],
                    ),
                  ],
                )),
            rank == 0 || rank == 1 || rank == 2 || rank == 3 || rank == 4
                ? Flexible(
                    flex: 2,
                    child: Text('\$ ${rew[rank + 1]}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        )),
                  )
                : Flexible(
                    flex: 2,
                    child: Text('# ${rank + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        )),
                  ),
          ],
        ),
      ),
    );
  }

  var rew = [0, 1, 0.5, 0.5, 0.25, 0.25];
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
                          color: AppColors.orange,
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
