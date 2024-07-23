// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_final_fields

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tasktroveprojects/screens/AdminUi/AdminHome.dart';
import 'package:tasktroveprojects/screens/Theme/ThemeProvider.dart';

class AdminClientFreelance extends StatefulWidget {
  const AdminClientFreelance({super.key});

  @override
  State<AdminClientFreelance> createState() => _AdminClientFreelanceState();
}

class _AdminClientFreelanceState extends State<AdminClientFreelance> {
  bool isAnimationDone = false;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _accountTypeFilter = 'All';

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

  Future<Map<String, List<QueryDocumentSnapshot>>> _fetchUsers() async {
    final freelancerQuery = FirebaseFirestore.instance
        .collection('users')
        .where('accountType', isEqualTo: 'Freelance')
        .get();

    final clientQuery = FirebaseFirestore.instance
        .collection('users')
        .where('accountType', isEqualTo: 'Client')
        .get();

    final results = await Future.wait([freelancerQuery, clientQuery]);
    return {
      'freelancers': results[0].docs,
      'clients': results[1].docs,
    };
  }

  @override
  Widget build(BuildContext context) {
     ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Accounts'),
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
      body: FutureBuilder<Map<String, List<QueryDocumentSnapshot>>>(
        future: _fetchUsers(),
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
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final freelancers = snapshot.data?['freelancers'] ?? [];
          final clients = snapshot.data?['clients'] ?? [];

          List<QueryDocumentSnapshot> filteredFreelancers = _filterUsers(freelancers);
          List<QueryDocumentSnapshot> filteredClients = _filterUsers(clients);

          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 250,
                      child: CupertinoTextField(
                         decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(8.0),
                                color: isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade200),
                            cursorColor: isDarkMode ? Colors.white : Colors.black,
                        controller: _searchController,
                        placeholder: 'Search Accounts', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black,),
                        suffix: IconButton(
                          icon: Icon(Icons.search_outlined),
                          onPressed: () {
                            setState(() {
                              _searchQuery = _searchController.text.toLowerCase();
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    DropdownButton<String>(
                      value: _accountTypeFilter,
                      items: [
                        DropdownMenuItem(
                          value: 'All',
                          child: Text('All'),
                        ),
                        DropdownMenuItem(
                          value: 'Freelance',
                          child: Text('Freelance'),
                        ),
                        DropdownMenuItem(
                          value: 'Client',
                          child: Text('Client'),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _accountTypeFilter = newValue!;
                        });
                      },
                    ),
                  ],
                ),
                if (filteredFreelancers.isEmpty && filteredClients.isEmpty)
                  Center(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'No match found',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                else ...[
                  if (_accountTypeFilter == 'All' || _accountTypeFilter == 'Freelance')
                    if (filteredFreelancers.isNotEmpty) ...[
                      Center(
                        child: Text(
                          'Freelancers',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildUserList(filteredFreelancers, 'Freelance'),
                      SizedBox(height: 32),
                    ],
                  if (_accountTypeFilter == 'All' || _accountTypeFilter == 'Client')
                    if (filteredClients.isNotEmpty) ...[
                      Center(
                        child: Text(
                          'Clients',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      _buildUserList(filteredClients, 'Client'),
                    ],
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  List<QueryDocumentSnapshot> _filterUsers(List<QueryDocumentSnapshot> users) {
    return users.where((user) {
      final data = user.data() as Map<String, dynamic>;
      final firstName = data['firstName']?.toLowerCase() ?? '';
      final lastName = data['lastName']?.toLowerCase() ?? '';
      final email = data['email']?.toLowerCase() ?? '';

      return firstName.contains(_searchQuery) ||
          lastName.contains(_searchQuery) ||
          email.contains(_searchQuery);
    }).toList();
  }

  Widget _buildUserList(List<QueryDocumentSnapshot> users, String accountType) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final data = users[index].data() as Map<String, dynamic>;
        final firstName = data['firstName'] ?? 'First Name';
        final lastName = data['lastName'] ?? 'Last Name';
        final email = data['email'] ?? '';
        final birthday = data['birthday'] ?? '';
        final educationtraining = data['educationtraining'] ?? '';
        final imageLink = data['imageLink'] ?? ''; // For Freelance
        final ImageLink = data['ImageLink'] ?? ''; // For Client

        final displayImageLink = accountType == "Client" ? ImageLink : imageLink;

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8),
          color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          elevation: 4,
          child: ListTile(
            leading: ClipOval(
              child: Container(
                width: 60, // Adjust to your preferred size
                height: 60, // Adjust to your preferred size
                child: displayImageLink.isNotEmpty
                    ? Image.network(
                        displayImageLink,
                        fit: BoxFit.cover, // Ensures the image doesn't stretch or zoom excessively
                      )
                    : Center(
                        child: Icon(Icons.person, size: 50),
                      ),
              ),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: $firstName $lastName'),
                Text('Email: $email'),
                Text('Birthday: $birthday'),
                Text('Education: $educationtraining'),
              ],
            ),
          ),
        );
      },
    );
  }
}
