import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FilePicTest extends StatefulWidget {
  const FilePicTest({Key? key}) : super(key: key);

  @override
  _FilePicTestState createState() => _FilePicTestState();
}

class _FilePicTestState extends State<FilePicTest> {

  FilePickerResult? result;

  late PlatformFile file;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nuniyo ProtoType',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          focusColor: Color(0xff6A4EEE),
          focusedBorder:OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Color(0xff6A4EEE), width: 2.0),
          ),
          border: OutlineInputBorder(
              borderSide: new BorderSide(width: 2.0),
              borderRadius: BorderRadius.circular(8.0)
          ),
          contentPadding: EdgeInsets.all(26.0),
          labelStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
        ),
        //This is the theme of your application.
        //
        //Try running your application with "flutter run". You'll see the
        //application has a blue toolbar. Then, without quitting the app, try
        //changing the primarySwatch below to Colors.green and then invoke
        //"hot reload" (press "r" in the console where you ran "flutter run",
        //or simply save your changes to "hot reload" in a Flutter IDE).
        //Notice that the counter didn't reset back to zero; the application
        //is not restarted.
        //#6A4EEE
        primaryColor: Color(0xff6A4EEE),
      ),
      home: Scaffold(
        body: Column(
          children: [
            TextButton(onPressed: PickImage,child: Text("Upload it"),),
            Container(
              height: 200,
              width: 200,
              child: true?SfPdfViewer.file(File(file.path.toString())):null,
            )
          ],
        )
      ),
    );
  }


  PickImage() async {

    result = await FilePicker.platform.pickFiles(type: FileType.custom,
      allowedExtensions: ['pdf'],);

    if(result != null) {
      file = result!.files.first;
      print(file.name);
      print(file.bytes);
      print(file.size);
      print(file.extension);
      print(file.path);
    } else {
      // User canceled the picker
    }
  }
}
