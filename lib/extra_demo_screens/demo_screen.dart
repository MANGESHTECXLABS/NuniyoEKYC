import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nuniyoekyc/widgets/widgets.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({Key? key}) : super(key: key);

  @override
  _DemoScreenState createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.ac_unit,color: Colors.black,),
        title: Text('Nuniyo',style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontWeight: FontWeight.bold)),),
        backgroundColor: Color(0xffF0ECFF),
        elevation: 0,
      ),

      body: Center(child: Column(
        children: [
          SizedBox(height: 20.0,),
          Text('API & MOBILE UI DEMO',textAlign: TextAlign.center,style: (TextStyle(fontSize: 40)),),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WidgetHelper().NuniyoUINavigatorBtn(context,'/mobilevalidationscreen',"Mobile Authentication"),
              WidgetHelper().NuniyoUINavigatorBtn(context,'/bankemailpanvalidationscreen',"Sign Up Page 1"),
            ],
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WidgetHelper().NuniyoUINavigatorBtn(context, '/personaldetailsscreen',"Personal Details"),
              WidgetHelper().NuniyoUINavigatorBtn(context, '/rayzorpaydemoscreen',"Rayzor Pay"),
            ],
          ),


          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WidgetHelper().NuniyoUINavigatorBtn(context, '/optionsscreen',"Options Demo"),
              WidgetHelper().NuniyoUINavigatorBtn(context, '/aadharkycscreen',"Aadhar KYC"),
            ],
          ),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WidgetHelper().NuniyoUINavigatorBtn(context, '/esignscreen',"ESign Page"),
              WidgetHelper().NuniyoUINavigatorBtn(context, '/uploaddocumentscreen',"OCR Demo"),
            ],
          ),

          WidgetHelper().NuniyoUINavigatorBtn(context, '/congratsscreen',"Congrats Demo"),
        ],
      )),
    );
  }
}
