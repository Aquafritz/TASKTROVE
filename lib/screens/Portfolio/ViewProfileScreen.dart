// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, prefer_final_fields, use_build_context_synchronously, avoid_print

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tasktroveprojects/screens/Theme/ThemeProvider.dart';

class ViewProfile extends StatefulWidget {
  final String uid;

  const ViewProfile({required this.uid, super.key});

  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  double _currentRating = 0;
  TextEditingController _commentController = TextEditingController();
  bool _isRequestingVerification = false; 
  bool isAnimationDone = false;

  void startLoadingAnimation() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        isAnimationDone = true;
      });
    });
  }
  
 @override
void initState() {
  super.initState();
   startLoadingAnimation();

  // Fetch verification status asynchronously
  FirebaseFirestore.instance
    .collection('users')
    .doc(widget.uid) // Double-check UID
    .collection("get_verified")
    .doc("verification")
    .get()
    .then((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        setState(() {
          // Ensure correct field and value
          _isRequestingVerification = data['requestingVerification'] ?? true;
        });
      } else {
        setState(() {
          _isRequestingVerification = true; // Default to true if doc does not exist
        });
      }
    }).catchError((error) {
      // Handle errors and ensure UI updates
      setState(() {
        _isRequestingVerification = true;
      });
      print('Error fetching verification data: $error');
    });
}



  final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

  Future<void> submitRating() async {
    try {
      final ratingData = {
        'freelancerUid': widget.uid,
        'rating': _currentRating,
        'comment': _commentController.text,
        'timestamp': Timestamp.now(),
        'clientUid': currentUserUid,
      };

      await FirebaseFirestore.instance.collection('ratings').add(ratingData);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rating submitted successfully!')),
      );

      _commentController.clear();
      setState(() {
        _currentRating = 0;
      });
    } catch (e) {
      print('Error adding rating to Firestore: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit rating. Please try again.')),
      );
    }
  }

  Stream<QuerySnapshot> fetchRatingsStream() {
    return FirebaseFirestore.instance
        .collection('ratings')
        .where('freelancerUid', isEqualTo: widget.uid)
        .snapshots();
  }

  Future<Map<String, dynamic>> fetchUserProfile() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();

    return snapshot.data() as Map<String, dynamic>;
  }
  

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;
    return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
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
        body: FutureBuilder<Map<String, dynamic>>(
            future: fetchUserProfile(),
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
              if (!snapshot.hasData) {
                return Center(child: Text('No profile data found.'));
              }

              final userProfile = snapshot.data!;

              String imageUrl = '';
              if (userProfile.containsKey('imageLink')) {
                final rawImageLink = userProfile['imageLink'];
                if (rawImageLink is String) {
                  imageUrl = rawImageLink;
                } else if (rawImageLink is List && rawImageLink.isNotEmpty) {
                  imageUrl = rawImageLink[0];
                }
              }

              // Extract all portfolio images
              List<String> portfolioUrls = [];
              if (userProfile.containsKey('portfolio')) {
                final rawPortfolio = userProfile['portfolio'];
                if (rawPortfolio is List) {
                  portfolioUrls = List<String>.from(
                      rawPortfolio); // Extract all portfolio images
                }
              }

              List<String> codes = [];
              if (userProfile.containsKey('codes')) {
                final rawCodes = userProfile['codes'];
                if (rawCodes is List) {
                  codes = List<String>.from(rawCodes);
                }
              }
              return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Container(
                      alignment: Alignment.center,
                      child: Column(children: [
                        SizedBox(
                          height: 20,
                        ),
                        CircleAvatar(
                          radius: 100,
                          backgroundImage: NetworkImage(imageUrl),
                        ),
                        SizedBox(height: 10),
                        Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${userProfile['firstName']} ${userProfile['lastName']}',
                              style: TextStyle(fontSize: 30),
                            ),
                             if (!_isRequestingVerification) ...[
                      SizedBox(width: 5),
                      Icon(Icons.verified, color: Colors.blue),
                    ],
                          ],
                        ),
                         if (!_isRequestingVerification) ...[
                  SizedBox(height: 10),
                  Text("This account is verified", style: TextStyle(color: Colors.green)),
                ],
                        Container(
                          width: 480,
                          child: Card(
                              margin: EdgeInsets.all(20),
                              child: Container(
                                width: 500,
                                padding: EdgeInsets.all(16.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Details',
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
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
                                        padding: EdgeInsets.only(left: 10.0),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Bio:',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 30.0),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${userProfile['bio']}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10.0),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Birthday:',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                          padding: EdgeInsets.only(left: 30.0),
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${userProfile['birthday']}',
                                            style: TextStyle(fontSize: 18),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10.0),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Education & Training:',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 30.0),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${userProfile['educationtraining']}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10.0),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Location:',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 30.0),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${userProfile['location']}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10.0),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Skill:',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 30.0),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          '${userProfile['skill']}',
                                          style: TextStyle(fontSize: 18),
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
                                        height: 30,
                                      ),
                                    ]),
                              )),
                        ),
                        Container(
                          width: 480,
                          child: Card(
                            margin: EdgeInsets.all(20),
                            child: Container(
                                width: 500,
                                padding: EdgeInsets.all(16.0),
                                child: Column(children: [
                                  Text(
                                    'Portfolio',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),

                                    // Display the portfolio image
                                  ),
                                  SizedBox(
                                    height: 10,
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
                                  for (var portfolioUrl in portfolioUrls)
                                    Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          child: Image.network(
                                            portfolioUrl,
                                            height: 300,
                                            width: 300,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    ),
                                  SizedBox(
                                    height: 10,
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
                                ])),
                          ),
                        ),
                        Container(
                          width: 480,
                          child: Card(
                            margin: EdgeInsets.all(20),
                            child: Container(
                                width: 500,
                                padding: EdgeInsets.all(16.0),
                                child: Column(children: [
                                  if (codes.isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Portfolio Source Code',
                                          style: TextStyle(
                                              fontSize: 30,
                                              fontWeight: FontWeight.bold),
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
                                        for (var code in codes)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding:
                                                    EdgeInsets.only(left: 10.0),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Code',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    EdgeInsets.only(left: 30.0),
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  code,
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                              ),
                                            ],
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
                                        )
                                      ],
                                    ),
                                ])),
                          ),
                        ),
                        Container(
                            width: 480,
                            child: Card(
                                margin: EdgeInsets.all(20),
                                child: Container(
                                    width: 500,
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(children: [
                                      Text(
                                        'Rate This Freelancer',
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
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
                                      SizedBox(height: 20),
                                      RatingBar.builder(
                                        initialRating:
                                            _currentRating, // Set the initial rating
                                        minRating: 0,
                                        allowHalfRating: true,
                                        itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: Colors.amber, // Star color
                                        ),
                                        onRatingUpdate: (rating) {
                                          setState(() {
                                            _currentRating =
                                                rating; // Update the current rating
                                          });
                                        },
                                      ),
                                      SizedBox(height: 20),
                                      TextField(
                                        controller: _commentController,
                                        decoration: InputDecoration(
                                          labelText: 'Leave a comment',
                                          border: OutlineInputBorder(),
                                        ),
                                        maxLines: 3,
                                      ),
                                      SizedBox(height: 20),
                                      ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.blueAccent),
                                        ),
                                        onPressed: submitRating,
                                        child: Text(
                                          'Submit Rating',
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
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
                                      StreamBuilder<QuerySnapshot>(
                                        stream: fetchRatingsStream(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return CircularProgressIndicator();
                                          }

                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error fetching ratings: ${snapshot.error}');
                                          }

                                          if (!snapshot.hasData ||
                                              snapshot.data!.docs.isEmpty) {
                                            return Text('');
                                          }

                                          var ratings = snapshot.data!
                                              .docs; // Ensure data is correct

                                          return Column(
                                            children: ratings.map((doc) {
                                              var ratingData = doc.data()
                                                  as Map<String, dynamic>;

                                              String formattedTimestamp =
                                                  DateFormat(
                                                          'MMM d, yyyy h:mm a')
                                                      .format(ratingData[
                                                              'timestamp']
                                                          .toDate());

                                                           bool isUserRating = ratingData['clientUid'] == currentUserUid;

                                              return Card(
                                                color: isDarkMode
                                                    ? Colors.grey.shade800
                                                    : Colors.grey.shade200,
                                                elevation: 4,
                                                margin: EdgeInsets.all(15),
                                                child: ListTile(
                                                  leading: RatingBarIndicator(
                                                    rating: ratingData['rating']
                                                        .toDouble(), // Check 'rating' field
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: Colors.amber,
                                                    ),
                                                    itemCount: 5,
                                                    itemSize: 24,
                                                    direction: Axis.horizontal,
                                                  ),
                                                  title: Text(
                                                    ratingData['comment'] ??
                                                        'No comment',
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),
                                                  ), // Check 'comment' field
                                                  subtitle: Text(
                                                    formattedTimestamp, // Check 'timestamp' field
                                                    style:
                                                        TextStyle(fontSize: 15),
                                                  ),
                                                  trailing: isUserRating
                ? PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'Delete') {
                        deleteRating(doc.id); // Call the delete function
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                    ],
                  )
                : null,
          ),
        );
      }).toList(),
          );
        },
      ),
                                    ]
                                    )
                                )
                            )
                        )
                      ]
                      )
                  )
    );
            }
        )
        );
  }

  // Delete rating by document ID
  Future<void> deleteRating(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('ratings')
          .doc(docId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rating deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete rating. Please try again.')),
      );
    }
  }
}
       