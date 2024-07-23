// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tasktroveprojects/screens/FreelanceUi/SubscriptionPayment.dart';
import 'package:tasktroveprojects/screens/Theme/ThemeProvider.dart';

class GetVerified extends StatefulWidget {
  const GetVerified({Key? key}) : super(key: key);

  @override
  State<GetVerified> createState() => _GetVerifiedState();
}

class _GetVerifiedState extends State<GetVerified> {
  Uint8List? _frontImage;
  Uint8List? _backImage;
  final TextEditingController _selectedIdType = TextEditingController();
  final List<TextEditingController> _professionalWebsiteControllers = [];
  final List<TextEditingController> _socialMediaControllers = [];

  final List<String> _idTypes = [
    'Passport',
    'Driver\'s License',
    'SSS ID',
    'UMID',
    'PhilHealth ID',
    'Voter\'s ID',
    'TIN ID',
    'Postal ID',
    'Philippine National ID',
  ];

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

  void _addProfessionalWebsiteField() {
    setState(() {
      _professionalWebsiteControllers.add(TextEditingController());
    });
  }

  void _addSocialMediaField() {
    setState(() {
      _socialMediaControllers.add(TextEditingController());
    });
  }

  Future<void> saveVerificationData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      print('User not authenticated');
      return;
    }

    final getVerifiedDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('get_verified')
        .doc('verification')
        .get();

    if (getVerifiedDoc.exists) {
      // If the document already exists, alert the user or take other actions
      print('Verification data already submitted.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification data has already been submitted.')),
      );
      return;
    }

    // If the document does not exist, proceed with saving the new verification data
    try {
      // Upload images if they exist
      String? frontImageUrl;
      if (_frontImage != null) {
        String frontStoragePath = 'get_verified/${user.uid}/id_front.jpg';
        final ref = FirebaseStorage.instance.ref(frontStoragePath);
        await ref.putData(_frontImage!); // Upload front image
        frontImageUrl = await ref.getDownloadURL(); // Get the download URL
      }

      String? backImageUrl;
      if (_backImage != null) {
        String backStoragePath = 'get_verified/${user.uid}/id_back.jpg';
        final ref = FirebaseStorage.instance.ref(backStoragePath);
        await ref.putData(_backImage!); // Upload back image
        backImageUrl = await ref.getDownloadURL(); // Get the download URL
      }

      // Create lists of non-empty website and social media links
      List<String> professionalWebsiteLinks = _professionalWebsiteControllers
          .map((controller) => controller.text)
          .where((link) => link.isNotEmpty)
          .toList();

      List<String> socialMediaLinks = _socialMediaControllers
          .map((controller) => controller.text)
          .where((link) => link.isNotEmpty)
          .toList();

      // Save verification data to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('get_verified')
          .doc('verification')
          .set({
        'idType': _selectedIdType.text,
        'professionalWebsite': professionalWebsiteLinks,
        'socialMedia': socialMediaLinks,
        'frontImageUrl': frontImageUrl,
        'backImageUrl': backImageUrl,
        'timestamp': FieldValue.serverTimestamp(),
        'requestingVerification': true,
      });
        
      clearAllFields();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification data saved successfully.')),
      );
    } catch (e) {
      print('Error saving data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving verification data.')),
      );
    }
  }
   void clearAllFields() {
    setState(() {
      _frontImage = null;
      _backImage = null;
      _selectedIdType.clear();
      _professionalWebsiteControllers.clear();
      _socialMediaControllers.clear();
    });
  }

  void _showDropdown() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: SingleChildScrollView(
            child: Column(
              children: _idTypes.map((idType) {
                return ListTile(
                  title: Text(idType),
                  onTap: () {
                    setState(() {
                      _selectedIdType.text = idType;
                    });
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    return StreamBuilder<DocumentSnapshot>(
        stream:
            fetchUserDataStream(), // Call method to listen for user data changes
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
            final subscriptionStatus =
                userData['subscriptionStatus'] as String?;
            bool isSubscriptionActive = subscriptionStatus == "Active";

            return Scaffold(
                appBar: AppBar(
                  title: const Text('Get Verified'),
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
                body: Stack(children: [
                  SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Container(
                        width: 480,
                        child: Card(
                            margin: EdgeInsets.all(20),
                            child: Container(
                              width: 500,
                              padding: EdgeInsets.all(16.0),
                              child: IgnorePointer(
                                ignoring: !isSubscriptionActive,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      'Verified Freelancers have blue badges next to their names to show they are trustworthy and skilled.',
                                      style: TextStyle(fontSize: 18),
                                      textAlign: TextAlign.start,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: _showDropdown,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12, horizontal: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _selectedIdType.text.isEmpty
                                                  ? 'Select ID Type'
                                                  : _selectedIdType.text,
                                              style: TextStyle(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                            Icon(Icons.arrow_drop_down),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),

                                    if (_frontImage ==
                                        null) // Show "Choose Front of ID" button if not selected
                                      TextButton(
                                        onPressed: () async {
                                          await selectId(
                                              true); // Select the front of the ID
                                        },
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.only(left: 10.0),
                                          child: Text('Choose Front of ID',
                                              style:
                                                  TextStyle(color: Colors.blue, fontSize: 18)),
                                        ),
                                      )
                                    else // If front ID is set, show image and "Choose Back of ID" button
                                      Column(
                                        children: [
                                          Image.memory(
                                            _frontImage!,
                                            width: 200,
                                            height: 200,
                                            fit: BoxFit.cover,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          if (_backImage ==
                                              null) // If back ID is not set, show "Choose Back of ID"
                                            TextButton(
                                              onPressed: () async {
                                                await selectId(
                                                    false); // Select the back of the ID
                                              },
                                              child: Container(
                                                alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.only(left: 10.0),
                                                child: Text('Choose Back of ID',
                                                    style: TextStyle(
                                                        color: Colors.blue, fontSize: 18)),
                                              ),
                                            )
                                          else // If back ID is set, show the back image
                                            Image.memory(
                                              _backImage!,
                                              width: 200,
                                              height: 200,
                                              fit: BoxFit.cover,
                                            ),
                                        ],
                                      ),

                                    SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: _professionalWebsiteControllers
                                          .map((controller) {
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: CupertinoTextField(
                                            controller: controller,
                                            placeholder:
                                                'Professional Website or Portfolio',
                                            style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),

                                    TextButton(
                                      onPressed:
                                          _addProfessionalWebsiteField, // Add a new field
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Text(
                                            'Professional Website/Portfolio',
                                            style: TextStyle(color: Colors.blue, fontSize: 18)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Column(
                                      children: _socialMediaControllers
                                          .map((controller) {
                                        return Padding(
                                          padding: EdgeInsets.only(bottom: 5),
                                          child: CupertinoTextField(
                                            controller: controller,
                                            placeholder: 'Social Media Link',
                                            style: TextStyle(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),

                                    // Button to add a new social media field
                                    TextButton(
                                      onPressed:
                                          _addSocialMediaField, // Add a new field
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        padding: const EdgeInsets.only(left: 10.0),
                                        child: Text('Social Media Link',
                                            style: TextStyle(color: Colors.blue, fontSize: 18)),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: 250,
                                      height: 35,
                                      margin: EdgeInsets.all(10.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.blueAccent),
                                          elevation:
                                              MaterialStateProperty.all<double>(
                                                  5),
                                        ),
                                        onPressed: saveVerificationData,
                                        child: Text(
                                          'Request for Verification',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    if (subscriptionStatus != "Active")
                                      Center(
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                              sigmaX: 2, sigmaY: 2),
                                          child: Container(
                                            color: Colors
                                                .transparent, // Semi-transparent overlay
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Subscribe to access this feature",
                                                    style: TextStyle(
                                                      color: isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Container(
                                                      width: 250,
                                                      height: 35,
                                                      margin:
                                                          EdgeInsets.all(10.0),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      child: ElevatedButton(
                                                          style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        Colors
                                                                            .blueAccent),
                                                            elevation:
                                                                MaterialStateProperty
                                                                    .all<double>(
                                                                        5),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            SubscriptionsPayment()));
                                                          },
                                                          child: Text(
                                                            'Subscribe Now',
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                color: Colors
                                                                    .white),
                                                          )))
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ))),
                  )
                ]));
          }
        });
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

  Future<void> selectId(bool isFront) async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        if (isFront) {
          _frontImage = img; // Update the front image
        } else {
          _backImage = img; // Update the back image
        }
      });
    } else {
      print('No Image Selected');
    }
  }

  Future<Uint8List?> pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No Image Selected');
      return null;
    }
  }
}
