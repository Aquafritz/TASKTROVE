// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tasktroveprojects/screens/MessageServices/ChatPage.dart';
import 'package:tasktroveprojects/screens/ClientUi/Client.dart';
import 'package:tasktroveprojects/screens/Theme/ThemeProvider.dart';

class ClientMessageScreen extends StatefulWidget {
  final String firstName;
  final String lastName;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  ClientMessageScreen(
      {required this.firstName, required this.lastName, super.key});

  @override
  State<ClientMessageScreen> createState() => _ClientMessageState();
}

class _ClientMessageState extends State<ClientMessageScreen> {
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
      drawer: ClientDrawerNavigationDrawer(
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
          return Center(
            child: Text('Error loading data'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No users found'),
          );
        }


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
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

     if (data != null) {
      String? accountType = data['accountType'];
      if (accountType == 'Freelance' && widget._auth.currentUser!.email != data['email']) {
        String fullName = '${data['firstName'] ?? ''} ${data['lastName'] ?? ''}';
        String imageLink = data['imageLink'] ?? '';

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
                
                backgroundImage: imageLink.isNotEmpty ? NetworkImage(imageLink) : null,
                child: imageLink.isEmpty ? Icon(Icons.person) : null,
              ),
            ),
          ),
          title: Text(fullName, style: TextStyle(fontSize: 20),), // Add a null check here
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(
                  receiverUserEmail:
                      fullName, // Add a null check here
                  receiverUserID: data['uid'] ?? '', // Add a null check here
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
    } else {
      return Container(); // Return an empty container if data is null
    }
  }
}
