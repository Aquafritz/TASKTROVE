// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasktroveprojects/screens/ClientUi/Client.dart';
import 'package:tasktroveprojects/screens/FreelanceUi/Terms_of_Services.dart';
import 'package:tasktroveprojects/screens/Theme/ThemeProvider.dart';

class ClientSettings extends StatelessWidget {
  final String firstName;
  final String lastName;
  const ClientSettings({
    required this.firstName,
    required this.lastName,
    super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: ClientDrawerNavigationDrawer(
               firstName: firstName,
        lastName: lastName,
        ),
        appBar: AppBar(
          title: const Text('Settings'),
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
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.fromLTRB(25, 10, 25, 5),
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                      ),
                  ),
                    SizedBox(
                      width: 100,
                    ),
                    CupertinoSwitch(
                      value: Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
                      onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => TermsofServices()));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: EdgeInsets.fromLTRB(25, 10, 25, 5),
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        'Terms of Services',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                        ),
                    ),
                      SizedBox(
                        width: 100,
                      ),
                      Icon(Icons.arrow_right_outlined, size: 30,)
          ],
        ),
              )
            )
          ]
        )
      );
  }
}