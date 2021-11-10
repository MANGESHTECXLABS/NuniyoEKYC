///Congrats Screen

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nuniyoekyc/ApiRepository/api_repository.dart';
import 'package:nuniyoekyc/utils/localstorage.dart';
import 'package:nuniyoekyc/widgets/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../globals.dart';
import '../nuniyo_custom_icons.dart';
import 'nuniyo_main_application_webview.dart';

class CongratsScreen extends StatefulWidget {
  const CongratsScreen({Key? key}) : super(key: key);

  @override
  _CongratsScreenState createState() => _CongratsScreenState();
}

class _CongratsScreenState extends State<CongratsScreen> {

  Color primaryColorOfApp = Color(0xff6A4EEE);
  String emailAddress = "youremailid@do.com";
  String phoneNumber = "8779559898";

  Image? congratsImage;

  File? pdfFile;

  bool viewForm = false;

  Uint8List? pdfInBytesFormat;

  @override
  void initState() {
    super.initState();
    congratsImage = Image.asset("assets/images/congratulations.png");
    //manageSteps();
    firstThingsFirst();
    fetchInitialData();
  }


  fetchInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailAddress = await prefs.getString('EMAIL_ID');
    phoneNumber = await prefs.getString(MOBILE_NUMBER_KEY);
    //await ApiRepository().Generate_Lead_Pdf();

    //pdfFile = await ApiRepository().Digio_eSign_Document_Download();
    //await ApiRepository().Get_eSign_Document_Details();
    await ApiRepository().Digio_eSign_Document_Download();
    pdfInBytesFormat = await ApiRepository().Download_Application_Pdf();

    //Lets make a file and show it inside it
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/example.pdf';
    final File file = File(path);

    pdfFile = await file.writeAsBytes(pdfInBytesFormat!);
    setState(() {
    });



