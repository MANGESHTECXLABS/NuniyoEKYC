///Upload Document Screen
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';
import 'package:file_picker/file_picker.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nuniyoekyc/ApiRepository/apirepository.dart';
import 'package:nuniyoekyc/ApiRepository/localapis.dart';
import 'package:nuniyoekyc/utils/localstorage.dart';
import 'package:nuniyoekyc/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import '../globals.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({Key? key}) : super(key: key);

  @override
  _UploadDocumentScreenState createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {


  var headers = {
    'Authorization': 'Basic QUlZM0gxWFM1QVBUMkVNRkU1NFVXWjU2SVE4RlBLRlA6R083NUZXMllBWjZLUU0zRjFaU0dRVlVRQ1pQWEQ2T0Y='
  };

  bool isPanOCRVerified = false;

  bool isAadharOCRVerified = false;

  bool showPanCardImageBox = false;

  bool showDigitalPadBox = false;

  File? imageFilePan = new File("/assets/images/congratulations.png");

  bool tempPanUploaded = false;
  bool tempDigitalPadUploaded = false;

  File? imageFileDigitalSignature = new File("/assets/images/congratulations.png");

  FilePickerResult? result;

  PlatformFile pdfPanImagefile = PlatformFile(name: "/assets/images/congratulations.png", size: 20);
  PlatformFile pdfPanDigitalSignaturefile = PlatformFile(name: "/assets/images/congratulations.png", size: 20);

  var drawnDigitalSignatureImage = null;

  bool showDrawnDigitalSignatureImage = false;

  bool isPANImageFromCamera = false;
  bool isDigitalSignatureFromCamera = false;

  Future<Null> _pickImageForPan(ImageSource source) async {
    if(source == ImageSource.gallery){
      print("Lets PIck Image From Gallery");
      result = await FilePicker.platform.pickFiles(type: FileType.custom,
        allowedExtensions: ['pdf','png','jpg','jpeg'],);
      if(result != null) {
        ///FILE SIZE
        File theNewPickedFile = File(result!.files.first.path.toString());
        int sizeInBytes = theNewPickedFile.lengthSync();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        print("Your File Size is : "+sizeInMb.toString());
        if(sizeInMb > 2){
          // This file is Longer the
          print("Your file is greater than 2MB");
          ///
          Navigator.pop(context);
          Flushbar(
            flushbarPosition: FlushbarPosition.BOTTOM,
            icon: Icon(Icons.error,color: Colors.red,),
            title:  "Error",
            duration:  Duration(seconds: 3),
            messageText: Text(
              "File Size Cannot Be Greater than 2MB",
              style: TextStyle(color: Colors.red, letterSpacing: 0.5),
            ),
          )..show(context);
          return;
        }

        pdfPanImagefile = result!.files.first;
        print(pdfPanImagefile.name);
        print(pdfPanImagefile.bytes);
        print(pdfPanImagefile.size);
        print(pdfPanImagefile.extension);
        print(pdfPanImagefile.path);

        if(pdfPanImagefile.extension != 'pdf'){
          imageFilePan = File(pdfPanImagefile.path.toString());
          if (imageFilePan != null) {
            setState(() {
              isPANImageFromCamera  = false;
              Navigator.pop(context);
              _cropImageForPan();
            });
          }
        }
        else{
          //No Cropping for PDF Directly View it
          Navigator.pop(context);
          isPANImageFromCamera = false;
          tempPanUploaded = true;
          setState(() {
          });
        }


      } else {
        // User canceled the picker
      }
    }
    else{
      ///Chosen Camera to Upload File
      final pickedImage = await ImagePicker().pickImage(source: source);
      imageFilePan = pickedImage != null ? File(pickedImage.path) : null;
      if (imageFilePan != null) {
        setState(() {
          isPANImageFromCamera = true;
          Navigator.pop(context);
          _cropImageForPan();
        });
      }
    }
  }

  Future<Null> _pickImageForDigitalSignature(ImageSource source) async {
    if(source == ImageSource.gallery){
      print("Lets PIck Image From Gallery");
      result = await FilePicker.platform.pickFiles(type: FileType.custom,
        allowedExtensions: ['pdf','png','jpg','jpeg'],);
      if(result != null) {
        ///FILE SIZE
        File theNewPickedFile = File(result!.files.first.path.toString());
        int sizeInBytes = theNewPickedFile.lengthSync();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        print("Your File Size is : "+sizeInMb.toString());
        if(sizeInMb > 2){
          // This file is Longer the
          print("Your file is greater than 2MB");
          Navigator.pop(context);
          Flushbar(
            flushbarPosition: FlushbarPosition.BOTTOM,
            icon: Icon(Icons.error,color: Colors.red,),
            title:  "Error",
            duration:  Duration(seconds: 3),
            messageText: Text(
              "File Size Cannot Be Greater than 2MB",
              style: TextStyle(color: Colors.red, letterSpacing: 0.5),
            ),
          )..show(context);
          return;
        }
        pdfPanDigitalSignaturefile = result!.files.first;
        print(pdfPanDigitalSignaturefile.name);
        print(pdfPanDigitalSignaturefile.bytes);
        print(pdfPanDigitalSignaturefile.size);
        print(pdfPanDigitalSignaturefile.extension);
        print(pdfPanDigitalSignaturefile.path);

        if(pdfPanDigitalSignaturefile.extension != 'pdf'){
          imageFileDigitalSignature = File(pdfPanDigitalSignaturefile.path.toString());
          if (imageFileDigitalSignature != null) {
            setState(() {
              Navigator.pop(context);
              _cropImageForDigitalSignature();
            });
          }
        }
        else{
          //No Cropping for PDF Directly View it
          isDigitalSignatureFromCamera = false;
          showDrawnDigitalSignatureImage = false;
          Navigator.pop(context);
          tempDigitalPadUploaded = true;
          setState(() {
          });
        }


      } else {
        // User canceled the picker
      }
    }
    else{
      ///Chosen Camera to Upload File
      final pickedImage = await ImagePicker().pickImage(source: source);
      imageFileDigitalSignature = pickedImage != null ? File(pickedImage.path) : null;
      if (imageFileDigitalSignature != null) {
        setState(() {
          isDigitalSignatureFromCamera = true;
          showDrawnDigitalSignatureImage = false;
          Navigator.pop(context);
          _cropImageForDigitalSignature();
        });
      }
    }

  }

  @override
  void deactivate() {
    super.deactivate();
  }

  Color primaryColorOfApp = Color(0xff6A4EEE);

  final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    //manageSteps();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _onWillPop() {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: _onWillPop ,child:Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: WidgetHelper().NuniyoAppBar(),
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetHelper().DetailsTitle('Upload Documents'),
                Text("Copy of PAN",style: GoogleFonts.openSans(
                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 22,fontWeight: FontWeight.bold),
                ),),
                SizedBox(height: 20,),
                Text("Upload a signed copy of your PAN Card.",style: GoogleFonts.openSans(
                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16),
                ),),
                Text("Format PNG,JPG,PDF",style: GoogleFonts.openSans(
                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 12),
                ),),
                SizedBox(height: 20,),
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 65,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: () {
                      showPanCardImageUploadOptionsDialog();
                    },
                    color: primaryColorOfApp,
                    child: Text(
                        "Upload",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                    ),
                  ),
                ),
                ///Small View Container
                Visibility(visible: showPanCardImageBox,child: SizedBox(height: 20,)),
                Visibility(
                  visible: showPanCardImageBox,
                  child: Center(
                    child:populatePanCardImageBox(),
                  ),
                ),
                SizedBox(height: 30.0,),
                Visibility(
                  visible: tempPanUploaded,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed:() async {
                        if (imageFilePan != null) {
                          //Uploading File to Database
                          isPanOCRVerified = await ApiRepo().PanOCRValidation(imageFilePan!.path,imageFilePan);
                        }
                      }, icon: Icon(Icons.check_circle,size: 36.0,color: Colors.green,)),
                      SizedBox(width: 30,),
                      IconButton(onPressed:(){ showPanCardImageBox = !showPanCardImageBox;setState(() {

                      });}, icon: Icon(Icons.remove_red_eye_outlined,size: 36.0,color: primaryColorOfApp,)),
                      SizedBox(width: 30,),
                      IconButton(onPressed:(){
                        imageFilePan = null;
                        tempPanUploaded = false;
                        setState(() {

                        });
                        showPanCardImageBox = false;
                      }, icon: Icon(Icons.delete,size: 36.0,color: Colors.red,)),
                    ],
                  ),),
                SizedBox(height: 30.0,),
                Divider(thickness: 2.0,),
                Text("Signature",style: GoogleFonts.openSans(
                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 22,fontWeight: FontWeight.bold),
                ),),
                SizedBox(height: 20,),
                Text("Please sign on a blank paper with a pen & upload a photo of the same.",style: GoogleFonts.openSans(
                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16),
                ),),
                SizedBox(height: 10,),
                Text("You can also sign on the digital pad.",style: GoogleFonts.openSans(
                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16),
                ),),
                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      color: Colors.transparent,
                      height: 60,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {
                          showDigitalPadDialog();
                        },
                        color: primaryColorOfApp,
                        child: Text(
                            "Digital Pad",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      height: 60,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {
                          showDigitalSignatureImageUploadOptionsDialog();
                        },
                        color: primaryColorOfApp,
                        child: Text(
                            "Upload Image",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(visible: showDigitalPadBox,child: SizedBox(height: 20,)),
                Visibility(
                  visible: showDigitalPadBox,
                  child: Center(child:populateDigitalPadImageBox(),),
                ),
                SizedBox(height: 30.0,),
                Visibility(
                  visible: tempDigitalPadUploaded,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed:(){}, icon: Icon(Icons.check_circle,size: 36.0,color: Colors.green,)),
                      SizedBox(width: 30,),
                      IconButton(onPressed:(){
                        showDigitalPadBox = !showDigitalPadBox;
                        setState(() {});
                      }, icon: Icon(Icons.remove_red_eye_outlined,size: 36.0,color: primaryColorOfApp,)),
                      SizedBox(width: 30,),
                      IconButton(onPressed:(){
                        tempDigitalPadUploaded = false;
                        showDigitalPadBox = false;
                        setState(() {});
                      }, icon: Icon(Icons.delete,size: 36.0,color: Colors.red,)),
                    ],
                  ),),
                SizedBox(height: 30.0,),
                SizedBox(height: 10,),
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 75,
                  child: FlatButton(
                    disabledTextColor: Colors.blue,
                    disabledColor: Color(0xffD2D0E1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed:(tempPanUploaded&&tempDigitalPadUploaded)?() async {
                        if(imageFilePan!=null){
                          //CALL APIS TO UPLOAD
                          print("Calling Upload Image API");
                          ///Upload APi
                          await LocalApiRepo().DocumentUploadPAN(imageFilePan);
                          await LocalApiRepo().DocumentUploadDigitalSignature(imageFileDigitalSignature);

                          ///Update Stage ID Here
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          await LocalApiRepo().UpdateStage_Id();
                          String ThisStepId = prefs.getString(STAGE_KEY);
                          print("YOU LEFT ON THIS PAGE LAST TIME"+ThisStepId);
                          Navigator.pushNamed(context,ThisStepId);
                          ///Upload APi
                        }
                        else if(imageFileDigitalSignature!=null){

                        }
                        else if(pdfPanImagefile!=null){

                        }
                        else if(pdfPanDigitalSignaturefile!=null){

                        }
                        else{
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.black,
                            content: Text(
                              "Please Upload Proper Documents!",
                              style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
                            ),
                          ));
                        }
                    }:null,
                    color: primaryColorOfApp,
                    child: Text(
                        "Proceed",
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),)
    );
  }

  //Digital Pad Methods
  void showDigitalPadDialog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 420,
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22.0,10.0,0.0,10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Material(
                        color: Colors.white,
                        child: Text(
                            "Upload Signature",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 20,fontWeight: FontWeight.bold),)
                        ),),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Container(
                          child: SfSignaturePad(
                              key: signatureGlobalKey,
                              backgroundColor: Colors.white,
                              strokeColor: Colors.black,
                              minimumStrokeWidth: 1.0,
                              maximumStrokeWidth: 4.0),
                          decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)))),
                  SizedBox(height: 10),
                  Row(children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      height: 60,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {
                          _handleSaveButtonPressed();
                          setState(() {

                          });
                          Navigator.pop(context);
                        },
                        color: primaryColorOfApp,
                        child: Text(
                            "Upload",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.transparent,
                      height: 60,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {
                          _handleClearButtonPressed();
                        },
                        color: primaryColorOfApp,
                        child: Text(
                            "Clear",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                        ),
                      ),
                    ),
                  ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center),
            margin: EdgeInsets.only(bottom: 20, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  void _handleClearButtonPressed() {
    signatureGlobalKey.currentState!.clear();
  }

  void _handleSaveButtonPressed() async {
    final data = await signatureGlobalKey.currentState!.toImage(pixelRatio: 3.0);
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    drawnDigitalSignatureImage = bytes;
    showDrawnDigitalSignatureImage = true;
    print(data);
    tempDigitalPadUploaded  = true;
    setState(() {
      drawnDigitalSignatureImage = bytes;
    });
  }


  ///PAN CARD METHODS
  void showPanCardImageUploadOptionsDialog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 250,
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22.0,10.0,0.0,10.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Material(
                        color: Colors.white,
                        child: Text(
                            "Choose An Option!",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 20,fontWeight: FontWeight.bold),)
                        ),),
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width/1.5,
                        color: Colors.transparent,
                        height: 60,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPressed: () {
                            _pickImageForPan(ImageSource.camera);
                          },
                          color: primaryColorOfApp,
                          child: Text(
                              "Open Camera",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width/1.5,
                        color: Colors.transparent,
                        height: 60,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPressed: () {
                            _pickImageForPan(ImageSource.gallery);
                          },
                          color: primaryColorOfApp,
                          child: Text(
                              "Upload From Gallery",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                          ),
                        ),
                      ),
                    ),
                  ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center),
            margin: EdgeInsets.only(bottom: 20, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  void showDigitalSignatureImageUploadOptionsDialog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 250,
            child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22.0,10.0,0.0,10.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Material(
                        color: Colors.white,
                        child: Text(
                            "Choose An Option!",
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 20,fontWeight: FontWeight.bold),)
                        ),),
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width/1.5,
                        color: Colors.transparent,
                        height: 60,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPressed: () {
                            _pickImageForDigitalSignature(ImageSource.camera);
                          },
                          color: primaryColorOfApp,
                          child: Text(
                              "Open Camera",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width/1.5,
                        color: Colors.transparent,
                        height: 60,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          onPressed: () {
                            _pickImageForDigitalSignature(ImageSource.gallery);
                          },
                          color: primaryColorOfApp,
                          child: Text(
                              "Upload From Gallery",
                              style: GoogleFonts.openSans(
                                textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                          ),
                        ),
                      ),
                    ),
                  ], mainAxisAlignment: MainAxisAlignment.spaceEvenly)
                ],
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center),
            margin: EdgeInsets.only(bottom: 20, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  populatePanCardImageBox() {
    if (imageFilePan != null) {
      //Uploading File to Database
      //PanOCRValidation(_imageFilePanListPan![0].path,_imageFilePanListPan![0]);
      return Container(
        height: MediaQuery.of(context).size.height/6,
        width: MediaQuery.of(context).size.width/3,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(0))
        ),
        child: pdfPanImagefile.extension == 'pdf' ? SfPdfViewer.file(File(pdfPanImagefile.path.toString())) : Image.file(File(imageFilePan!.path)),
      );

    }  else {
      return Container(
        height: MediaQuery.of(context).size.height/6,
        width: MediaQuery.of(context).size.width/3,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(0))
        ),
        child: null,
      );
    }
  }

  populateDigitalPadImageBox() {
    if (imageFileDigitalSignature != null) {
      //Uploading File to Database
      //PanOCRValidation(_imageFilePanListPan![0].path,_imageFilePanListPan![0]);
      return Container(
        height: MediaQuery.of(context).size.height/6,
        width: MediaQuery.of(context).size.width/3,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(0))
        ),
        child: showDrawnDigitalSignatureImage ? Image.memory(drawnDigitalSignatureImage!.buffer.asUint8List()):pdfPanDigitalSignaturefile.extension == 'pdf' ? SfPdfViewer.file(File(pdfPanDigitalSignaturefile.path.toString())) : Image.file(File(imageFileDigitalSignature!.path)),
      );
    }  else {
      return Container(
        height: MediaQuery.of(context).size.height/6,
        width: MediaQuery.of(context).size.width/3,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.all(Radius.circular(0))
        ),
        child: null,
      );
    }
  }


  Future<Null> _cropImageForPan() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFilePan!.path,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: primaryColorOfApp,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      ///FILE SIZE
      int sizeInBytes = croppedFile.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      print("Your File Size is : "+sizeInMb.toString());
      if(sizeInMb > 2){
        // This file is Longer the
        print("Your file is greater than 2MB");
        //ISSUE : - That's why removed Navigator.pop(context);
        Flushbar(
          flushbarPosition: FlushbarPosition.BOTTOM,
          icon: Icon(Icons.error,color: Colors.red,),
          title:  "Error",
          duration:  Duration(seconds: 3),
          messageText: Text(
            "File Size Cannot Be Greater than 2MB",
            style: TextStyle(color: Colors.red, letterSpacing: 0.5),
          ),
        )..show(context);
        return;
      }
      imageFilePan = croppedFile;
      tempPanUploaded = true;
      setState(() {

      });
    }
  }

  Future<Null> _cropImageForDigitalSignature() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFileDigitalSignature!.path,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: primaryColorOfApp,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {

      ///FILE SIZE
      int sizeInBytes = croppedFile.lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);
      print("Your File Size is : "+sizeInMb.toString());
      if(sizeInMb > 2){
        // This file is Longer the
        print("Your file is greater than 2MB");
        //Navigator.pop(context);
        Flushbar(
          flushbarPosition: FlushbarPosition.BOTTOM,
          icon: Icon(Icons.error,color: Colors.red,),
          title:  "Error",
          duration:  Duration(seconds: 3),
          messageText: Text(
            "File Size Cannot Be Greater than 2MB",
            style: TextStyle(color: Colors.red, letterSpacing: 0.5),
          ),
        )..show(context);
        return;
      }
      /////
      imageFileDigitalSignature = croppedFile;
      showDrawnDigitalSignatureImage = false;
      tempDigitalPadUploaded  = true;
      setState(() {
      });
    }
  }

}
