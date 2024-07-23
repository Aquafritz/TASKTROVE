// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, sized_box_for_whitespace, unused_field, unnecessary_nullable_for_final_variable_declarations, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasktroveprojects/screens/AdminUi/AdminHome.dart';
import 'package:tasktroveprojects/screens/ClientUi/Client.dart';
import 'package:tasktroveprojects/screens/FreelanceUi/Freelancer.dart';
import 'package:tasktroveprojects/screens/Auth/ForgotPassword.dart';
import 'package:tasktroveprojects/screens/Auth/SignUpScreen.dart';
import 'package:tasktroveprojects/screens/Theme/ThemeProvider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _obscureText = true;
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadRememberMe();
  }

  void _togglePasswordVisibility(bool isPressed) {
    setState(() {
      _obscureText = !isPressed;
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
            child: Column(mainAxisAlignment: MainAxisAlignment.start, 
            children: [
              SizedBox(
                height: 70,
              ),
              Container(
                  width: 275,
                  height: 275,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white70),
                  child: Image.asset(
                    'assets/tasktrovelogo.png',
                  )),
              Container(
                width: 480,
                child: Card(
                  margin: EdgeInsets.all(20),
                  child: Container(
                    width: 500,
                    height: 460,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 40,
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
                            'Get Back to Task Trove with Your Account',
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
                            cursorColor: isDarkMode ? Colors.white : Colors.black,
                            controller: _emailController,
                            prefix: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Icon(Icons.email_rounded, size: 30,)),
                            placeholder: 'Email Address',
                            style: TextStyle(
                              fontSize: 20,
                                color: isDarkMode ? Colors.white : Colors.black),
                            onTap: () {
                              _showRecentAccounts();
                            },
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
                              child: Icon(Icons.lock, size: 30,),
                            ),
                            placeholder: 'Password',
                            style: TextStyle(
                              fontSize: 20,
                                color: isDarkMode ? Colors.white : Colors.black),
                            obscureText: _obscureText,
                            suffix: Container(
                              margin: EdgeInsets.only(right: 10.0),
                              child: GestureDetector(
                                onTapDown: (_) => _togglePasswordVisibility(true),
                                onTapUp: (_) => _togglePasswordVisibility(false),
                                onTapCancel: () =>
                                    _togglePasswordVisibility(false),
                                child: Icon(
                                  _obscureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                      size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Checkbox(
                              activeColor: Colors.blueAccent,
                              checkColor: Colors.white,
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                            ),
                            Text('Remember Me'),
                            SizedBox(
                              width: 55,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ForgotPassword()),
                                  );
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(color: Colors.blueAccent),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                              _checkEmailandPasswords();
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
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
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?"),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpScreen()),
                                );
                              },
                              child: Text(
                                'Register Now',
                                style: TextStyle(color: Colors.blueAccent),
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

  void _checkEmailandPasswords() {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    if (password.isEmpty || email.isEmpty) {
      _showDialog('Empty Fields', 'Please fill in both fields.');
      return;
    }

    RegExp regex = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_-]).{8,}$',
    );

    if (!regex.hasMatch(password)) {
      _showDialog('Weak Password',
          'Password must contain at least 8 characters, including uppercase letters, lowercase letters, numbers, and symbols.');
      return;
    }
    RegExp emailRegex = RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]");

    if (!emailRegex.hasMatch(email)) {
      _showDialog('Invalid Mobile Number or Email',
          'Please Enter Valid Mobile Number or Email');
      return;
    }
    _signIn(); // Call the _signIn method if all validations pass
  }

  Future<void> _signIn() async {
    try {
      final String email = _emailController.text.trim();
      final UserCredential? userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (userCredential?.user != null) {
        final QuerySnapshot userDocs = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .get();

        if (userDocs.docs.isNotEmpty) {
          final accountType = (userDocs.docs.first.data()
              as Map<String, dynamic>?)?['accountType'];
          if (accountType == "Client") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClientHomeScreen()),
            );
          } else if (accountType == "Freelance") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FreelanceHomeScreen()),
            );

            } else if (accountType == "Admin") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AdminHomeScreen()),
            );

          } else {
            _showDialog('Invalid Account Type', 'Invalid account type.');
          }
          _saveRememberMe(true, email); // Save the email
        } else {
          _showDialog('User Not Found', 'User document not found.');
        }
      } else {
        _showDialog('Login Failed', 'Invalid email or password.');
      }
    } catch (error) {
      String errorMessage = 'An error occurred. Please try again later.';
      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          errorMessage = 'No user found with this email.';
        } else if (error.code == 'wrong-password') {
          errorMessage = 'Invalid password.';
        }
      }
      _showDialog('Login Failed', errorMessage);
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

  void _loadRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });
    if (_rememberMe) {
      List<String>? rememberedEmails = prefs.getStringList('rememberedEmails');
      if (rememberedEmails != null && rememberedEmails.isNotEmpty) {
        _emailController.text =
            rememberedEmails.last; // Set the first remembered email
      }
    }
  }

  void _saveRememberMe(bool value, [String? email]) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _rememberMe = value;
    if (_rememberMe) {
      List<String> rememberedEmails =
          prefs.getStringList('rememberedEmails') ?? [];
      if (!rememberedEmails.contains(email)) {
        rememberedEmails
            .add(email!); // Add the email to the list of remembered emails
        prefs.setStringList('rememberedEmails', rememberedEmails);
      }
    } else {
      // Handle the case when Remember Me is unchecked
      prefs.remove('rememberedEmails');
    }
    prefs.setBool('rememberMe', _rememberMe);
  }

  void _showRecentAccounts() {
    if (_rememberMe) {
      SharedPreferences.getInstance().then((prefs) {
        List<String> rememberedEmails =
            prefs.getStringList('rememberedEmails') ?? [];

        if (rememberedEmails.isNotEmpty) {
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
              bool isDarkMode = themeProvider.isDarkMode;
              return CupertinoAlertDialog(
                title: Text('Recently Signed-In Accounts'),
                content: SizedBox(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: rememberedEmails.map((email) {
                      return TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _emailController.text =
                              email; // Set the email in the email field
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Text(
                            email,
                            style: TextStyle(
                                fontSize: 18,
                                color:
                                    isDarkMode ? Colors.white : Colors.black),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ),
                ],
              );
            },
          );
        }
      });
    }
  }
}
