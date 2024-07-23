// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, avoid_print, non_constant_identifier_names, unnecessary_null_in_if_null_operators, unnecessary_cast
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tasktroveprojects/Loading.dart';
import 'package:tasktroveprojects/screens/Auth/SignInScreen.dart';
import 'package:tasktroveprojects/screens/ClientUi/ClientMessageScreen.dart';
import 'package:tasktroveprojects/screens/ClientUi/ClientProfileScreen.dart';
import 'package:tasktroveprojects/screens/ClientUi/ClientSettings.dart';
import 'package:tasktroveprojects/screens/ClientUi/LibraryManagementSystem.dart';
import 'package:tasktroveprojects/screens/Portfolio/BackEndDeveloper.dart';
import 'package:tasktroveprojects/screens/Portfolio/FrontEndDeveloper.dart';
import 'package:tasktroveprojects/screens/Portfolio/FullStackDeveloper.dart';
import 'package:tasktroveprojects/screens/Portfolio/GameDeveloper.dart';
import 'package:tasktroveprojects/screens/Portfolio/UiUxDesigner.dart';
import 'package:tasktroveprojects/screens/Portfolio/WebDev.dart';
import 'package:tasktroveprojects/screens/Theme/ThemeProvider.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  bool isAnimationDone = false;

  @override
  void initState() {
    super.initState();
    startLoadingAnimation();
  }

  void startLoadingAnimation() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        isAnimationDone = true;
      });
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: fetchUserDataStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || !isAnimationDone) {
          return Scaffold(
            backgroundColor: Colors.grey.shade400,
          body: Center(
            child: Lottie.asset(
              'assets/animations/Loading.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          )
          );
          
        
        
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Text(
              'Error: Unable to fetch user data'); // Show error message if data fetching failed
        } else {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
              centerTitle: true,
              flexibleSpace: Container(
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
              ),
            ),
            drawer: ClientDrawerNavigationDrawer(
              firstName: userData['firstName'],
              lastName: userData['lastName'],
            ),
            body: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Services',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => WebDeveloper()));
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage('assets/categories/WebDev.jpg'),
                                fit: BoxFit.cover,
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Web Developers',
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UiUxDesigner()));
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage('assets/categories/UiUx.jpg'),
                                fit: BoxFit.cover,
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Ui/Ux Designers',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FrontEndDeveloper()));
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage('assets/categories/frontEnd.jpg'),
                                fit: BoxFit.cover,
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Front-End Developers',
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BackEndDeveloper()));
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage('assets/categories/backEnd.jpg'),
                                fit: BoxFit.cover,
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Back-End Developers',
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          FullStackDeveloper()));
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage('assets/categories/fullStack.jpg'),
                                fit: BoxFit.cover,
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Full Stack Developers',
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GameDeveloper()));
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: AssetImage('assets/categories/GameDev.jpg'),
                                fit: BoxFit.cover,
                              )),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Game Developers',
                            style: TextStyle(fontSize: 15),
                          )
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Stream<DocumentSnapshot> fetchUserDataStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .snapshots();
    }
    // Return an empty stream if user is not logged in
    return Stream.empty();
  }
}

class ClientDrawerNavigationDrawer extends StatefulWidget {
  final String firstName;
  final String lastName;

  const ClientDrawerNavigationDrawer(
      {required this.firstName, required this.lastName, super.key});

  @override
  State<ClientDrawerNavigationDrawer> createState() =>
      _ClientDrawerNavigationDrawerState();
}

class _ClientDrawerNavigationDrawerState
    extends State<ClientDrawerNavigationDrawer> {
  late String ImageUrl;
   bool isAnimationDone = false;

  @override
  void initState() {
    super.initState();
    // Fetch the initial user data and image URL
    fetchUserImage();
    _startLoadingAnimation();
  }

  void _startLoadingAnimation() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        isAnimationDone = true;
      });
    });
  }
  

  void fetchUserImage() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final userData = snapshot.data() as Map<String, dynamic>;
      setState(() {
        ImageUrl = userData['ImageLink'] as String? ??
            ''; // Ensure imageUrl is not null
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            buildHeader(context),
            buildMenuItems(context),
          ],
        ),
      ),
    );
  }

  buildHeader(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    final currentUser = FirebaseAuth.instance.currentUser;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || !isAnimationDone) {
          return Center(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF8C52FF), // First gradient color
                  Color(0xFFFF914D), // Second gradient color
                ],
              ),
            ),
            child: Center(
              child: Lottie.asset(
                'assets/animations/Loading.json',
                width: 200,
                height: 200,
                fit: BoxFit.contain, // Adjust the fit as needed
              ),
            ),
            )
            ); // Show loading indicator while fetching data
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Text(
              'Error: Unable to fetch user data'); // Show error message if data fetching failed
        } else {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final ImageUrl = userData['ImageLink'] as String?;

          return Container(
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
            padding: EdgeInsets.only(
              top: 30,
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: ImageUrl != null
                      ? NetworkImage(ImageUrl)
                      : NetworkImage(
                          'https://cdn4.iconfinder.com/data/icons/linecon/512/photo-512.png'),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.firstName),
                    SizedBox(
                      width: 5,
                    ),
                    Text(widget.lastName),
                  ],
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ClientProfileScreen()));
                    },
                    child: Text(
                      'View Profile',
                      style: TextStyle(
                         color: isDarkMode
                            ? Colors.white
                            : Colors.black),
                    ))
              ],
            ),
          );
        }
      },
    );
  }

  buildMenuItems(BuildContext context) => Container(
        padding: EdgeInsets.all(15),
        child: Wrap(
          runSpacing: 10,
          children: [
            ListTile(
              leading: Icon(Icons.home_outlined),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClientHomeScreen()));
              },
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
            ListTile(
              leading: Icon(Icons.message_outlined),
              title: Text('Message'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClientMessageScreen(
                              firstName: widget.firstName,
                              lastName: widget.lastName,
                            )));
              },
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
            ListTile(
              leading: Icon(Icons.library_books_outlined),
              title: Text('Library'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LibraryManagementSystem(
                              firstName: widget.firstName,
                              lastName: widget.lastName,
                            )));
              },
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
            ListTile(
              leading: Icon(Icons.settings_applications_outlined),
              title: Text('Setting'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ClientSettings(
                              firstName: widget.firstName,
                              lastName: widget.lastName,
                            )));
              },
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
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: Text('Sign Out'),
              onTap: () {
                _showSignOutConfirmationDialog(context);
              },
            ),
          ],
        ),
      );

  void _showSignOutConfirmationDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  "Sign Out",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              content: Text(
                "Are you sure you want to sign out?",
                style: TextStyle(fontSize: 18),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    SignUserOut(context);
                  },
                  child: Text(
                    "Yes",
                    style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                  ),
                ),
              ]);
        });
  }

  void SignUserOut(BuildContext context) {
    FirebaseAuth.instance.signOut().then((_) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SignInScreen())); // Navigate to login screen
    }).catchError((error) {
      print("Sign out error: $error"); // Handle sign out error, if any
    });
  }
}
