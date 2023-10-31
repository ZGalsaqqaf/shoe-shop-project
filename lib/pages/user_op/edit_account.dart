import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../helper/auth_helper.dart';
import '../../models/user_model.dart';
import '../../reops/user_repo.dart';

class EditAccountPage extends StatefulWidget {
  final String userId;
  final String currentUsername;
  final String currentProfileImage;

  const EditAccountPage({
    Key? key,
    required this.userId,
    required this.currentUsername,
    required this.currentProfileImage,
  }) : super(key: key);

  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _creditCardController = TextEditingController();
  var _imgController = TextEditingController();

  var _selectedImageBytes; // nU

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      final imageBytes = await pickedImage.readAsBytes();
      final encodedImage = base64Encode(imageBytes);

      setState(() {
        _imgController.text = encodedImage;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.currentUsername;
    _imgController.text = widget.currentProfileImage;
    _creditCardController.text = AuthenticationProvider.userCreditCard ?? '';
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  UserRepository users = UserRepository();
  bool _isUserNameExist = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Account'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: FutureBuilder<UserModel?>(
          future: UserRepository().getById(widget.userId),
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
                return ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  CircleAvatar(
                                    radius: 100.0,
                                    backgroundColor: Colors.black,
                                    backgroundImage: _imgController.text !=
                                                null &&
                                            _imgController.text.isNotEmpty
                                        ? MemoryImage(base64Decode(
                                                _imgController.text))
                                            as ImageProvider<Object>?
                                        : userProfile != null &&
                                                userProfile.isNotEmpty
                                            ? MemoryImage(
                                                    base64Decode(userProfile))
                                                as ImageProvider<Object>?
                                            : AssetImage(
                                                "assets/images/profiles/profile1.png"),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.black, width: 2.0),
                                    ),
                                    child: CircleAvatar(
                                      radius: 25.0,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      child: IconButton(
                                        icon: Icon(Icons.edit,
                                            color: Colors.white),
                                        onPressed: _selectImage,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              // key: _formKey,
                              controller: _usernameController,
                              decoration: InputDecoration(
                                labelText: 'Username',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Username can not be empty';
                                }
                                if (value.length < 3) {
                                  return 'Must be at least 3 characters';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _creditCardController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Credit Card',
                              ),
                            ),
                            SizedBox(height: 16.0),
                            ElevatedButton(
                              onPressed: () async {
                                String newUsername =
                                    _usernameController.text.trim();
                                String newCreditCard =
                                    _creditCardController.text.trim();

                                print('====${_imgController.text}');
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  bool isUserNameExist =
                                      await users.isValueExistsOnAnotherId(
                                          thisUser.id ?? '',
                                          'Username',
                                          newUsername);
                                  if (isUserNameExist) {
                                    setState(() {
                                      _isUserNameExist = true;
                                    });
                                    return;
                                  }
                                  print("==================== cridet card: ${newCreditCard}");
                                  UserModel user = UserModel(
                                    username: newUsername,
                                    email: thisUser.email,
                                    password: thisUser.password,
                                    profile: _imgController.text,
                                    creditCard: newCreditCard,
                                  );
                                  try {
                                    UserModel addedUser = await users
                                        .updateUser(thisUser.id ?? '', user);
                                    print(
                                        'User updated successfully: ${addedUser.username}');
                                    setState(() {
                                      AuthenticationProvider.userName =
                                          newUsername;
                                      AuthenticationProvider.userProfile =
                                          _imgController.text;
                                      AuthenticationProvider.userCreditCard = newCreditCard;
                                      _isUserNameExist = false;
                                    });
                                    Navigator.of(context).pop(true);
                                  } catch (e) {
                                    print('Failed to update user: $e');
                                  }
                                } else {
                                  print("Form is invalid");
                                }
                              },
                              child: Text('Save'),
                            ),
                            _isUserNameExist
                                ? Center(
                                    child: Text(
                                      "This Username Already Exists",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  )
                                : Text(""),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return Text("User is empty!");
              }
            } else {
              return Text('No User found');
            }
          },
        ),
      ),
    );
  }
}
