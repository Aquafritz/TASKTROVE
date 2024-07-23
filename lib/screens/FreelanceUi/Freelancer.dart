// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_import, use_build_context_synchronously, unnecessary_null_in_if_null_operators, unnecessary_cast, non_constant_identifier_names, avoid_print

import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tasktroveprojects/BarGraph/Bar_Graph.dart';
import 'package:tasktroveprojects/screens/Auth/SignInScreen.dart';
import 'package:tasktroveprojects/screens/CrudServices.dart';
import 'package:tasktroveprojects/screens/FreelanceUi/FreelanceProfileScreen.dart';
import 'package:tasktroveprojects/screens/FreelanceUi/FreelanceMessageScreen.dart';
import 'package:tasktroveprojects/screens/FreelanceUi/FreelanceSetting.dart';
import 'package:tasktroveprojects/screens/FreelanceUi/GetVerefied.dart';
import 'package:tasktroveprojects/screens/FreelanceUi/Subscription.dart';
import 'package:tasktroveprojects/screens/FreelanceUi/SubscriptionPayment.dart';
import 'package:tasktroveprojects/screens/Theme/ThemeProvider.dart';

class FreelanceHomeScreen extends StatefulWidget {
  const FreelanceHomeScreen({super.key});

  @override
  State<FreelanceHomeScreen> createState() => _FreelanceHomeScreenState();
}

class _FreelanceHomeScreenState extends State<FreelanceHomeScreen> {
  final CrudServices firestoreService = CrudServices();
   bool isAnimationDone = false;

