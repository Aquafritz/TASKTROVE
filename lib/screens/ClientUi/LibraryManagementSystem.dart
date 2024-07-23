// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tasktroveprojects/screens/ClientUi/Client.dart';
import 'package:tasktroveprojects/screens/ClientUi/LibraryPdfViewer.dart';

class LibraryManagementSystem extends StatelessWidget {
  final String firstName;
  final String lastName;
  const LibraryManagementSystem(
      {required this.firstName, required this.lastName, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: ClientDrawerNavigationDrawer(
        firstName: firstName,
        lastName: lastName,
      ),
      appBar: AppBar(
        title: const Text('Library'),
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/AlgorithmsNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/Algorithms.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/Angular2Notes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/Angular2.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Algorithms Notes',
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      'Angular2 Notes',
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/AngularJSNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/AngularJS.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/CNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/C.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'AngularJS Notes',
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      'C Notes',
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/CSharpNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/CSharp.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/CSSNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/CSS.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'C-Sharp Notes',
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      'Css Notes',
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath:
                                      "assets/pdf/EntityFrameworkNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/EntityFramework.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/ExcelVBANotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/ExcelVBA.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Entity Framework Notes',
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      'Excel VBA Notes',
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/GitNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/Git.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/HaskellNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/Haskell.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Git Notes',
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      'Haskell Notes',
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/HTML5CanvasNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/HTML5Canvas.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/HTML5Notes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/HTML5.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'HTML-5 Canvas Notes',
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      'HTML-5 Notes',
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/JavaNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/Java.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/jQueryNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/JQuery.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Java Notes',
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      'J-Query Notes',
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/JavaLinuxNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/JavaLinux.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/KotlinNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/Kotlin.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Java Linux Notes',
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      'Kotlin Notes',
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/LinuxNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/Linux.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/MATLABNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/MATLAB.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Linux Notes',
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      'MATLAB Notes',
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath:
                                      "assets/pdf/MicrosoftSQLServerNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage('assets/LibPic/MicrosoftSQLServer.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/MySQLNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/MySQL.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Microsoft SQL Server Notes',
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      'MySQL Notes',
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/NodeJSNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/NodeJS.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/PerlNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/Perl.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Node JS Notes',
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      'Perl Notes',
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/PHP.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/PHP.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/PowerShellNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/PowerShell.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'PHP Notes',
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      'Power Shell Notes',
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/ReactJSNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/ReactJS.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/ReactNativeNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/ReactNative.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'React JS Notes',
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      'React Native Notes',
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/RubyNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/Ruby.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/RubyOnRailsNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/RubyOnRails.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Ruby Notes',
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      'Ruby On Rails Notes',
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath:
                                      "assets/pdf/SpringFrameworkNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/SpringFramework.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/Sql.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/SQL.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Spring Framework Notes',
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      'SQL Notes',
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/TypeScriptNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/TypeScript.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/VBANotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/VisualBasic.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Type Script Notes',
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      'Visual Basic App Notes',
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath:
                                      "assets/pdf/VisualBasic_NETNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/VisualBasicNet.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LibraryPdfViewer(
                                  pdfPath: "assets/pdf/XamarinFormsNotes.pdf",
                                )));
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/LibPic/Xamarin.png'),
                        fit: BoxFit.cover,
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.all(25),
                    padding: EdgeInsets.all(16),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      'Visual Basic NET Notes',
                      textAlign: TextAlign.center,
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      'Xamarin Forms Notes',
                      textAlign: TextAlign.center,
                    )),
              ],
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}