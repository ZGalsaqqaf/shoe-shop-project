import 'package:flutter/material.dart';
import 'package:shoe_shop_3/helper/auth_helper.dart';
import 'package:shoe_shop_3/reops/user_repo.dart';

import '../../models/user_model.dart';

class AddCreditCardNumber extends StatefulWidget {
  const AddCreditCardNumber({Key? key, required this.userId}) : super(key: key);
  final String userId;

  @override
  State<AddCreditCardNumber> createState() => _AddCreditCardNumberState();
}

class _AddCreditCardNumberState extends State<AddCreditCardNumber> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _creditCardController = TextEditingController();

  @override
  void dispose() {
    _creditCardController.dispose();
    super.dispose();
  }

  UserRepository users = UserRepository();
  bool _isCreditCardExist = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Credit Card"),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _creditCardController,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a credit card number';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'Credit Card Number',
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
              ),
            ),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState?.validate() ?? false) {
                var newCredit = _creditCardController.text.trim();
                bool isCreditExists = await users.isValueExists(
                    'CreditCard', newCredit);
                if (!isCreditExists) {
                  try {
                    UserModel updateCredit = await users.updateOneField(
                        widget.userId,
                        'CreditCard',
                        '${newCredit}');
                    print(
                        'User updated successfully: ${widget.userId}, credit: ${newCredit}');
                    setState(() {
                      AuthenticationProvider.userCreditCard =
                          newCredit;
                    });
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Failed to update user: $e');
                  }
                  print(
                      "userId: ${widget.userId}, creditCard: ${_creditCardController.text}");
                } else {
                  setState(() {
                    _isCreditCardExist = true;
                  });
                  print('Repeated cridet:');
                }
              } else {
                // Form is invalid, display error message
                print("Error: Invalid form");
              }
            },
            child: Text('Submit'),
          ),
          _isCreditCardExist
              ? Center(
                  child: Text(
                    "This Credit Card Already Exists",
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : Text(""),
        ],
      ),
    );
  }
}