  Stream<DocumentSnapshot> fetchSubscriptionStatusStream() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .snapshots();
    }
    return Stream.empty(); // Return an empty stream if no user is logged in
  }

  List<List<double>> weeklySummary =
      List.generate(3, (_) => List.generate(7, (_) => 0));

  @override
  void initState() {
    super.initState();
    updateWeeklySummary(); // Update summary on initialization
     _startLoadingAnimation();
  }

  void _startLoadingAnimation() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        isAnimationDone = true;
      });
    });
  }

  void updateWeeklySummary() {
    List<double> ongoingCounts = List.generate(7, (_) => 0);
    List<double> doneCounts = List.generate(7, (_) => 0);
    List<double> canceledCounts = List.generate(7, (_) => 0);

    firestoreService.getProjectStream().listen((snapshot) {
      // Reset counts to zero to avoid carryover from previous calculations
      ongoingCounts.fillRange(0, 7, 0);
      doneCounts.fillRange(0, 7, 0);
      canceledCounts.fillRange(0, 7, 0);

      for (final doc in snapshot.docs) {
        final projectData = doc.data() as Map<String, dynamic>;
        final status = projectData['status'] ?? 'ongoing';
        final dayOfWeek = projectData['timeStamp'].toDate().weekday;

        int index = (dayOfWeek == 7 ? 0 : dayOfWeek - 1);

        switch (status) {
          case 'done':
            doneCounts[index] += 1;
            break;
          case 'canceled':
            canceledCounts[index] += 1;
            break;
          default:
            ongoingCounts[index] += 1;
            break;
        }
      }

      setState(
          () => weeklySummary = [ongoingCounts, doneCounts, canceledCounts]);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;
    final CrudServices firestoreService = CrudServices();
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
          final subscriptionStatus = userData['subscriptionStatus'] as String?;
          bool isSubscriptionActive = subscriptionStatus == "Active";

          return Scaffold(
              appBar: AppBar(
                title: const Text('Home'),
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
              floatingActionButton: FloatingActionButton(
                backgroundColor: isSubscriptionActive
                    ? Colors.blueAccent
                    : Colors.grey, // Gray out if not active
                onPressed: () {
                  if (isSubscriptionActive) {
                    openProjectBox(context); // Add project only if active
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            "You need to subscribe to access this feature."),
                        action: SnackBarAction(
                          label: "Subscribe",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SubscriptionsPayment()),
                            );
                          },
                        ),
                      ),
                    ); // Show Snackbar if subscription is inactive
                  }
                },
                child: Icon(
                  Icons.add_box_outlined,
                  size: 30,
                ),
              ),
              drawer: FreelanceDrawerNavigationDrawer(
                firstName: userData['firstName'],
                lastName: userData['lastName'],
              ),
              body: Stack(children: [
                SingleChildScrollView(
                    child: Column(children: [
                      SizedBox(
                        height: 30,
                      ),
                  // Bar graph at the top
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 300,
                      child: myBarGraph(weeklySummary: weeklySummary),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: firestoreService.getProjectStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List projectList = snapshot.data!.docs;
                        return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: projectList.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot document = projectList[index];
                            String docId = document.id;

                            Map<String, dynamic> data =
                                document.data() as Map<String, dynamic>;
                            String projectText = data['project'];
                            String clientName = data.containsKey('clientName')
                                ? data['clientName']
                                : 'No client name';
                            String projectDescription =
                                data.containsKey('projectDescription')
                                    ? data['projectDescription']
                                    : 'No description';
                            return Container(
                              width: 480,
                              child: Card(
                                margin: EdgeInsets.all(20),
                                child: Container(
                                  width: 500,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Text(
                                              'Projects',
                                              style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20.0),
                                            child: IconButton(
                                                onPressed: () {
                                                  _showProjectOptions(context,
                                                      docId, firestoreService);
                                                },
                                                icon: Icon(
                                                  Icons
                                                      .settings_applications_outlined,
                                                  size: 25,
                                                )),
                                          ),
                                        ],
                                      ),
                                      ListTile(
                                        title: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 15,
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(
                                                clientName,
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(projectText,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20.0),
                                              child: Text(projectDescription,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  )),
                                            ),
                                            SizedBox(
                                              height: 30,
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
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                      elevation:
                                                          MaterialStateProperty
                                                              .all<double>(5),
                                                    ),
                                                    onPressed: () {
                                                      firestoreService
                                                          .updateProject(
                                                        docId: docId,
                                                        newProject: projectText,
                                                        newClientName:
                                                            clientName,
                                                        newProjectDescription:
                                                            projectDescription,
                                                        newStatus:
                                                            'done', // Changing status to "done"
                                                      );
                                                      updateWeeklySummary();
                                                    },
                                                    child: Text(
                                                      'Done',
                                                      style: TextStyle(
                                                          color: Colors.blue,
                                                          fontSize: 18),
                                                    )),
                                                ElevatedButton(
                                                    style: ButtonStyle(
                                                      elevation:
                                                          MaterialStateProperty
                                                              .all<double>(5),
                                                    ),
                                                    onPressed: () {
                                                      firestoreService
                                                          .updateProject(
                                                        docId: docId,
                                                        newProject: projectText,
                                                        newClientName:
                                                            clientName,
                                                        newProjectDescription:
                                                            projectDescription,
                                                        newStatus:
                                                            'canceled', // Changing status to "done"
                                                      );
                                                      updateWeeklySummary();
                                                    },
                                                    child: Text(
                                                      'Cancel',
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 18),
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return Text('...No Project...');
                      }
                    },
                  ),

                  if (subscriptionStatus != "Active")
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Container(
                        color: Colors.transparent, // Semi-transparent overlay
                        child: Center(
                          child: Column(
                            children: [
                              Text(
                                "Subscribe to access this feature",
                                style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                            MaterialStateProperty.all<double>(
                                                5),
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
                                            fontSize: 20, color: Colors.white),
                                      )))
                            ],
                          ),
                        ),
                      ),
                    ),
                ])),
              ]));
        }
      },
    );
  }

  void _showProjectOptions(
      BuildContext context, String docId, CrudServices firestoreService) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
        bool isDarkMode = themeProvider.isDarkMode;
        return CupertinoAlertDialog(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Project",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => openProjectBox(context, docID: docId),
                    child: Text(
                      "Update Project",
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 18),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      firestoreService.deleteProject(docId);
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text(
                      "Delete Project",
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 18),
                    ),
                  ),
                ]),
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
            ]);
      },
    );
  }

  void openProjectBox(BuildContext context, {String? docID}) {
    final CrudServices firestoreService = CrudServices();
    TextEditingController projectController = TextEditingController();
    TextEditingController clientnameController = TextEditingController();
    TextEditingController projectDescriptionController =
        TextEditingController();
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
          bool isDarkMode = themeProvider.isDarkMode;
          return CupertinoAlertDialog(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Project",
                style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 20),
              ),
            ),
            content: Column(
              children: [
                CupertinoTextField(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  controller: clientnameController,
                  placeholder: 'Client Name',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 18),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CupertinoTextField(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  controller: projectController,
                  placeholder: 'Project Name',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 18),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CupertinoTextField(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  minLines: null, // Ensures a minimum of 1 line
                  maxLines: null, // Allows the text field to expand vertically
                  expands: true,
                  controller: projectDescriptionController,
                  placeholder: 'Project Description',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 18),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (docID == null) {
                    firestoreService.addProject(
                      projectName: projectController.text,
                      clientName: clientnameController.text,
                      projectDescription: projectDescriptionController.text,
                    );
                    updateWeeklySummary();
                  } else {
                    firestoreService.updateProject(
                      docId: docID,
                      newProject: projectController.text,
                      newClientName: clientnameController.text,
                      newProjectDescription: projectDescriptionController.text,
                      newStatus: 'ongoing',
                    );
                    updateWeeklySummary();
                  }
                  Navigator.pop(context); // Close the dialog after saving
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                ),
              ),
            ],
          );
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
}

