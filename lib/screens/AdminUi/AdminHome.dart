// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:tasktroveprojects/screens/AdminUi/AdminApprovedVerifiedAccount.dart';
import 'package:tasktroveprojects/screens/AdminUi/AdminClientFreelance.dart';
import 'package:tasktroveprojects/screens/AdminUi/AdminMessage.dart';
import 'package:tasktroveprojects/screens/AdminUi/AdminSettings.dart';
import 'package:tasktroveprojects/screens/AdminUi/AdminSubscription.dart';
import 'package:tasktroveprojects/screens/Auth/SignInScreen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  bool isAnimationDone = false;

  @override
  void initState() {
    super.initState();
    _startLoadingAnimation();
  }

  void _startLoadingAnimation() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        isAnimationDone = true;
      });
    });
  }

  String formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return 'N/A';
    }
    DateTime dateTime = timestamp.toDate();
    return DateFormat('MMMM d, yyyy')
        .format(dateTime); // Format: "Month Day, Year"
  }

  Future<Map<String, dynamic>> fetchAllData() async {
  // Fetch income and subscription counts
  QuerySnapshot userSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .where('accountType', isEqualTo: 'Freelance')
      .get();

  int totalIncome = 0;
  int subscribedCount = 0;
  int unsubscribedCount = 0;

  for (var doc in userSnapshot.docs) {
    var data = doc.data() as Map<String, dynamic>?; // Explicitly cast to avoid warnings

    if (data == null) {
      // If data is null, skip this document
      continue;
    }

    // Use safe null-aware operators to avoid errors
    String status = data.containsKey('subscriptionStatus') 
      ? data['subscriptionStatus']
      : 'Not Subscribed';

    if (status == 'Active') {
      subscribedCount++;
      int fee = data['subscriptionFee'] ?? 350; // Default fee is 350
      totalIncome += fee;
    } else {
      unsubscribedCount++;
    }
  }

  // Collect all active freelancers with safe null checks
  var activeFreelancers = userSnapshot.docs
      .where((doc) => doc.data() != null && (doc.data() as Map<String, dynamic>)['subscriptionStatus'] == 'Active')
      .toList();

  return {
    'totalIncome': totalIncome,
    'subscribedCount': subscribedCount,
    'unsubscribedCount': unsubscribedCount,
    'activeFreelancers': activeFreelancers,
  };
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
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
      drawer: AdminDrawerNavigationDrawer(),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchAllData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !isAnimationDone) {
            return Center(
              child: Lottie.asset(
                'assets/animations/Loading.json',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching data: ${snapshot.error}'));
          }

          var data = snapshot.data!;
          int totalIncome = data['totalIncome'];
          int subscribedCount = data['subscribedCount'];
          int unsubscribedCount = data['unsubscribedCount'];
          var activeFreelancers = data['activeFreelancers'];


              return ListView(
            children: [
              Container(
                  width: 480,
                  child: Card(
                    margin: EdgeInsets.all(20),
                    child: Container(
                      width: 500,
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                      children: [
                        Text(
                          'Freelancer Subscription Overview',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ), SizedBox(height: 20),
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
                          SizedBox(height: 10),
                        Text(
                          '---Total Income in Subscribers---',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '₱$totalIncome.00',
                          style: TextStyle(fontSize: 22),
                        ),
                         SizedBox(height: 10),
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
                          SizedBox(height: 10),
                        Text(
                          '---Subscribed Freelancers---',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text('$subscribedCount', style: TextStyle(fontSize: 22)),
                         SizedBox(height: 10),
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
                          SizedBox(height: 10),
                        Text(
                          '---Not Subscribed Freelancers---',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text('$unsubscribedCount', style: TextStyle(fontSize: 22)),
                         SizedBox(height: 10),
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
                          SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
              // Active freelancers list
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: activeFreelancers.length,
                itemBuilder: (context, index) {
                  var doc = activeFreelancers[index];
                  String firstName = doc['firstName'] ?? '';
                  String lastName = doc['lastName'] ?? '';
                  String email = doc['email'] ?? '';
                  String imageLink = doc['imageLink'] ?? '';
                  String subscriptionStatus = doc['subscriptionStatus'] ?? '';

                  Timestamp? startTimestamp = doc['subscriptionStartDate'] as Timestamp?;
                  Timestamp? endTimestamp = doc['subscriptionEndDate'] as Timestamp?;

                  // Format date to "Month Day, Year"
                  String formattedStartDate = formatTimestamp(startTimestamp);
                  String formattedEndDate = formatTimestamp(endTimestamp);

                  return Container(
                  width: 480,
                  child: Card(
                    margin: EdgeInsets.all(20),
                    child: Container(
                      width: 500,
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(imageLink),
                            radius: 100,
                          ),
                          SizedBox(height: 20),
                          Text(
                            '$firstName $lastName',
                            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 20),
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
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text('Email:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20),
                            child: Text(email, style: TextStyle(fontSize: 18)),
                          ),
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text('Subscription Status:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20),
                            child: Text(subscriptionStatus, style: TextStyle(fontSize: 18)),
                          ),
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text('Subscription Date:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20),
                            child: Text(formattedStartDate, style: TextStyle(fontSize: 18)),
                          ),
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text('Subscription Expiry:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20),
                            child: Text(formattedEndDate, style: TextStyle(fontSize: 18)),
                          ),
                          SizedBox(height: 10),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text('Subscription Fee:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20),
                            child: Text('₱350.00', style: TextStyle(fontSize: 18)),
                          ),
                          SizedBox(height: 20),
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
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  )
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class AdminDrawerNavigationDrawer extends StatefulWidget {
  const AdminDrawerNavigationDrawer({super.key});

  @override
  State<AdminDrawerNavigationDrawer> createState() =>
      _AdminDrawerNavigationDrawerState();
}

class _AdminDrawerNavigationDrawerState
    extends State<AdminDrawerNavigationDrawer> {
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
      child: CircleAvatar(
        backgroundImage: AssetImage('assets/tasktrovelogo.png'),
        radius: 150,
      ),
    );
  }
}

buildMenuItems(BuildContext context) => Container(
      padding: EdgeInsets.all(15),
      child: Wrap(
        runSpacing: 10,
        children: [
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text('Admin Home'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminHomeScreen()));
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminMessage()));
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
            leading: Icon(Icons.subscriptions_outlined),
            title: Text('Subscriptions'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminSubscription()));
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
            leading: Icon(Icons.person_outline_sharp),
            title: Text('User Accounts'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AdminClientFreelance()));
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
            leading: Icon(Icons.verified_user_outlined),
            title: Text('Freelance Verification'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ApprovedAccounts()));
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AdminSetting()));
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
            builder: (context) => SignInScreen())); // Navigate to login screen
  }).catchError((error) {
    print("Sign out error: $error"); // Handle sign out error, if any
  });
}
