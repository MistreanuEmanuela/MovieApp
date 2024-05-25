import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/user.dart';
import 'dart:ui';
import '../user_preferinces.dart';
import 'package:collection/collection.dart';
import '../animated_dialog.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
void _showAnimatedDialog() {
  showDialog(
    context: context,
    builder: (context) => AnimatedDialog(
      icon: Icons.expand_circle_down, // Pass the icon you want to display
      message: 'Login successful!', // Pass the message you want to display
    ),
  );
}
void _showAnimatedDialogWrong() {
  showDialog(
    context: context,
    builder: (context) => AnimatedDialog(
      icon: Icons.info_outline_rounded, // Pass the icon you want to display
      message: 'Username or password wrong!', // Pass the message you want to display
    ),
  );
}

void _login() async {
  if (_formKey.currentState!.validate()) {
    String username = _usernameController.text;
    String password = _passwordController.text;

    List<User> users = await _databaseHelper.users();
    User? currentUser = users.firstWhereOrNull(
        (user) => user.username == username && user.password == password);

    if (currentUser != null) {
      // Save user ID locally
      await UserPreferences.saveUserId(currentUser.id!);

      _showAnimatedDialog();
      // Wait for 2 seconds before navigating
      await Future.delayed(Duration(seconds: 2));

      // Navigate to the home page or another screen after successful login
      Navigator.pushReplacementNamed(context, '/homepage'); // Replace '/homepage' with the route name of the desired page
    } else {
       _showAnimatedDialogWrong();
      // Wait for 2 seconds before navigating
      
    }
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
                flex: 6, // Adjusted to 60% of screen height
                child: Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 248, 241, 235),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),
                    image: DecorationImage(
                      image: AssetImage(
                          'assets/images/photo.png'), // Path to your background image
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
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'LOGIN ',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                
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
              Expanded(
                flex: 4, // Adjusted to 40% of screen height
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
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
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
                              return 'Please enter a username';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: TextFormField(
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
                      ),
                      SizedBox(height: 40),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: ElevatedButton.icon(
                        onPressed: _login,
                        label: Text('Login'),
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
