// ignore_for_file: prefer_const_constructors, file_names, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_print, sized_box_for_whitespace

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasktroveprojects/screens/Auth/SignInScreen.dart';
import 'package:tasktroveprojects/screens/Auth/SignUpScreen.dart';
import 'package:tasktroveprojects/screens/Theme/ThemeProvider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text.trim());
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              content: Text('Password reset Link Sent! Check your Email'),
            );
          });
          Future.delayed(Duration(seconds: 3),() {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
          }
        );
    } on FirebaseAuthException catch (e) {
      print(e);
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              content: Text(e.message.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close',style: TextStyle(color: Colors.blueAccent),),
                ),
              ],
            );
          }
        );
      }
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
            child: Center(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(children: [
                    SizedBox(
                                height: 20,
                              ),
                                Container(
                    width: 275,
                    height: 275,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white70),
                    child: Image.asset(
                      'assets/tasktrovelogo.png',
                    )),
                    SizedBox(
                      height: 20,
                    ),
                                Card(
                    margin: EdgeInsets.all(20),
                    child: Container(
                      width: 500,
                      padding: EdgeInsets.all(16.0),
                      child: Column(children: [
                       Container(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Forgot Password?',
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
                            'Please enter the email address associated with your account to reset your password.',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                              ),
                              SizedBox(
                                height: 20,
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
                          height: 60,
                          width: 400,
                          child: CupertinoTextField(
                            decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(8.0),
                              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200
                            ),
                            cursorColor: isDarkMode ? Colors.white : Colors.black,
                  
                            controller: _emailController,
                            prefix: Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Icon(Icons.email_rounded,size: 30,)),
                            placeholder: 'Email Address',
                            style: 
                            TextStyle(
                              fontSize: 20,
                              color: isDarkMode 
                              ? Colors.white 
                              : Colors.black
                              ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.blueAccent),
                                  elevation: MaterialStateProperty.all<double>(5),
                                ),
                                onPressed: passwordReset,
                                child: Text(
                                  'Reset Password',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                )
                                )
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
                        SizedBox(height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                            width: 140,
                            height: 35,
                            margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.lightGreen),
                                  elevation: MaterialStateProperty.all<double>(5),
                                ),
                                onPressed: () {
                                Navigator.push(context, 
                                MaterialPageRoute(builder: (context) => SignInScreen()));
                              }, 
                              child: Text('SignIn',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                              )
                              ),
                                ),
                                Container(
                            width: 140,
                            height: 35,
                            margin: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.lightGreen),
                                  elevation: MaterialStateProperty.all<double>(5),
                                ),
                                onPressed: () {
                                Navigator.push(context, 
                                MaterialPageRoute(builder: (context) => SignUpScreen()));
                              }, 
                              child: Text('SignUp',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                    )
                              ),
                            ),                      
                          ]
                        )
                      ]
                    ),
                  )
                                )
                              ]
                            ),
                )
        )
      )
    );
  }
}
