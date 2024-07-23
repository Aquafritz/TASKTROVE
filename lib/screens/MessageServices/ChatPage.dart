// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tasktroveprojects/screens/MessageServices/ChatBubbles.dart';
import 'package:tasktroveprojects/screens/MessageServices/ChatServices.dart';
import 'package:tasktroveprojects/screens/MessageServices/ViewImage.dart';
import 'package:tasktroveprojects/screens/Theme/ThemeProvider.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;

  const ChatPage({
    required this.receiverUserEmail,
    required this.receiverUserID,
    super.key,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final ScrollController _scrollController = ScrollController();
   Uint8List? _selectedImage;

    bool isAnimationDone = false;
    String firstName = "";
    String lastName = "";

  @override
  void initState() {
    super.initState();
    _startLoadingAnimation();
    _fetchReceiverInfo();
  }

  void _startLoadingAnimation() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        isAnimationDone = true;
      });
    });
  }

   Future<void> _fetchReceiverInfo() async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.receiverUserID)
          .get();

      if (userDoc.exists) {
        setState(() {
          firstName = userDoc['firstName'];
          lastName = userDoc['lastName'];
        });
      }
    } catch (e) {
      print("Error fetching receiver info: $e");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _selectImage() async {
    Uint8List? image = await _pickImage(ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<Uint8List?> _pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    } else {
      print('No Image Selected');
      return null;
    }
  }

   void _sendMessage() {
  bool hasMessage = _messageController.text.isNotEmpty; // Check if there's a message
  bool hasImage = _selectedImage != null; // Check if there's an image

  if (!hasMessage && !hasImage) {
    // If there's neither a message nor an image, do nothing
    return;
  }

  if (hasImage) {
    _uploadImageToStorage(_selectedImage!).then((imageUrl) {
      if (hasMessage) {
        // If there's both a message and an image
        _chatService.sendMessageWithImage(
          widget.receiverUserID,
          _messageController.text,
          imageUrl,
        );
      } else {
        // If there's only an image
          _chatService.sendMessageWithImage(
    widget.receiverUserID,
    "", // explicitly set an empty message
    imageUrl,
  );
}
      _selectedImage = null; // Clear the selected image
      _messageController.clear();
      setState(() {});
    });
  } else if (hasMessage) {
    // If there's only a message
    _chatService.sendMessage(
      widget.receiverUserID,
      _messageController.text,
    );
    _messageController.clear();
  }
}

  Future<String> _uploadImageToStorage(Uint8List image) async {
    // Ensure valid Firebase Auth user
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception("User not authenticated");
    }

    Reference ref = FirebaseStorage.instance
        .ref()
        .child('message_pictures/${currentUser.uid}/${DateTime.now().millisecondsSinceEpoch}');

    UploadTask uploadTask = ref.putData(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('$firstName $lastName'),
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
          Expanded(
            child: _buildMessageList(),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }
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
        List<DocumentSnapshot> messages = snapshot.data!.docs.reversed.toList();
        return ListView(
          controller: _scrollController,
          reverse: true,
          children: messages.map((doc) {
            return _buildMessageItem(doc);
          }).toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

    if (data != null) {
    String? message = data['message'];
    String? imageUrl = data['imageUrl'];
    bool hasContent = (message != null && message.isNotEmpty) || (imageUrl != null && imageUrl.isNotEmpty);

    if (!hasContent) {
      // If there's no message and no image, do not display anything
      return Container();
    }

    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

      return Container(
        alignment: alignment,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment:
                (data['senderId'] == _firebaseAuth.currentUser!.uid)
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
            children: [
              if (message != null && message.isNotEmpty)
              ChatBubble(
               message: message,
                isSender: data['senderId'] == _firebaseAuth.currentUser!.uid,
                imageUrl: imageUrl,
              ),
              if (imageUrl != null && imageUrl.isNotEmpty)
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => FullImagePage(imageUrl: imageUrl)));
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    height: 200,
                    width: 150,
                fit: BoxFit.cover, // Ensures the entire image is displayed
                  ),
                ),
              )
            ],
          ),
        ),
      );
    }
    return Container(); 
  }

  Widget _buildMessageInput() {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
 bool isDarkMode = themeProvider.isDarkMode;

    return Padding(
      padding: const EdgeInsets.all( 10),
      child: Row(
        children: [
          IconButton(onPressed: _selectImage, icon: Icon(Icons.add_a_photo_outlined, size: 30, color: Colors.blueAccent,)),
          if (_selectedImage != null) ...[
            Container(
              width: 50,
              height: 50,
              child: Image.memory(
                _selectedImage!,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10),
          ],
          Expanded(
            child: Container(
              height: 60,
              child: CupertinoTextField(
                controller: _messageController,
                placeholder: 'Enter Message',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                obscureText: false,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                    color:
                        isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200),
                cursorColor: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: Icon(
              Icons.send_outlined,
              size: 30,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
} 