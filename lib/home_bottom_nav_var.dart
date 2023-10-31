import 'package:flutter/material.dart';

import 'myclasses/btmNavBarPages.dart';
import 'widgets/custom_botto_nav_bar.dart'; // Update with the correct import path

class HomeBtmNavBarPage extends StatefulWidget {
  const HomeBtmNavBarPage({Key? key});

  @override
  State<HomeBtmNavBarPage> createState() => _HomeBtmNavBarPageState();
}

class _HomeBtmNavBarPageState extends State<HomeBtmNavBarPage> {
  int _currentIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomBtmNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          print("==== bottom index: $index ===");
        },
      ),
      body: pagesList[_currentIndex],
    );
  }
}