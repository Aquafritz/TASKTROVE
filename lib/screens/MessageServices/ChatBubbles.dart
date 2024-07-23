// ignore_for_file: prefer_const_constructors, file_names

import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isSender; 
  final String? imageUrl;
  const ChatBubble({required this.message, super.key, required this.isSender, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment:
          isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isSender ? Colors.blueAccent : Colors.grey.shade600,
          ),
          child: Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
         if (imageUrl != null && imageUrl!.isNotEmpty) // Check if imageUrl is valid
          ...[
            SizedBox(height: 10),
            Image.network(
              imageUrl!, // Safe to use imageUrl
              height: 150,
              fit: BoxFit.cover,
          ),
        ],
      ],
    );
  }
}
