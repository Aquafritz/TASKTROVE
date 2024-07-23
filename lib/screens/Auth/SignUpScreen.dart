// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, unused_local_variable, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasktroveprojects/screens/Auth/SignInScreen.dart';
import 'package:tasktroveprojects/screens/Auth/UserType.dart';
import 'package:tasktroveprojects/screens/Theme/ThemeProvider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _obscurePasswordText = true;
  bool _obscureConfirmPasswordText = true;
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _togglePasswordVisibility(bool isPressed) {
    setState(() {
      _obscurePasswordText = !isPressed;
    });
  }

  void _toggleConfirmPasswordVisibility(bool isPressed) {
    setState(() {
      _obscureConfirmPasswordText = !isPressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF8C52FF),
            Color(0xFFFF914D),
          ],
        ),
      ),
      child: Stack(children: [
        Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              SizedBox(
                height: 30,
              ),
              Container(
                width: 480,
                child: Card(
                  margin: EdgeInsets.all(20),
                  child: Container(
                    width: 500,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'Welcome to Task Trove! Let`s Get You Started',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                Color(0xFF8C52FF),
                                Color(0xFFFF914D),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 5),
                          height: 60,
                          width: 400,
                          child: CupertinoTextField(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200),
                            cursorColor:
                                isDarkMode ? Colors.white : Colors.black,
                            controller: _firstnameController,
                            prefix: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Icon(Icons.person_2_rounded, size: 30,)),
                            placeholder: 'First Name',
                            style: TextStyle(
                              fontSize: 20,
                                color:
                                    isDarkMode ? Colors.white : Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 60,
                          width: 400,
                          child: CupertinoTextField(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200),
                            cursorColor:
                                isDarkMode ? Colors.white : Colors.black,
                            controller: _lastnameController,
                            prefix: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Icon(Icons.person_2_rounded, size: 30,)),
                            placeholder: 'Last Name',
                            style: TextStyle(
                              fontSize: 20,
                                color:
                                    isDarkMode ? Colors.white : Colors.black),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 60,
                          width: 400,
                          child: CupertinoTextField(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200),
                            cursorColor: isDarkMode ? Colors.white : Colors.black,
                            controller: _emailController,
                            prefix: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Icon(Icons.email_rounded, size: 30,)),
                            placeholder: 'Email Address',
                            style: TextStyle(
                              fontSize: 20,
                                color: isDarkMode ? Colors.white : Colors.black),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 60,
                          width: 400,
                          child: CupertinoTextField(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200),
                            cursorColor: isDarkMode ? Colors.white : Colors.black,
                            controller: _passwordController,
                            prefix: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Icon(Icons.lock, size: 30,)),
                            placeholder: 'Password',
                            style: TextStyle(
                              fontSize: 20,
                                color: isDarkMode ? Colors.white : Colors.black),
                            obscureText: _obscurePasswordText,
                            suffix: Container(
                              margin: EdgeInsets.only(right: 10.0),
                              child: GestureDetector(
                                onTapDown: (_) => _togglePasswordVisibility(true),
                                onTapUp: (_) => _togglePasswordVisibility(false),
                                onTapCancel: () =>
                                    _togglePasswordVisibility(false),
                                child: Icon(
                                  _obscurePasswordText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                      size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          height: 60,
                          width: 400,
                          child: CupertinoTextField(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                color: isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200),
                            cursorColor: isDarkMode ? Colors.white : Colors.black,
                            controller: _confirmPasswordController,
                            prefix: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Icon(Icons.lock, size: 30,)),
                            placeholder: 'Confirm Password',
                            style: TextStyle(
                              fontSize: 20,
                                color: isDarkMode ? Colors.white : Colors.black),
                            obscureText: _obscureConfirmPasswordText,
                            suffix: Container(
                              margin: EdgeInsets.only(right: 10.0),
                              child: GestureDetector(
                                onTapDown: (_) =>
                                    _toggleConfirmPasswordVisibility(true),
                                onTapUp: (_) =>
                                    _toggleConfirmPasswordVisibility(false),
                                onTapCancel: () =>
                                    _toggleConfirmPasswordVisibility(false),
                                child: Icon(
                                  _obscureConfirmPasswordText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                      size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          width: 250,
                          height: 35,
                          margin: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blueAccent),
                              elevation: MaterialStateProperty.all<double>(5),
                            ),
                            onPressed: () {
                              _validator();
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          height: 3,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.transparent,
                                Color(0xFF8C52FF),
                                Color(0xFFFF914D),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Already have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignInScreen()),
                                );
                              },
                              child: Text(
                                'LogIn Now',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ]),
    ));
  }

  bool isFirstLetterUppercase(String name) {
    if (name.isEmpty) return false;
    return name[0] == name[0].toUpperCase();
  }

  void _validator() {
    String firstname = _firstnameController.text.trim();
    String lastname = _lastnameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmpassword = _confirmPasswordController.text.trim();

    if (firstname.isEmpty ||
        lastname.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmpassword.isEmpty) {
      _showDialog('Empty Fields', 'Please fill in all fields.');
      return;
    }
    if (password != confirmpassword) {
      _showDialog('Password Mismatch', 'Passwords do not match.');
      return;
    }

    RegExp regex = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_-]).{8,}$');

    if (!regex.hasMatch(password)) {
      _showDialog('Weak Password',
          'Password must contain at least 8 characters, including uppercase letters, lowercase letters, numbers, and symbols.');
      return;
    }

    if (!isFirstLetterUppercase(firstname) ||
        !isFirstLetterUppercase(lastname)) {
      _showDialog('Invalid Name Format',
          'First name and last name must start with an uppercase letter.');
      return;
    }

    _createAccount(email, password);
  }

  Future<void> _createAccount(
    String email,
    String password,
  ) async {
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String uid = userCredential.user?.uid ?? '';

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UserType(
                  firstName: _firstnameController.text.trim(),
                  lastName: _lastnameController.text.trim(),
                  email: _emailController.text.trim(),
                  uid: uid,
                )),
      );
    } catch (error) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(error.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  void _showDialog(String title, String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'OK',
                style: TextStyle(color: Colors.blueAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