    setState(() {
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(congratsImage!.image, context);
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      floatingActionButton: viewForm?new FloatingActionButton(
          elevation: 0.0,
          child: new Icon(Icons.arrow_back_sharp),
          backgroundColor: primaryColorOfApp,
          onPressed: (){
            viewForm=false;
            setState(() {});
          }
      ):null,
      resizeToAvoidBottomInset: true,
      appBar: WidgetHelper().NuniyoAppBar(),
      body: !viewForm?SingleChildScrollView(
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WidgetHelper().DetailsTitle('Congratulations !'),
                Center(child: congratsImage),
                SizedBox(height: 20,),
                Text("Your application is complete . After verification , you will recieve your login credentials on your e-mail.",textAlign:TextAlign.center,style: GoogleFonts.openSans(
                  textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16),
                ),),
                SizedBox(height: 20,),
                Container(
                  height: 250.0,
                  width: MediaQuery.of(context).size.width,
                  decoration: new BoxDecoration(
                    boxShadow: [ //background color of box
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5.0, // soften the shadow
                        spreadRadius: 2.0, //extend the shadow
                      )
                    ],
                  ),
                  child: Container(
                    height: 80,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10.0,30.0,0.0,0.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Username  :",textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                                    ),
                                    Text(
                                        "Email Id  :",textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                                    ),
                                    Text(
                                        "Margin  :",textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "$phoneNumber",textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16),)
                                    ),
                                    Text(
                                        "$emailAddress",textAlign: TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(color: Colors.black, letterSpacing: .5),)
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            "Rs.0.00",textAlign: TextAlign.center,
                                            style: GoogleFonts.openSans(
                                              textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 16),)
                                        ),
                                        SizedBox(width: 10,),
                                        Text(
                                            "Add Funds",textAlign: TextAlign.center,
                                            style: GoogleFonts.openSans(
                                              textStyle: TextStyle(decoration: TextDecoration.underline,color: primaryColorOfApp, letterSpacing: .5,fontSize: 16),)
                                        ),

                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                            Container(
                              color: Colors.transparent,
                              height: 60,
                              width: MediaQuery.of(context).size.width,
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => MainApplication_WebView()),
                                  );
                                },
                                color: primaryColorOfApp,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "Make Your First Trade :",textAlign:TextAlign.center,
                                        style: GoogleFonts.openSans(
                                          textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                                    ),
                                    Icon(Icons.arrow_right,color: Colors.white,size: 40.0,),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.transparent,
                      height: 60,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {

                        },
                        color: primaryColorOfApp,
                        child: Text(
                            "Open F&O Account",textAlign: TextAlign.center,
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      color: Colors.transparent,
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {},
                        color: primaryColorOfApp,
                        child: Text(
                            "Open Commodity",textAlign:TextAlign.center,
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      color: Colors.transparent,
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {},
                        color: primaryColorOfApp,
                        child: Text(
                            "Add a Nominee",textAlign:TextAlign.center,
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      color: Colors.transparent,
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {
                          viewForm = !viewForm;
                          setState(() {
                          });
                        },
                        color: primaryColorOfApp,
                        child: Text(
                            "View Form",textAlign:TextAlign.center,
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      color: Colors.transparent,
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () async {
                          //First Save Mangal Keshav Document Here...In a Local Storage!

                          // the downloads folder path
                          Directory tempDir = await DownloadsPathProvider.downloadsDirectory;
                          String tempPath = tempDir.path;
                          var rng = new Random();
                          String newFileName="/mangalkeshav";
                          for (var i = 0; i < 10; i++) {
                            print(rng.nextInt(100));
                            newFileName+=rng.nextInt(100).toString();
                          }
                          newFileName = newFileName+".pdf";
                          var filePath = tempPath + newFileName;

                          //Lets make a file and show it inside it
                          final File file = File(filePath);

                          pdfFile = await file.writeAsBytes(pdfInBytesFormat!);


                          setState(() {
                          });




                          //Then Show SnackBar
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.black,
                          content: Row(
                            children: [
                              Icon(Icons.check_circle,color: Colors.green,),
                              TextButton(child:Text("Download Completed : Tap to Open",style: TextStyle(color: Colors.white, letterSpacing: 0.5),) ,onPressed: () async {
                                ///Open Downloaded Mangal Keshav PDF Here
                                ///Now to Open this File
                                final _result = await OpenFile.open(filePath);
                                print(_result.message);
                              },),
                            ],
                          )
                          ),
                          );
                        },
                        color: primaryColorOfApp,
                        child: Text(
                            "Download Form",textAlign:TextAlign.center,
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(color: Colors.white, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Visibility(visible: viewForm,child:Container(
                      height: MediaQuery.of(context).size.height/6,
                      width: MediaQuery.of(context).size.width/3,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(0))
                      ),
                      child:SfPdfViewer.file(pdfFile!),
                    )),
                    SizedBox(height: 20,),
                    Container(
                      height: 80,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: primaryColorOfApp),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        onPressed: () {},
                        child:
                        Row(
                          children: [
                            Icon(NuniyoCustomIcons.mobile_number_black,size: 30.0,color: primaryColorOfApp),
                            Flexible(
                              child: Text(
                                  "Get an App Download Link On Mobile",textAlign:TextAlign.center,
                                  style: GoogleFonts.openSans(
                                    textStyle: TextStyle(color: primaryColorOfApp, letterSpacing: .5,fontSize: 16,fontWeight: FontWeight.bold),)
                              ),
                            ),
                          ],
                        ),

                      ),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ],
            ),
          ),
        ),
      ):SfPdfViewer.file(pdfFile!),
    ), onWillPop: _onWillPop);
  }

  Future<bool> _onWillPop() {
    return Future.value(false);
  }

  Future<void> firstThingsFirst() async {
    //Updating Stage ID Now because we don't got time on Android Native to update it
    await ApiRepository().UpdateStage_Id();
  }
}
