import 'package:flutter/material.dart';
import 'package:shoe_shop_3/models/user_model.dart';
import 'package:shoe_shop_3/reops/user_repo.dart';
import 'package:shoe_shop_3/widgets/custom_input_decoration.dart';
import '../../helper/auth_helper.dart';
import 'login.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _password = '';
  bool _obscurePassword = true;
  bool _obscureConfPassword = true;

  bool _isChecked = false;

  UserRepository users = UserRepository();

  bool _matchUsernameAndEmail = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Handle Home navigation
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Form(
            // autovalidateMode: AutovalidateMode.onUserInteraction,
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: CustomInputDecoration(context, "Username"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    if (value.length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: CustomInputDecoration(context, "Emali"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    final emailRegex =
                        r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
                    if (!RegExp(emailRegex).hasMatch(value)) {
                      return 'Invalid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Reset Password',
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
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: _obscurePassword,
                  onChanged: (value) {
                    _password = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 3) {
                      return 'Password must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
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
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureConfPassword = !_obscureConfPassword;
                        });
                      },
                      child: Icon(
                        _obscureConfPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                  obscureText: _obscureConfPassword,
                  validator: (value) {
                    if (value != _password) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(200, 45)),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      String _username = _usernameController.text.trim();
                      String _email = _emailController.text.trim();
                      bool _isMatchUsernameAndPassword =
                          await users.UserNameAndEmailCheckMatching(
                              _email, _username);

                      if (_isMatchUsernameAndPassword) {
                        setState(() {
                          _matchUsernameAndEmail = false;
                        });
                        List<UserModel> _user = await users.getByField(
                            'email', _emailController.text);
                        var uId = _user[0].id;
                        var uName = _user[0].username;
                        var uEmail = _user[0].email;
                        var uProfile = _user[0].profile;
                        var uCredit = _user[0].creditCard;
                        print(
                            "============= User matched.. id: ${uId}, username:${uName}, email: ${uEmail}");
                        try {
                          UserModel updateCredit = await users.updateOneField(
                              uId ?? '', 'Password', '${_password.trim()}');
                          print(
                              'update password successfully: userId: ${_isMatchUsernameAndPassword}');
                          AuthenticationProvider.login(
                            uId ?? '',
                            uName ?? '',
                            uEmail ?? '',
                            uProfile ?? '',
                            uCredit ?? '',
                          );
                          print(
                              "=============AuthenticationProvider:: User matched.. id: ${AuthenticationProvider.userId}, username:${AuthenticationProvider.userName}, email: ${AuthenticationProvider.userEmail}");

                          Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return LoginPage(email: _email, password: _password, redirectPage: 'home',);
                          }),
                          );
                        } catch (e) {
                          print('Failed to add user: $e');
                        }
                      } else {
                        print("============= Not match =============");
                        setState(() {
                          _matchUsernameAndEmail = true;
                        });
                      }
                    } else {
                      print("Invalid form");
                    }
                  },
                  child: Text(
                    'Submit',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                SizedBox(height: 10.0),
                SizedBox(height: 10.0),
                _matchUsernameAndEmail
                    ? Center(
                        child: Text(
                          "Don't much Username and Email",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : Text(""),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
