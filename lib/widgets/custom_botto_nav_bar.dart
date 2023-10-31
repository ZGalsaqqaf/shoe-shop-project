import 'package:flutter/material.dart';

class CustomBtmNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBtmNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Color.fromARGB(255, 138, 101, 88),
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const[
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.store),
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.category),
          label: 'Category',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.new_label),
          label: 'New',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.person),
        //   label: 'Me',
        // ),
      ],
    );
  }
}