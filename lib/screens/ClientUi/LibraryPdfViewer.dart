// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class LibraryPdfViewer extends StatefulWidget {
   final String pdfPath;
  const LibraryPdfViewer({
    required this.pdfPath,  
    super.key});

  @override
  State<LibraryPdfViewer> createState() => _LibraryPdfViewerState();
}

class _LibraryPdfViewerState extends State<LibraryPdfViewer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Library'),
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
       body: SfPdfViewer.asset(widget.pdfPath),
    );
  }
}