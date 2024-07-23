// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace, unnecessary_import, avoid_print, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tasktroveprojects/screens/ClientUi/Client.dart';
import 'package:tasktroveprojects/screens/Theme/ThemeProvider.dart';

class ClientProfileScreen extends StatefulWidget {
  const ClientProfileScreen({super.key});

  @override
  State<ClientProfileScreen> createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  final TextEditingController _educationtrainingController =
      TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _skillController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  Uint8List? _image;
  String? _ImageUrl;
  String _firstName = ''; // Declare _firstName here
  String _lastName = '';

  @override
  void initState() {
    super.initState();
    String uid =
        FirebaseAuth.instance.currentUser!.uid; // Ensure user is signed in
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data()!;
        _educationtrainingController.text = data['educationtraining'] ?? '';
        _locationController.text = data['location'] ?? '';
        _birthdayController.text = data['birthday'] ?? '';
        _bioController.text = data['bio'] ?? '';
        _skillController.text = data['skill'] ?? '';
        _ImageUrl = data['ImageLink'];
        _firstName = data['firstName'] ?? '';
        _lastName = data['lastName'] ?? '';
        setState(() {});
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
          physics: BouncingScrollPhysics(),
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
                  child: _ImageUrl != null
                      ? CircleAvatar(
                          radius: 100,
                          backgroundImage: NetworkImage(_ImageUrl!),
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
                    SizedBox(
                      width: 5,
                    ),
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
                        SizedBox(
                          height: 10,
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
                          height: 10,
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
                          height: 10,
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
                          height: 10,
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
                          height: 10,
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
                          height: 10,
                        ),
                      ]),
                    ),
                  ),
                ),
              ],
            )),
          ]),
        ));
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
            child: Text("Edit Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
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
            ElevatedButton(
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
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
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
            ElevatedButton(
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
        bool isDarkMode = themeProvider.isDarkMode;
        return CupertinoAlertDialog(
          title: Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
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
                      color: isDarkMode ? Colors.white : Colors.black,fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () {
                  selectImage();
                },
                child: Text(
                  'Change Profile',
                  style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,fontSize: 18),
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
                style: TextStyle(color: Colors.red,
                fontSize: 18),
              ),
            ),
            TextButton(
              onPressed: () {
                saveProfile('_ImgUrl');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientHomeScreen(),
                  ),
                );
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.blueAccent,
                   fontSize: 18),
              ),
            ),
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
        String uniqueFileName = '${currentUser.uid}-${DateTime.now().millisecondsSinceEpoch}';
        String imageUrl = await StoreData().uploadImageToStorage(uniqueFileName, _image!);
        updatedFields['ImageLink'] = imageUrl;
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
      // Handle the error appropriately, such as showing a snackbar or alert dialog
    }
  }
}

class StoreData {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(String childName, Uint8List file) async {
    Reference ref = _storage.ref().child('client_profile_images/$childName');
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<String> saveData({
    required String firstName,
    required String lastName,
    required String field,
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
            location.isNotEmpty ||
            educationtraining.isNotEmpty ||
            birthday.isNotEmpty) {
          // Upload the image to Firebase Storage
          String ImageUrl = await uploadImageToStorage('profileImage', file);
          // Update user data in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .update({
            'firstName': firstName,
            'lastName': lastName,
            'location': location,
            'educationtraining': educationtraining,
            'birthday': birthday,
            'bio': bio,
            'skill': skill,
            'ImageLink': ImageUrl,
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
