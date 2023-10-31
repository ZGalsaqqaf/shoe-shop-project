import 'package:flutter/material.dart';
import 'package:shoe_shop_3/reops/user_repo.dart';
import '../../helper/auth_helper.dart';
import '../../home_bottom_nav_var.dart';
import '../../models/user_model.dart';
import 'regester.dart';
import '../../widgets/custom_input_decoration.dart';
import 'forget_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
    required this.email,
    required this.password,
    required this.redirectPage,
  }) : super(key: key);

  final String email;
  final String password;
  final String redirectPage;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _password = '';
  bool _obscurePassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  UserRepository user = UserRepository();
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
    _passwordController.text = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: CustomInputDecoration(context, "Email"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Validate email format
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
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      // labelStyle:  Theme.of(context).textTheme.bodyText2,
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
                  ElevatedButton(
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all(Size(200, 45)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        bool isAuthenticated = await user.authenticateUser(
                            _emailController.text.trim(), _passwordController.text.trim());

                        if (isAuthenticated) {
                          setState(() {
                            _isAuthenticated = false;
                          });
                          print('Logged in successfully');
                          List<UserModel> users = await user.getByField(
                              'email', _emailController.text);
                          var userId = users[0].id;
                          var userName = users[0].username;
                          var userEmail = users[0].email;
                          var userProfile = users[0].profile;
                          var userCreditCard = users[0].creditCard;
                          AuthenticationProvider.login(
                            userId ?? '',
                            userName ?? '',
                            userEmail ?? '',
                            userProfile ?? '',
                            userCreditCard ?? '',
                          );
                          if (widget.redirectPage == 'home' ||
                              widget.redirectPage == '') {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                                return HomeBtmNavBarPage();
                              }),
                            );
                          } else if (widget.redirectPage == 'pop') {
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          }
                        } else {
                          setState(() {
                            _isAuthenticated = true;
                          });
                          print('Email and password do not exist');
                        }
                      }
                    },
                    child: Text(
                      'Submit',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ForgetPassword();
                          }));
                        },
                        child: Text(
                          "Forget Password ?",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: 3.0),
                  _isAuthenticated
                      ? Center(
                          child: Text(
                            "Can't find this account",
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : Text(""),
                  // SizedBox(height: 3.0),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create new account? ",
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return RegisterPage();
                          }));
                        },
                        child: Text(
                          "Register",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
