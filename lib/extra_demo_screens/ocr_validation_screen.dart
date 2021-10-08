// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:nuniyoekyc/widgets/widgets.dart';

class OcrValidationScreen extends StatefulWidget {
  OcrValidationScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _OcrValidationScreenState createState() => _OcrValidationScreenState();
}

class _OcrValidationScreenState extends State<OcrValidationScreen> {
  List<XFile>? _imageFileListAadhar,_imageFileListPan;

  var headers = {
    'Authorization': 'Basic QUlZM0gxWFM1QVBUMkVNRkU1NFVXWjU2SVE4RlBLRlA6R083NUZXMllBWjZLUU0zRjFaU0dRVlVRQ1pQWEQ2T0Y='
  };

  bool isPanOCRVerified = false;

  bool isAadharOCRVerified = false;

  set _imageFilePan(XFile? value) {
    _imageFileListPan = value == null ? null : [value];
  }

  set _imageFileAadhar(XFile? value) {
    _imageFileListAadhar = value == null ? null : [value];
  }

  dynamic _pickImageErrorAadhar,_pickImageErrorPan;
  bool isVideo = false;


  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();


  List<Color> myGradientColor = <Color>[
    Color.fromARGB(255, 127, 0, 255),
    Color.fromARGB(255, 225, 0, 255)
  ];

