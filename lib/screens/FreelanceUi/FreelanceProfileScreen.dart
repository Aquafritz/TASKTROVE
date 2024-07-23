// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, avoid_print, no_leading_underscores_for_local_identifiers, unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tasktroveprojects/screens/FreelanceUi/Freelancer.dart';
import 'package:tasktroveprojects/screens/Theme/ThemeProvider.dart';

class FreelanceProfileScreen extends StatefulWidget {
  const FreelanceProfileScreen({super.key});

  @override
  State<FreelanceProfileScreen> createState() => _FreelanceProfileScreenState();
}

class _FreelanceProfileScreenState extends State<FreelanceProfileScreen> {
  final TextEditingController _educationtrainingController =
      TextEditingController();
  final TextEditingController _serviceCategoryController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  Uint8List? _image;
  String? _imageUrl;
  String _firstName = ''; // Declare _firstName here
  String _lastName = '';
  bool _isRequestingVerification = false;

  final List<String> _serviceCategoryRecommendations = [
    "Web Developer",
    "UI/UX Designer",
    "Front-End Developer",
    "Back-End Developer",
    "Game Developer",
    "Full Stack Developer"
  ];

  List<String> _imageUrls = [""];
  List<String> _codes = [""];

  @override
  void initState() {
    super.initState();

    String uid =
        FirebaseAuth.instance.currentUser!.uid; // Ensure user is signed in
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("get_verified")
        .doc("verification")
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        _isRequestingVerification = data['requestingVerification'] ??
            true; // Fetch requestingVerification status
        setState(() {});
      }
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        _educationtrainingController.text = data['educationtraining'] ?? '';
        _locationController.text = data['location'] ?? '';
        List<String> serviceCategories =
            List<String>.from(data['serviceCategory'] ?? []);
        _serviceCategoryController.text = serviceCategories.join(', ');
        _birthdayController.text = data['birthday'] ?? '';
        _bioController.text = data['bio'] ?? '';
        _skillController.text = data['skill'] ?? '';
        _imageUrl = data['imageLink'];
        _firstName = data['firstName'] ?? '';
        _lastName = data['lastName'] ?? '';
        _codes = List<String>.from(data['codes'] ?? []);
        setState(() {});
      }
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        _imageUrls = List<String>.from(data['portfolio'] ?? []);
        _codes = List<String>.from(data['codes'] ?? []);
        setState(() {}); // Re-render the widget
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
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
        body: SingleChildScrollView(
          child: Stack(children: [
            Center(
                child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    _showDialogBox(context);
                  },
                  child: _imageUrl != null
                      ? CircleAvatar(
                          radius: 100,
                          backgroundImage: NetworkImage(_imageUrl!),
                        )
                      : CircleAvatar(
                          radius: 100,
                          backgroundImage: NetworkImage(
                              'https://cdn4.iconfinder.com/data/icons/linecon/512/photo-512.png'),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 20),
                        child:
                            Text(_firstName, style: TextStyle(fontSize: 30))),
                    SizedBox(
                      width: 5,
                    ),
                    Text(_lastName, style: TextStyle(fontSize: 30)),
                    if (!_isRequestingVerification) ...[
                      SizedBox(width: 5),
                      Icon(Icons.verified, color: Colors.blue),
                    ],
                    Container(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          _showEditNameDialog(context);
                        },
                        icon: Icon(Icons.edit),
                      ),
                    ),
                  ],
                ),
                if (!_isRequestingVerification) ...[
                  SizedBox(height: 10),
                  Text("This account is verified",
                      style: TextStyle(color: Colors.green)),
                ],
                Container(
                  width: 480,
                  child: Card(
                    margin: EdgeInsets.all(20),
                    child: Container(
                      width: 500,
                      padding: EdgeInsets.all(16.0),
                      child: Column(children: [
                        Text(
                          'My Details',
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
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Service Category',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            _serviceCategoryController.text,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.add,
                                size: 30,
                              ), // Plus icon to add new services
                              onPressed:
                                  _showAddServiceDialog, // Trigger the dialog
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Location',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            _locationController.text,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              _showEditDialog(
                                  context, 'Location', _locationController);
                            },
                            icon: Icon(
                                Icons.edit), // Change the icon to the edit icon
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Birthday',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.only(left: 30),
                          child: Text(
                            _birthdayController.text,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              _showDatePickerDialog(
                                  context); // Show the date picker dialog
                            },
                            child: Icon(Icons.edit),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Education & Training',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 30),
                            child: Text(
                              _educationtrainingController.text,
                              style: TextStyle(fontSize: 18),
                            )),
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              _showEditDialog(context, 'Education & Training',
                                  _educationtrainingController);
                            },
                            icon: Icon(
                                Icons.edit), // Change the icon to the edit icon
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Skill',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 30),
                            child: Text(
                              _skillController.text,
                              style: TextStyle(fontSize: 18),
                            )),
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              _showEditDialog(
                                  context, 'Skill', _skillController);
                            },
                            icon: Icon(
                                Icons.edit), // Change the icon to the edit icon
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Bio',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 30),
                            child: Text(
                              _bioController.text,
                              style: TextStyle(fontSize: 18),
                            )),
                        Container(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              _showEditDialog(context, 'Bio', _bioController);
                            },
                            icon: Icon(
                                Icons.edit), // Change the icon to the edit icon
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
                      ]),
                    ),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'My Portfolio',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Container(
                                      alignment: Alignment.centerLeft,
                                      child: IconButton(
                                        onPressed: () {
                                          _showPorfolioAddOptions(context);
                                        },
                                        icon: Icon(Icons.add_box_outlined),
                                        iconSize: 25,
                                      )),
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
                              ),
                              Column(
                                children: _imageUrls.every((url) => url
                                        .isEmpty) // Check if all URLs are empty
                                    ? [
                                        // If all URLs are empty, display a placeholder or empty widget
                                      ]
                                    : _imageUrls.map((url) {
                                        if (url.isEmpty) {
                                          return SizedBox
                                              .shrink(); // Return empty widget for empty URLs
                                        }
                                        return Padding(
                                          padding: EdgeInsets.all(
                                              8.0), // Padding for the whole item
                                          child: Stack(
                                            children: [
                                              AspectRatio(
                                                aspectRatio:
                                                    1, // Maintain a square aspect ratio
                                                child: Image.network(
                                                  url,
                                                  fit: BoxFit
                                                      .cover, // Make sure the image fills the space
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment
                                                    .bottomRight, // Position the delete icon
                                                child: Padding(
                                                  padding: EdgeInsets.all(
                                                      8.0), // Padding for spacing
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      size: 30,
                                                    ),
                                                    onPressed: () =>
                                                        _deletePortfolioItem(
                                                            url,
                                                            true), // Delete action
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }).toList(),
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _codes.map((code) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0), // Add some padding
                                    child: Column(
                                      children: [
                                        Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Example Code",
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                                alignment: Alignment.centerLeft,
                                                padding:
                                                    EdgeInsets.only(left: 20),
                                                child: Text(
                                                  "$code",
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                )),
                                            IconButton(
                                              icon: Icon(Icons
                                                  .delete,
                                                  color: Colors.red,
                                                      size: 30,), // Delete button
                                              onPressed: () =>
                                                  _deletePortfolioItem(code,
                                                      false), // Delete the image
                                            ),
                                          ],
                                        ),
                                      ],
                                    ), // Display the code
                                  );
                                }).toList(), // Convert the codes to a list of Text widgets
                              ),
                            ]))))
              ],
            )),
          ]),
        ));
  }

  void _deletePortfolioItem(String item, bool isImage) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      if (isImage) {
        // Remove the image from Firebase Storage
        Reference ref = FirebaseStorage.instance.refFromURL(item);
        await ref.delete(); // Delete the image from Firebase Storage

        // Remove the image reference from Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'portfolio': FieldValue.arrayRemove([item]),
        });

        setState(() {
          _imageUrls.remove(item); // Update local state to remove the image
        });
      } else {
        // Remove the code snippet from Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .update({
          'codes': FieldValue.arrayRemove([item]),
        });

        setState(() {
          _codes.remove(item); // Update local state to remove the code
        });
      }
    }
  }

  void _showAddServiceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: _serviceCategoryRecommendations.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                child: Text(
                  _serviceCategoryRecommendations[index],
                  style: TextStyle(fontSize: 18),
                ),
              ),
              onTap: () {
                // Add the selected category to the service category controller
                setState(() {
                  List<String> existingServices = _serviceCategoryController
                      .text
                      .split(',')
                      .map((s) => s.trim())
                      .where((s) => s.isNotEmpty)
                      .toList();

                  if (!existingServices
                      .contains(_serviceCategoryRecommendations[index])) {
                    existingServices
                        .add(_serviceCategoryRecommendations[index]);
                  }

                  _serviceCategoryController.text = existingServices.join(', ');
                });

                Navigator.pop(context); // Close the modal sheet
                _showEditDialog(
                    context, 'Service Category', _serviceCategoryController);
              },
            );
          },
        );
      },
    );
  }

  void _showEditNameDialog(BuildContext context) {
    TextEditingController firstNameController =
        TextEditingController(text: _firstName);
    TextEditingController lastNameController =
        TextEditingController(text: _lastName);

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
        bool isDarkMode = themeProvider.isDarkMode;
        return CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Edit Name",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CupertinoTextField(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: isDarkMode
                        ? Colors.grey.shade800
                        : Colors.grey.shade200),
                cursorColor: isDarkMode ? Colors.white : Colors.black,
                controller: firstNameController,
                placeholder: 'Enter First Name',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
              SizedBox(
                height: 10,
              ),
              CupertinoTextField(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: isDarkMode
                        ? Colors.grey.shade800
                        : Colors.grey.shade200),
                cursorColor: isDarkMode ? Colors.white : Colors.black,
                controller: lastNameController,
                placeholder: 'Enter Last Name',
                style:
                    TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
            ],
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
                setState(() {
                  _firstName = firstNameController.text;
                  _lastName = lastNameController.text;
                  _firstNameController.text =
                      firstNameController.text; // Update controller
                  _lastNameController.text = lastNameController.text;
                });
                saveProfile('First Name');
                saveProfile('Last Name');
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.blueAccent, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDatePickerDialog(BuildContext context) async {
    final ThemeData theme = Theme.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: Colors.blueAccent, // Set button color to blueAccent
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != DateTime.now()) {
      String formattedDate = DateFormat('MMMM dd, yyyy').format(picked);
      setState(() {
        _birthdayController.text = formattedDate;
      });
      saveProfile('Birthday');
    }
  }

  void _showEditDialog(BuildContext context, String fieldName,
      TextEditingController controller) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
        bool isDarkMode = themeProvider.isDarkMode;
        return CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Edit $fieldName",
              style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
          ),
          content: CupertinoTextField(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color:
                    isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
            cursorColor: isDarkMode ? Colors.white : Colors.black,
            controller: controller,
            placeholder: 'Enter $fieldName',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
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
                setState(() {}); // Update the UI to reflect changes
                saveProfile(fieldName);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.blueAccent, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDialogBox(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
        bool isDarkMode = themeProvider.isDarkMode;
        return CupertinoAlertDialog(
          title: Text(
            "Profile",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  // Define action for View Profile button
                },
                child: Text(
                  'View Profile',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  selectImage();
                },
                child: Text(
                  'Change Profile',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 18),
                ),
              ),
            ],
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
                  saveProfile('_imgUrl');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FreelanceHomeScreen(),
                    ),
                  );
                },
                child: Text(
                  "Save",
                  style: TextStyle(color: Colors.blueAccent, fontSize: 18),
                ))
          ],
        );
      },
    );
  }

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
    }
  }

  Future<Uint8List?> pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No Image Selected');
      return null; // Return null or handle the absence of image appropriately
    }
  }

  void saveProfile(String field) async {
    String bio = _bioController.text;
    String skill = _skillController.text;
    String serviceCategory = _serviceCategoryController.text;
    String location = _locationController.text;
    String educationtraining = _educationtrainingController.text;
    String birthday = _birthdayController.text;

    try {
      // Get the current user
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Check which field is being updated
        Map<String, dynamic> updatedFields = {};
        switch (field) {
          case 'First Name':
            updatedFields['firstName'] = _firstNameController.text;
            break;
          case 'Last Name':
            updatedFields['lastName'] = _lastNameController.text;
            break;
          case 'Service Category':
            // Convert the current text to a list of unique items
            List<String> serviceCategory = _serviceCategoryController.text
                .split(',')
                .map((s) => s.trim())
                .where((s) => s.isNotEmpty)
                .toList();

            updatedFields['serviceCategory'] = serviceCategory;
            break;
          case 'Location':
            updatedFields['location'] = location;
            break;
          case 'Education & Training':
            updatedFields['educationtraining'] = educationtraining;
            break;
          case 'Birthday':
            updatedFields['birthday'] = birthday;
            break;
          case 'Skill':
            updatedFields['skill'] = skill;
            break;
          case 'Bio':
            updatedFields['bio'] = bio;
            break;
        }

        // Upload the image if it's available
        if (_image != null) {
          String uniqueFileName =
              '${currentUser.uid}-${DateTime.now().millisecondsSinceEpoch}';
          String imageUrl =
              await StoreData().uploadImageToStorage(uniqueFileName, _image!);
          updatedFields['imageLink'] = imageUrl;
        }

        // Update user data in Firestore only if there are changes
        if (updatedFields.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .update(updatedFields);
          print('Profile updated successfully');
        } else {
          print('No changes to update');
        }
      } else {
        print('No user is currently logged in');
      }
    } catch (err) {
      print('Error saving profile: $err');
    }
  }

  void _showPorfolioAddOptions(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
        bool isDarkMode = themeProvider.isDarkMode;
        return CupertinoAlertDialog(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                "Add to Portfolio",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      selectImageFromGallery(); // Open the gallery to select an image
                    },
                    child: Text(
                      "Select a Picture",
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 18),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                      _showEnterCodeDialog(context);
                    },
                    child: Text(
                      "Post a Example Code",
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

  void selectImageFromGallery() async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (_file != null) {
      Uint8List imgBytes = await _file.readAsBytes();
      _showSaveImageDialog(context, imgBytes);
    } else {
      print('No image selected');
    }
  }

  void _showSaveImageDialog(BuildContext context, Uint8List imgBytes) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
        bool isDarkMode = themeProvider.isDarkMode;
        return CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Save Image",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          content: Text(
            "Do you want to save the selected image to your portfolio?",
            style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black, fontSize: 15),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dismiss the dialog without saving
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                saveImageToStorageAndFirestore(imgBytes); // Save the image
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.blueAccent, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  void saveImageToStorageAndFirestore(Uint8List imgBytes) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      String uniqueFileName =
          '${currentUser.uid}-${DateTime.now().millisecondsSinceEpoch}';
      Reference ref =
          FirebaseStorage.instance.ref().child('portfolios/$uniqueFileName');

      UploadTask uploadTask = ref.putData(imgBytes);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'portfolio': FieldValue.arrayUnion([downloadUrl]),
      });

      setState(() {
        _imageUrls.add(downloadUrl); // Update local state
      });
    }
  }

  void _showEnterCodeDialog(BuildContext context) {
    TextEditingController _codeController = TextEditingController();

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Enter a your Example Code",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          content: CupertinoTextField(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            minLines: null, // Ensures a minimum of 1 line
            maxLines: null, // Allows the text field to expand vertically
            expands: true,
            controller: _codeController,
            placeholder: "Enter Example Code Here",
            decoration: BoxDecoration(
              border:
                  Border.all(color: Colors.grey), // Add a border for styling
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                String code = _codeController.text.trim();
                if (code.isNotEmpty) {
                  Navigator.pop(context); // Close the dialog
                  _saveCodeToFirestore(code); // Save the code to Firestore
                }
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.blueAccent, fontSize: 18),
              ),
            ),
          ],
        );
      },
    );
  }

  void _saveCodeToFirestore(String code) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({
        'codes': FieldValue.arrayUnion([code]),
      });

      setState(() {
        _codes.add(code); // Add the code to the local list for display
      });

      print("Code saved to Firestore");
    } else {
      print('No user is currently logged in');
    }
  }
}

class StoreData {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child('freelance_profile_images/$childName');
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData({
    required String firstName,
    required String lastName,
    required String field,
    required String serviceCategory,
    required String bio,
    required String skill,
    required Uint8List file,
    required String location,
    required String educationtraining,
    required String birthday,
  }) async {
    String resp = " Some Error Occurred ";
    try {
      // Get the current user
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        if (bio.isNotEmpty ||
            skill.isNotEmpty ||
            serviceCategory.isNotEmpty ||
            location.isNotEmpty ||
            educationtraining.isNotEmpty ||
            birthday.isNotEmpty) {
          // Upload the image to Firebase Storage
          String imageUrl = await uploadImageToStorage('profileImage', file);
          // Update user data in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .update({
            'firstName': firstName,
            'lastName': lastName,
            'serviceCategory': serviceCategory,
            'location': location,
            'educationtraining': educationtraining,
            'birthday': birthday,
            'bio': bio,
            'skill': skill,
            'imageLink': imageUrl,
          });
          resp = 'success';
        }
      } else {
        resp = 'No user is currently logged in';
      }
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }
}
