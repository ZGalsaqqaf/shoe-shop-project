import 'package:flutter/material.dart';

List<String> colors = [
    'Black',
    'Brown',
    'White',
    'Grey',
    'Red',
    'Pink',
    'Blue',
    'Green',
    'Yellow',
  ];

Color getColorFromName(String colorName) {
    switch (colorName) {
      case 'Red':
        return Colors.red;
      case 'Blue':
        return Colors.blue;
      case 'Green':
        return Colors.green;
      case 'Yellow':
        return Colors.yellow;
      case 'Black':
        return Colors.black;
      case 'White':
        return Colors.white;
        case 'Brown':
        return Colors.brown;
      case 'Grey':
        return Colors.grey[700]!;
      case 'Pink':
        return Colors.pink;
      default:
        return Colors.black;
    }
  }