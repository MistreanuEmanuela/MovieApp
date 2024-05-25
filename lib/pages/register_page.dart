import 'package:flutter/material.dart';
import 'dart:ui';
import '../helpers/database_helper.dart';
import '../models/user.dart';
import '../animated_dialog.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  
void _showAnimatedDialogWrong() {
  showDialog(
    context: context,
    builder: (context) => AnimatedDialog(
      icon: Icons.info_outline_rounded, // Pass the icon you want to display
      message: 'Account created succesful!', // Pass the message you want to display
    ),
  );
}

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      List<User> existingUsers = await _databaseHelper.users();
      if (existingUsers.any((user) => user.username == _usernameController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Username already exists!')));
        return;
      }

      User user = User(
        firstName: _firstNameController.text ?? '',
        lastName: _lastNameController.text ?? '',
        username: _usernameController.text ?? '',
        email: _emailController.text ?? '',
        password: _passwordController.text ?? '',
      );
      await _databaseHelper.insertUser(user);
      _showAnimatedDialogWrong();
      // Wait for 2 seconds before navigating
      await Future.delayed(Duration(seconds: 2));

      // Navigate to the home page or another screen after successful login
      Navigator.pushReplacementNamed(context, '/');  
      _firstNameController.clear();
      _lastNameController.clear();
      _usernameController.clear();
      _emailController.clear();
      _passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 6,
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 248, 241, 235),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    image: DecorationImage(
                      image: AssetImage('assets/images/photo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 140.0), // Adjust the top padding here
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'REGISTER ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'HandwritingFont',
                                  ),
                                ),
                                Text(
                                  'to movies word',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'ShrikhandRegular',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Container(
                  color: Color.fromARGB(255, 248, 241, 235),
                ),
              ),
            ],
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.0, 230.0, 20.0, 0.0),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Container(
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 248, 241, 235),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: _firstNameController,
                                  decoration: InputDecoration(
                                    labelText: 'First Name',
                                    prefixIcon: Icon(Icons.person),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 10.0,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a first name';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: _lastNameController,
                                  decoration: InputDecoration(
                                    labelText: 'Last Name',
                                    prefixIcon: Icon(Icons.person),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 10.0,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a last name';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: _usernameController,
                                  decoration: InputDecoration(
                                    labelText: 'Username',
                                    prefixIcon: Icon(Icons.account_circle),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 10.0,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a username';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: _emailController,
                                  decoration: InputDecoration(
                                    labelText: 'Email',
                                    prefixIcon: Icon(Icons.email),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 10.0,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter an email';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                                TextFormField(
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    labelText: 'Password',
                                    prefixIcon: Icon(Icons.lock),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12.0,
                                      horizontal: 10.0,
                                    ),
                                  ),
                                  obscureText: true,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a password';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 40),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.6,
                                  child: ElevatedButton.icon(
                                    onPressed: _register,
                                    label: Text('Register'),
                                    icon: Icon(Icons.person_add),
                                    style: ButtonStyle(
                                      side: MaterialStateProperty.all<BorderSide>(
                                        BorderSide(
                                          color: Color.fromARGB(255, 214, 214, 214), // Choose your border color
                                          width: 1.0, // Choose the width of the border
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

