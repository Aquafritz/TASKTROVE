// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, use_build_context_synchronously, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasktroveprojects/screens/ClientUi/Client.dart';
import 'package:tasktroveprojects/screens/FreelanceUi/Freelancer.dart';
import 'package:tasktroveprojects/screens/Theme/ThemeProvider.dart';

class UserType extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String uid; 

  const UserType({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.uid,
    super.key});

  @override
  State<UserType> createState() => _UserTypeState();
}

class _UserTypeState extends State<UserType> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
 bool isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
        body: Center(
            child: Container(
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
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Container(
                            width: 480,
                            child: Card(
                              color: isDarkMode ? Colors. grey.shade900
                                        :Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Task Trove',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                        padding: EdgeInsets.only(left: 20),
                                        alignment: Alignment.topLeft,
                                        child:
                                            Text('Please Select Account Type',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                ))),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        _saveAccountType("Client", context);
                                      },
                                      child: Card(
                                         color: isDarkMode ? Colors. grey.shade800
                                        :Colors.grey.shade200,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                'assets/client.png',
                                                width: 150,
                                                height: 150,
                                                fit: BoxFit.contain,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'I want to Hire',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward,
                                                size: 30,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
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
                                      height: 30,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                       _saveAccountType("Freelance", context);
                                      },
                                      child: Card(
                                        color: isDarkMode ? Colors. grey.shade800
                                        :Colors.grey.shade200,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Image.asset(
                                                'assets/freelancer.png',
                                                width: 150,
                                                height: 150,
                                                fit: BoxFit.contain,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'I want to Work',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Icon(
                                                Icons.arrow_forward,
                                                size: 30,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ]
              ),
            )
          ]
        )
      )
    )
  );
}

   Future<void> _saveAccountType(String accountType, BuildContext context) async {
  try {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .set({
            'uid': currentUser.uid,
            'accountType': accountType,
            'firstName': widget.firstName,
            'lastName': widget.lastName,
            'email': widget.email,
            'subscriptionStatus': 'Not Subscribed'
            });

      if (accountType == "Client") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ClientHomeScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FreelanceHomeScreen()),
        );
      }
    } else {
      print("No user is currently logged in.");
    }
  } catch (error) {
    print("Error saving account type: $error");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error saving account type')),
    );
  }
}
}