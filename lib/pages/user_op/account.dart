import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoe_shop_3/models/user_model.dart';
import 'package:shoe_shop_3/pages/user_op/edit_account.dart';
import 'package:shoe_shop_3/reops/user_repo.dart';
import '../../helper/auth_helper.dart';
import '../../home_bottom_nav_var.dart';
import '../../widgets/custom_drawer_app_mode.dart';
import '../../widgets/search_appbar.dart';

class UserAccount extends StatefulWidget {
  const UserAccount({super.key});

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  IconData appModeIcon = Icons.sunny;

  void updateAppModeIcon(IconData newIcon) {
    setState(() {
      appModeIcon = newIcon;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _userId = AuthenticationProvider.userId;
    return Scaffold(
      appBar: SearchAppBar(context),
      drawer: CustomDrawerWithAppMode(context, updateAppModeIcon),
      body: Container(
        padding: EdgeInsets.all(16),
        child: FutureBuilder<UserModel?>(
          future: UserRepository().getById(_userId ?? ''),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              UserModel? thisUser = snapshot.data!;
              if (thisUser != null) {
                var userId = thisUser.id;
                var userName = thisUser.username;
                var userEmail = thisUser.email;
                var userProfile = thisUser.profile;

                return Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 100.0,
                            backgroundColor: Colors.black,
                            backgroundImage: userProfile != null &&
                                    userProfile.isNotEmpty
                                ? MemoryImage(base64Decode(userProfile))
                                    as ImageProvider<Object>?
                                : AssetImage("assets/images/profiles/profile1.png"),
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Welcome, $userName!',
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Email: $userEmail',
                            style: Theme.of(context).textTheme.headline2,
                          ),
                          SizedBox(height: 16.0),
                          ElevatedButton(
                            onPressed: () async {
                              var isEditProfile = Navigator.of(context)
                                  .push(MaterialPageRoute(builder: (context) {
                                return EditAccountPage(
                                  userId: userId ?? '',
                                  currentUsername: userName ?? '',
                                  currentProfileImage: userProfile ?? '',
                                );
                              }))..then((_) {
                                setState(() {});
                              });
                                print("====== isEditProfile:  $isEditProfile ======");
                              if (isEditProfile != null) {
                                print("hello==========");
                              }
                            },
                            child: Text(
                              'Edit',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                          SizedBox(height: 20.0),
                          ElevatedButton(
                            onPressed: () {
                              AuthenticationProvider.logout();
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) {
                                  return HomeBtmNavBarPage();
                                }),
                              );
                            },
                            child: Text(
                              'Logout',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return Text("User is empty!");
              }
            } else {
              return Text('No thisProduct found');
            }
          },
        ),
      ),
    );
  }
}