class FreelanceDrawerNavigationDrawer extends StatefulWidget {
  final String firstName;
  final String lastName;

  const FreelanceDrawerNavigationDrawer(
      {required this.firstName, required this.lastName, super.key});

  @override
  State<FreelanceDrawerNavigationDrawer> createState() =>
      _FreelanceDrawerNavigationDrawerState();
}

class _FreelanceDrawerNavigationDrawerState
    extends State<FreelanceDrawerNavigationDrawer> {
  late String imageUrl;
  bool isAnimationDone = false;

  @override
  void initState() {
    super.initState();
    // Fetch the initial user data and image URL
    fetchUserImage();
     _startLoadingAnimation();
  }

  void _startLoadingAnimation() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        isAnimationDone = true;
      });
    });
  }
  

  void fetchUserImage() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      final userData = snapshot.data() as Map<String, dynamic>;
      setState(() {
        imageUrl = userData['imageLink'] as String? ??
            ''; // Ensure imageUrl is not null
      });
    }
  }

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
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;
    final currentUser = FirebaseAuth.instance.currentUser;

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || !isAnimationDone) {
          return Center(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF8C52FF), // First gradient color
                  Color(0xFFFF914D), // Second gradient color
                ],
              ),
            ),
            child: Center(
              child: Lottie.asset(
                'assets/animations/Loading.json',
                width: 200,
                height: 200,
                fit: BoxFit.contain, // Adjust the fit as needed
              ),
            ),
            )
            ); // Show loading indicator while fetching data
        } else if (snapshot.hasError || !snapshot.hasData) {
          return Text(
              'Error: Unable to fetch user data'); // Show error message if data fetching failed
        } else {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final imageUrl = userData['imageLink'] as String?;

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
            child: Column(
              children: [
                CircleAvatar(
                  radius: 80,
                  backgroundImage: imageUrl != null
                      ? NetworkImage(imageUrl)
                      : NetworkImage(
                          'https://cdn4.iconfinder.com/data/icons/linecon/512/photo-512.png'),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.firstName),
                    SizedBox(
                      width: 5,
                    ),
                    Text(widget.lastName),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FreelanceProfileScreen()));
                  },
                  child: Text(
                    'View Profile',
                    style: TextStyle(
                        color: isDarkMode
                            ? Colors.white
                            : Colors.black),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }

  buildMenuItems(BuildContext context) => Container(
        padding: EdgeInsets.all(15),
        child: Wrap(
          runSpacing: 10,
          children: [
            ListTile(
              leading: Icon(Icons.home_outlined),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FreelanceHomeScreen()));
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FreelanceMessageScreen(
                              firstName: widget.firstName,
                              lastName: widget.lastName,
                            )));
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
              title: Text('Subscription'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Subscription(
                              firstName: widget.firstName,
                              lastName: widget.lastName,
                            )));
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FreelanceSettings(
                              firstName: widget.firstName,
                              lastName: widget.lastName,
                            )));
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
              builder: (context) =>
                  SignInScreen())); // Navigate to login screen
    }).catchError((error) {
      print("Sign out error: $error"); // Handle sign out error, if any
    });
  }
}
