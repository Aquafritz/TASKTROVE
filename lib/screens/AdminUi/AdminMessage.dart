// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tasktroveprojects/screens/AdminUi/AdminHome.dart';
import 'package:tasktroveprojects/screens/MessageServices/ChatPage.dart';
import 'package:tasktroveprojects/screens/Theme/ThemeProvider.dart';

class AdminMessage extends StatefulWidget {
    final FirebaseAuth _auth = FirebaseAuth.instance;
  
  AdminMessage({super.key});

  @override
  State<AdminMessage> createState() => _AdminMessageState();
}

class _AdminMessageState extends State<AdminMessage> {
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AdminDrawerNavigationDrawer(
      ),
      appBar: AppBar(
        title: const Text('Message'),
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
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error');
        }

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
        // Filter users based on account type (assuming 'accountType' is a field in Firestore)
       var users = snapshot.data!.docs;

      // Filter users based on the condition that they are not the current user
       return ListView(
        children: users
            .where((doc) => doc['uid'] != widget._auth.currentUser!.uid)
            .map<Widget>((doc) => _buildUserListItem(doc))
            .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(DocumentSnapshot document) {
     ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
        bool isDarkMode = themeProvider.isDarkMode;
       final data = document.data() as Map<String, dynamic>;

    if (data != null) {
      String fullName = '${data['firstName']} ${data['lastName']}';
      String accountType = data['accountType'] ?? 'Unknown';
      String imageLink = data['imageLink'] ?? ''; // For Freelance
      String ImageLink = data['ImageLink'] ?? ''; // For Client

      String displayImageLink = accountType == "Client" ? ImageLink : imageLink;

      return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Material(
            color: isDarkMode
                        ? Colors.grey.shade800
                        : Colors.grey.shade200,
            elevation: 4, // Elevation to create shadow
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Circular shape
            ),
            child: ListTile(
          leading: ClipOval(
            child: Container(
              width: 60, // Adjust to your preferred size
        height: 60,
              child: displayImageLink.isNotEmpty
              ? CircleAvatar(
                  backgroundImage: NetworkImage(displayImageLink),
                )
              : CircleAvatar(child: Icon(Icons.person)
              )
              ),
          ), // Default avatar if no image
        title: Text(fullName, style: TextStyle(fontSize: 20),),
        subtitle: Text(accountType), // Display accountType here
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: fullName,
                receiverUserID: data['uid'], 
              ),
            ),
          );
        },
            )
          )
      );
    } else {
      return Container();
    }
  }
}