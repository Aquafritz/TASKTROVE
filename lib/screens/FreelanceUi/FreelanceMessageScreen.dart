// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tasktroveprojects/screens/FreelanceUi/Freelancer.dart';
import 'package:tasktroveprojects/screens/MessageServices/ChatPage.dart';
import 'package:tasktroveprojects/screens/Theme/ThemeProvider.dart';

class FreelanceMessageScreen extends StatefulWidget {
  final String firstName;
  final String lastName;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FreelanceMessageScreen(
      {required this.firstName, required this.lastName, super.key});

  @override
  State<FreelanceMessageScreen> createState() => _FreelanceMessageScreenState();
}

class _FreelanceMessageScreenState extends State<FreelanceMessageScreen> {
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
      drawer: FreelanceDrawerNavigationDrawer(
        firstName: widget.firstName,
        lastName: widget.lastName,
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
          return Text('Error');
        }

        // Filter users based on account type (assuming 'accountType' is a field in Firestore)
          var users = snapshot.data!.docs;

        // Filter users based on account type and exclude the current user
        var filteredUsers = users.where((doc) {
          var data = doc.data() as Map<String, dynamic>?;
          if (data == null) return false;

          bool isNotCurrentUser = data['uid'] != widget._auth.currentUser!.uid;
          bool isValidAccountType = data['accountType'] == 'Client' ||
                                    data['accountType'] == 'Admin';

          return isNotCurrentUser && isValidAccountType;
        }).toList();

        return ListView(
          children: filteredUsers.map((doc) => _buildUserListItem(doc)).toList(),
        );
      },
    );
  }


  Widget _buildUserListItem(DocumentSnapshot document) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
        bool isDarkMode = themeProvider.isDarkMode;
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (data == null) {
      return Container(); // Return an empty container if data is null
    }

    String fullName = '${data['firstName']} ${data['lastName']}';
    String imageUrl = data['ImageLink'] ?? ''; 

    
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
              contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          leading: ClipOval(
            child: Container(
              width: 60, // Adjust to your preferred size
        height: 60,
              child: CircleAvatar(
                     backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                child: imageUrl.isEmpty ? Icon(Icons.person) : null,
                  ),
            ),
          ),
      title: Text(fullName, style: TextStyle(fontSize: 20),),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverUserEmail: data['email'] ?? 'Unknown',
              receiverUserID: data['uid'] ?? '', // Add a null check here
            ),
          ),
        );
      },
            )
          )
    );
  }
}