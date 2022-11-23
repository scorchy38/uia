import 'package:uia/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'components/profile_user_data.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   elevation: 3,
      //   backgroundColor: Colors.white,
      //   title: const Text("Profile🤑️", style: TextStyle(color: Colors.black),),
      //   centerTitle: true,
      //   leading: const Text(''),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            // ProfilePageHeader(),
            UserDataPage(),
            // PersonalInformation(),
          ],
        ),
      ),
    );
  }
}
