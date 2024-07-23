// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tasktroveprojects/screens/MessageServices/ChatPage.dart';
import 'package:uuid/uuid.dart';

class AdminSubscription extends StatefulWidget {
  const AdminSubscription({super.key});

  @override
  State<AdminSubscription> createState() => _AdminSubscriptionState();
}

class _AdminSubscriptionState extends State<AdminSubscription> {

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
  
  Future<List<Map<String, dynamic>>> fetchFreelanceUsers() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('accountType', isEqualTo: 'Freelance')
        .where('subscriptionStatus', isEqualTo: 'Not Subscribed')
        .get();

    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  Future<void> approveSubscription(String userId) async {
    final subscriptionID = Uuid().v4(); // Generate a unique subscription ID
    final subscriptionStartDate = DateTime.now(); // Start date of subscription
    final subscriptionEndDate =
        subscriptionStartDate.add(Duration(days: 30)); // 30 days from now
    final subscriptionStatus = 'Active'; // Subscription is active upon approval
     final subscriptionFee = 350; 

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'subscriptionID': subscriptionID,
      'subscriptionStartDate': subscriptionStartDate,
      'subscriptionEndDate': subscriptionEndDate,
      'subscriptionStatus': subscriptionStatus,
      'subscriptionFee': subscriptionFee,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscriptions'),
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchFreelanceUsers(),
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
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No freelance users found.'));
          }

          final freelanceUsers = snapshot.data!;

          return ListView.builder(
            itemCount: freelanceUsers.length,
            itemBuilder: (context, index) {
              final user = freelanceUsers[index];
              final subscriptionStatus = user['subscriptionStatus'] ?? 'Not Subscribe';
             
              return Container(
                  width: 480,
                  child: Card(
                    margin: EdgeInsets.all(20),
                    child: Container(
                      width: 500,
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Container(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(user['imageLink'] ?? ''),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        '${user['firstName']} ${user['lastName']}',
                        style: TextStyle(fontSize: 30),
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
                          height: 10,
                        ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Subscription Status: $subscriptionStatus',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18
                        ),
                      ),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 140,
                            height: 45,
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
                              onPressed: () async {
                                await approveSubscription(user['uid']);
                                 setState(() {
                                // Refresh the list by re-fetching data
                              });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Subscription approved for 30 days!'),
                                  ),
                                );
                              },
                              child: Text(
                                'Approve Subscription',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            width: 140,
                            height: 45,
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
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                            receiverUserEmail: user['email'],
                                            receiverUserID: user['uid'])));
                              },
                              child: Text(
                                'Message',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                     
                  ],
                ),
                    )
                  )
              );
            },
          );
        },
      ),
    );
  }
}
