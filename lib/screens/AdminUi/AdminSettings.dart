// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tasktroveprojects/screens/AdminUi/AdminHome.dart';
import 'package:tasktroveprojects/screens/Theme/ThemeProvider.dart';

class AdminSetting extends StatelessWidget {
  const AdminSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AdminDrawerNavigationDrawer(),
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
        body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(25),
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
      );
  }
}