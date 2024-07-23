// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tasktroveprojects/screens/FreelanceUi/Freelancer.dart';
import 'package:tasktroveprojects/screens/FreelanceUi/SubscriptionPayment.dart';

class Subscription extends StatefulWidget {
  final String firstName;
  final String lastName;
  const Subscription(
      {required this.firstName, required this.lastName, super.key});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  DateTime? subscriptionEndDate;
  late Timer _timer;
  Duration remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _fetchSubscriptionEndDate();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _fetchSubscriptionEndDate() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        Timestamp? endDate = snapshot.get('subscriptionEndDate');
        if (endDate != null) {
          setState(() {
            subscriptionEndDate = endDate.toDate();
          });
          _startCountdown();
        }
      }
    }
  }

  void _startCountdown() {
    if (subscriptionEndDate == null) {
      return;
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        remainingTime = subscriptionEndDate!.difference(DateTime.now());
      });
    });
  }

  String _formatRemainingTime() {
    if (remainingTime.isNegative) {
      return "Subscription expired";
    }
    int days = remainingTime.inDays;
    int hours = remainingTime.inHours.remainder(24);
    int minutes = remainingTime.inMinutes.remainder(60);
    int seconds = remainingTime.inSeconds.remainder(60);

    return "${days}d ${hours}h ${minutes}m ${seconds}s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: FreelanceDrawerNavigationDrawer(
          firstName: widget.firstName,
          lastName: widget.lastName,
        ),
        appBar: AppBar(
          title: const Text('Subscription'),
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
        body: Column(
          children: [
            Container(
                width: 480,
                child: Card(
                    margin: EdgeInsets.all(20),
                    child: Container(
                        width: 500,
                        padding: EdgeInsets.all(16.0),
                        child: Column(children: [
                          Text(
                            'Subscription',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              'Unlimited project management.',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              'Premium portfolio access',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              'Unlimited Messaging',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '₱350.00',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                                    elevation:
                                        MaterialStateProperty.all<double>(5),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SubscriptionsPayment()));
                                  },
                                  child: Text(
                                    'Subscribe Now',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ))),
                          if (subscriptionEndDate !=
                              null) // Only show if there's a valid subscription end date
                            Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '---Subscription Ends---',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 20),
                                  Text(
                                    _formatRemainingTime(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                        ])))),
          ],
        ));
  }
}
