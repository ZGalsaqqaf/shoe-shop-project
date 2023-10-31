import 'package:flutter/material.dart';
import 'package:shoe_shop_3/models/user_model.dart';
import 'package:shoe_shop_3/reops/user_repo.dart';
import 'package:shoe_shop_3/widgets/custom_input_decoration.dart';
import '../../home_bottom_nav_var.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String _password = '';
  bool _obscurePassword = true;
  bool _obscureConfPassword = true;

  bool _isChecked = false;

  UserRepository users = UserRepository();

  bool _isEmailExist = false;
  bool _isUsernameExist = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            // Handle Home navigation
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return HomeBtmNavBarPage();
            }));
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
                    labelText: 'Password',
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
                    _password = value.trim();
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
                      bool isUsernameExists =
                          await users.isUsernameExists(_username);
                      bool isEmailExists = await users.isEmailExists(_email);

                      if (isUsernameExists) {
                        // Handle the case when the username already exists
                        setState(() {
                          _isUsernameExist = true;
                        });
                        print('Username already exists');
                        return;
                      }

                      if (isEmailExists) {
                        // Handle the case when the email already exists
                        setState(() {
                          _isEmailExist = true;
                        });
                        print('Email already exists');
                        return;
                      }
                      UserModel user = UserModel(
                        username: _username,
                        email: _email,
                        password: _password.trim(),
                      );
                      try {
                        UserModel addedUser = await users.addUser(user);
                        print('User added successfully: ${addedUser.username}');
                        setState(() {
                          _isEmailExist = false;
                          _isUsernameExist = false;
                        });
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) {
                            return LoginPage(
                              email: _email,
                              password: _password,
                              redirectPage: 'home',
                            );
                          }),
                        );
                      } catch (e) {
                        print('Failed to add user: $e');
                      }
                    }
                  },
                  child: Text(
                    'Submit',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                SizedBox(height: 10.0),
                _isUsernameExist
                    ? Center(
                        child: Text(
                          "Username is Already Exists",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : _isEmailExist
                        ? Center(
                            child: Text(
                              "Email is Already Exists",
                              style: TextStyle(color: Colors.red),
                            ),
                          )
                        : Text(""),
                SizedBox(height: 10.0),
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return LoginPage(
                        email: "",
                        password: "",
                        redirectPage: 'home',
                      );
                    }));
                  },
                  child: Text(
                    'Already have an account? Login',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
