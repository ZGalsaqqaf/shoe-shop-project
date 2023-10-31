import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

InputDecoration CustomInputDecoration(BuildContext context, String label) {
  return InputDecoration(
    labelText: '$label',
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.tertiary,
        width: 2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.tertiary,
      ),
    ),
  );
}
