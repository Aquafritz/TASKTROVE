// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:tasktroveprojects/screens/MessageServices/ChatPage.dart';

class SubscriptionsPayment extends StatelessWidget {
   final String adminEmail = 'Admin@gmail.com';
  final String adminUserID = '203EdzyHG3dXJCHwihOue5alAXs1'; //
  const SubscriptionsPayment({
    super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  'Hello Freelance',
                  style: TextStyle(
                    fontSize: 30, 
                    fontWeight: FontWeight.bold
                    ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
               Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                  'To Subscribe to our system you can directly pay thru Gcash!',
                  style: TextStyle(
                    fontSize: 15,
                    )
                    ),
               ),
                Text(
                  '--Scan this Qr Code--',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                    )
                    ),
                     SizedBox(
                      height: 10,
                    ),
                Container(
                  width: 500,
                  height: 400,
                  child: Image.asset(
                    'assets/GcashQr.jpg'
                    )
                    ),
                     SizedBox(
                      height: 10,
                    ),
                Text(
                  'Directions',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold
                    )
                    ),
                     SizedBox(
                      height: 10,
                    ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    '1. Screenshot the Receipt of Gcash',
                    style: TextStyle(
                      fontSize: 18,
                      )
                      ),
                ),
                     SizedBox(
                      height: 10,
                    ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                  '2. Send it to the Admin',
                  style: TextStyle(
                    fontSize: 18,
                    )
                    ),
                ),
                     SizedBox(
                      height: 10,
                    ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                  '3. Please wait until it verified by the Admin',
                  style: TextStyle(
                    fontSize: 18,
                    )
                    ),
                ),
                     SizedBox(
                      height: 10,
                    ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                  '4.You will be Receive a message to the Admin after the verification of the transaction',
                  style: TextStyle(
                    fontSize: 18,
                    )
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
                                elevation: MaterialStateProperty.all<double>(5),
                              ),
                  onPressed: (){
                 Navigator.push(
                  context, MaterialPageRoute(
                    builder: (context) => 
                    ChatPage(
                      receiverUserEmail: adminEmail, 
                      receiverUserID: adminUserID
                      )
                      )
                      );
                }, child: Text('Chat Admin',style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),))
                )
              ],
            ),
          ),
        ),
    );
  }
}