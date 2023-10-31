import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shoe_shop_3/pages/extra_pages/about.dart';
import 'package:shoe_shop_3/pages/user_op/account.dart';
import 'package:shoe_shop_3/pages/extra_pages/search.dart';

import '../helper/auth_helper.dart';
import '../pages/user_op/login.dart';

AppBar SearchAppBar(BuildContext context) {
  bool isLoggedIn = AuthenticationProvider.isLoggedIn.value;
  String? uProfile = AuthenticationProvider.userProfile;

  return AppBar(
    centerTitle: true,
    backgroundColor: Theme.of(context).colorScheme.primary,
    title: Container(
      height: 40.0,
      width: 300.0,
      child: TextField(
        decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            prefixIcon: Icon(
              Icons.search,
              color: Color.fromARGB(168, 82, 80, 80),
            ),
            hintText: 'Search',
            hintStyle: TextStyle(
              color: Color.fromARGB(168, 71, 70, 70),
            )),
        onSubmitted: (value) {
          // Perform search action with the submitted value
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return SearchPage(value: value);
          }));
        },
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 20),
        child: isLoggedIn
            ? GestureDetector(
                onTap: () {
                  // print("============ ${AuthenticationProvider.userId} ==========");
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return UserAccount();
                  }));
                },
                child: CircleAvatar(
                  backgroundImage: uProfile!.isNotEmpty
                      ? MemoryImage(base64Decode(uProfile))
                          as ImageProvider<Object>?
                      : AssetImage("assets/images/profiles/profile1.png"),
                ),
              )
            : GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return LoginPage(
                      email: "",
                      password: "",
                      redirectPage: 'home',
                    );
                  }));
                },
                child: Icon(Icons.login),
              ),
      )
    ],
  );
}
