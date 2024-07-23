// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';

class ApprovedAccounts extends StatefulWidget {
  const ApprovedAccounts({super.key});

  @override
  State<ApprovedAccounts> createState() => _ApprovedAccountsState();
}

class _ApprovedAccountsState extends State<ApprovedAccounts> {
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
  
   void approveVerification(String userId) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("get_verified")
        .doc("verification")
        .update({'requestingVerification': false});
  }

  void cancelVerification(String userId) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(userId)  // Locate the user document by ID
        .collection("get_verified")  // Access the subcollection
        .doc("verification")  // Reference the specific document
        .delete()  // Delete the document
        .then((_) => print("Verification document canceled"))
        .catchError((error) => print("Error deleting document: $error"));  // Handle any errors
        setState(() {});
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
          title: const Text('Approve Accounts'),
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
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
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

          final users = snapshot.data!.docs;

          List<Widget> approvedAccountTiles = [];

          for (var user in users) {
            final userId = user.id;
            final userData = user.data() as Map<String, dynamic>;

            final firstName = userData['firstName'] ?? "First Name";
            final lastName = userData['lastName'] ?? "Last Name";
            final email = userData['email'] ?? "Email not provided";
            final birthday = userData['birthday'] ?? "Birthday not provided";
            final location = userData['location'] ?? "Location not provided";

            approvedAccountTiles.add(
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("users")
                    .doc(userId)
                    .collection("get_verified")
                    .doc("verification")
                    .get(),
                builder: (context, verifiedSnapshot) {
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

                  if (verifiedSnapshot.hasError || !verifiedSnapshot.hasData || !verifiedSnapshot.data!.exists) {
                    return Container(); // Return an empty container to exclude the tile
                  }

                  final verifiedData = verifiedSnapshot.data!;
                  final requestingVerification = verifiedData['requestingVerification'] ?? false;

                  if (requestingVerification) {
                    final idType = verifiedData['idType'] ?? "ID Type not provided";
                     final frontImageUrl = verifiedData['frontImageUrl'];
                    final backImageUrl = verifiedData['backImageUrl'];
                    final professionalWebsiteLinks = verifiedData['professionalWebsite'];
                    final socialMediaLinks = verifiedData['socialMedia'];

                    return Container(
                width: 480,
                child: Card(
                  margin: EdgeInsets.all(20),
                  child: Container(
                    width: 500,
                    padding: EdgeInsets.all(16.0),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text('$firstName $lastName', style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: $email', style: TextStyle(
                            fontSize: 18
                          ),),
                          SizedBox(height: 10,),
                          Text('Birthday: $birthday', style: TextStyle(
                            fontSize: 18
                          ),),
                          SizedBox(height: 10,),
                          Text('Location: $location', style: TextStyle(
                            fontSize: 18
                          ),),
                           SizedBox(height: 10,),
                          Text('ID Type: $idType', style: TextStyle(
                            fontSize: 18
                          ),),
                          SizedBox(height: 10,),
                          if (frontImageUrl != null)
                                Center(
                                  child: Image.network(
                                    frontImageUrl,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              SizedBox(height: 10,),
                              if (backImageUrl != null)
                                Center(
                                  child: Image.network(
                                    backImageUrl,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          SizedBox(height: 10,),
                            Text('Professional Website', style: TextStyle(
                              fontSize: 20,
                            fontWeight: FontWeight.bold
                                                       ),),
                           SizedBox(height: 10,),

                           Padding(
                             padding: const EdgeInsets.only(left: 20.0),
                             child: Text('${professionalWebsiteLinks.join("\n")}', style: TextStyle(
                              fontSize: 18
                                                       ),),
                           ),SizedBox(height: 10,),

                          
                              Text('Social Media Link', style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                          ),
                          ),
                      
                          SizedBox(height: 10,),

                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text('${socialMediaLinks.join("\n")}', style: TextStyle(
                              fontSize: 18
                            ),),
                          ),
                          SizedBox(height: 10,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.blueAccent),
                              elevation: MaterialStateProperty.all<double>(5),
                            ),
                                    onPressed: ()=> approveVerification(userId), 
                                    child: Text('Approve', style: TextStyle(color: Colors.white),)),
                                  ElevatedButton(
                                    style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.red),
                              elevation: MaterialStateProperty.all<double>(5),
                            ),
                                    onPressed: ()=> cancelVerification(userId), 
                                    child: Text('Cancel', style: TextStyle(color: Colors.white),)),
                                ],
                              ),
                        ],
                      ),
                    )
                  )
                )
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            );
          }

          return ListView(
            children: approvedAccountTiles, 
          );
        },
      ),
    );
  }
}