  void _onImageButtonPressedForAadhar(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
      );
      setState(() {
        _imageFileAadhar = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageErrorAadhar = e;
      });
    }
  }

  void _onImageButtonPressedForPan(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    try {
      final pickedFile = await _picker.pickImage(
        source: source,
      );
      setState(() {
        _imageFilePan = pickedFile;
      });
    } catch (e) {
      setState(() {
        _pickImageErrorPan = e;
      });
    }
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Widget _previewPANImage() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileListPan != null) {
      //Uploading File to Database
      PanOCRValidation(_imageFileListPan![0].path,_imageFileListPan![0]);

      return Expanded(
        child: Semantics(
            child: ListView.builder(
              key: UniqueKey(),
              itemBuilder: (context, index) {
                // Why network for web?
                // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
                return Expanded(
                  child: Semantics(
                    label: 'image_picker_example_picked_image',
                    child: kIsWeb
                        ? Image.network(_imageFileListPan![index].path)
                        : Image.file(File(_imageFileListPan![index].path)),
                  ),
                );
              },
              itemCount: _imageFileListPan!.length,
            ),
            label: 'image_picker_example_picked_images'),
      );
    } else if (_pickImageErrorPan != null) {
      return Text(
        'Pick image error: $_pickImageErrorPan',
        textAlign: TextAlign.center,
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: myGradientColor)
        ),
      );
    }
  }


  Widget _previewAadharImage() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileListAadhar != null) {
      //Uploading File to Database
      AadharOCRValidation(_imageFileListAadhar![0].path,_imageFileListAadhar![0]);

      return Expanded(
        child: Semantics(
            child: ListView.builder(
              key: UniqueKey(),
              itemBuilder: (context, index) {
                // Why network for web?
                // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
                return Expanded(
                  child: Semantics(
                    label: 'image_picker_example_picked_image',
                    child: kIsWeb
                        ? Image.network(_imageFileListAadhar![index].path)
                        : Image.file(File(_imageFileListAadhar![index].path)),
                  ),
                );
              },
              itemCount: _imageFileListAadhar!.length,
            ),
            label: 'image_picker_example_picked_images'),
      );
    } else if (_pickImageErrorAadhar != null) {
      return Text(
        'Pick image error: $_pickImageErrorAadhar',
        textAlign: TextAlign.center,
      );
    } else {
      return Container(
        decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: myGradientColor)
        ),
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: myGradientColor,
                )
            )),
        centerTitle: true,
        title: Text('Tech X'),
      ),
      body: Center(
        child:ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(70),
              child: Stack(
                children: [
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Expanded(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 150.0,
                            child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                                ? FutureBuilder<void>(
                              future: retrieveLostData(),
                              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                    return Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: myGradientColor)
                                      ),
                                    );
                                  case ConnectionState.done:
                                    return _handlePreviewPAN();
                                  default:
                                    if (snapshot.hasError) {
                                      return Text(
                                        'Pick image/video error: ${snapshot.error}}',
                                        textAlign: TextAlign.center,
                                      );
                                    } else {
                                      return Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: myGradientColor)
                                        ),
                                      );
                                    }
                                }
                              },
                            )
                                : _handlePreviewPAN(),
                          ),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Upload Your Pan Card",
                            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),
                          )
                      ),
                          Visibility(
                            visible: isPanOCRVerified,
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Pan Verified Successfully",
                                  style: TextStyle(fontSize: 12.0,color: Colors.green),
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.camera),
                              Text("From Camera"),
                            ],
                          ),
                        ),
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                )
                            )
                        ),
                        onPressed: () {
                          isVideo = false;
                          _onImageButtonPressedForPan(ImageSource.camera, context: context);
                        }
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.collections),
                              Text("From Gallery"),
                            ],
                          ),
                        ),
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )
                            )
                        ),
                        onPressed: () {
                          isVideo = false;
                          _onImageButtonPressedForPan(ImageSource.gallery, context: context);
                        }
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(70,10,70.0,70.0),
              child: Stack(
                children: [
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Expanded(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 150.0,
                            child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
                                ? FutureBuilder<void>(
                              future: retrieveLostData(),
                              builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.none:
                                  case ConnectionState.waiting:
                                    return Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: myGradientColor)
                                      ),
                                    );
                                  case ConnectionState.done:
                                    return _handlePreviewAadhar();
                                  default:
                                    if (snapshot.hasError) {
                                      return Text(
                                        'Pick image/video error: ${snapshot.error}}',
                                        textAlign: TextAlign.center,
                                      );
                                    } else {
                                      return Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            gradient: LinearGradient(
                                                begin: Alignment.centerLeft,
                                                end: Alignment.centerRight,
                                                colors: myGradientColor)
                                        ),
                                      );
                                    }
                                }
                              },
                            )
                                : _handlePreviewAadhar(),
                          ),
                          Padding(
                              padding: EdgeInsets.all(10),
                              child: Text(
                                "Upload Your Aadhar Card",
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),
                              )
                          ),
                          Visibility(
                            visible: isAadharOCRVerified,
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "Aadhar OCR VALIDATED Successfully",
                                  style: TextStyle(fontSize: 12.0,color: Colors.green),
                                )
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.camera),
                              Text("From Camera"),
                            ],
                          ),
                        ),
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )
                            )
                        ),
                        onPressed: () {
                          isVideo = false;
                          _onImageButtonPressedForAadhar(ImageSource.camera, context: context);
                        }
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.collections),
                              Text("From Gallery"),
                            ],
                          ),
                        ),
                        style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )
                            )
                        ),
                        onPressed: () {
                          isVideo = false;
                          _onImageButtonPressedForAadhar(ImageSource.gallery, context: context);
                        }
                    ),
                  )
                ],
              ),
            ),
           WidgetHelper().GradientButton(context, (){WidgetsBinding.instance!.addPostFrameCallback((_){
             Navigator.pushNamed(context, "/personaldetails");
             // Add Your Code here.
           });}, 'Next'),
          ],
        ),
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }


  Widget _handlePreviewAadhar() {
    return _previewAadharImage();
  }

  Widget _handlePreviewPAN() {
    return _previewPANImage();
  }

  Future<void> PanOCRValidation(String imagePath,var imageP) async{
    List<int> _selectedFile = await imageP.readAsBytes();
    var request;
    if(kIsWeb){
      request = http.MultipartRequest('POST', Uri.parse('http://localhost:44300/api/user/login/OCR'));
      request.files.add(await http.MultipartFile.fromBytes('front_part', _selectedFile,
          contentType: new MediaType('application', 'octet-stream'),
          filename: "file_up"));
      request.headers.addAll(headers);
    }
    else{
      request = http.MultipartRequest('POST', Uri.parse('http://localhost:44300/api/user/login/OCR'));
      request.headers.addAll(headers);
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        isPanOCRVerified = true;
      });
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

  Future<void> AadharOCRValidation(String imagePath,var imageP) async{
    List<int> _selectedFile = await imageP.readAsBytes();
    var request;
    if(kIsWeb){
      request = http.MultipartRequest('POST', Uri.parse('http://localhost:44300/api/user/login/OCR'));
      //request.files.add(await http.MultipartFile.fromPath('front_part', '/C:/Users/Tohiba/Downloads/image.jpeg'));
      request.files.add(await http.MultipartFile.fromBytes('front_part', _selectedFile,
          contentType: new MediaType('application', 'octet-stream'),
          filename: "file_up"));
      request.headers.addAll(headers);
    }
    else{
      request = http.MultipartRequest('POST', Uri.parse('http://localhost:44300/api/user/login/OCR'));
      //request.files.add(await http.MultipartFile.fromPath('front_part', '/C:/Users/Tohiba/Downloads/image.jpeg'));
      request.headers.addAll(headers);
    }

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        isAadharOCRVerified = true;
      });
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

}

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);


