import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nuniyoekyc/ApiRepository/api_repository.dart';
import 'package:nuniyoekyc/utils/localstorage.dart';
import 'package:nuniyoekyc/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../globals.dart';
import '../nuniyo_custom_icons.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({Key? key}) : super(key: key);

  @override
  _PersonalDetailsScreenState createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {

  Color primaryColorOfApp = Color(0xff6A4EEE);

  late FocusNode _fatherNameTextFieldFocusNode,_annualIncomeDropDownFocusNode,_motherNameTextFieldFocusNode,_occupationDropDownFocusNode,_maritialStatusDropDownFocusNode,_genderDropDownFocusNode,_tradingExperienceDropDownFocusNode,_politicallyExposedDropDownFocusNode,_educationDropDownFocusNode,_incomeDropDownFocusNode;

  String annualIncome = '1-5 Lac';
  String gender = 'Male';
  String maritialStatus = 'Single';
  String tradingExperience = 'Beginner';
  String politicallyExposed = 'No';
  String occupation = 'PRIVATE SECTOR';
  //String education = 'Graduate';

  TextEditingController fatherNameTextEditingController = TextEditingController();
  TextEditingController motherNameTextEditingController = TextEditingController();


  bool showFatherNameErrorText = false;
  bool showMotherNameErrorText = false;


  bool enableFatherNameTextField = true;
  bool enableMotherNameTextField = true;

  bool _value = false;

  bool nationality = true;

  bool showNationalityError = false;

  bool declaration = true;
  bool showDeclarationError = false;


  @override
  void initState() {
    super.initState();
    //manageSteps();
    prefillTexts();
    _fatherNameTextFieldFocusNode = FocusNode();
    _tradingExperienceDropDownFocusNode = FocusNode();
    _motherNameTextFieldFocusNode = FocusNode();
    _occupationDropDownFocusNode = FocusNode();
    _maritialStatusDropDownFocusNode = FocusNode();
    _annualIncomeDropDownFocusNode = FocusNode();
    _genderDropDownFocusNode = FocusNode();
    _politicallyExposedDropDownFocusNode = FocusNode();
    _educationDropDownFocusNode = FocusNode();
    _incomeDropDownFocusNode = FocusNode();
  }


  void _requestIncomeDropDownFocusNode(){
    setState(() {
      FocusScope.of(context).requestFocus(_incomeDropDownFocusNode);
    });
  }

  void _requestEducationDropDownFocusNode(){
    setState(() {
      FocusScope.of(context).requestFocus(_educationDropDownFocusNode);
    });
  }

  void _requestMaritialStatusDropDownFocusNode(){
    setState(() {
      FocusScope.of(context).requestFocus(_maritialStatusDropDownFocusNode);
    });
  }

  void _requestFatherNameTextFieldFocusNode(){
    setState(() {
      FocusScope.of(context).requestFocus(_fatherNameTextFieldFocusNode);
    });
  }

  void _requestMotherNameTextFieldFocusNode(){
    setState(() {
      FocusScope.of(context).requestFocus(_motherNameTextFieldFocusNode);
    });
  }

  void _requestTradingExperienceDropDownFocusNode(){
    setState(() {
      FocusScope.of(context).requestFocus(_tradingExperienceDropDownFocusNode);
    });
  }

  void _requestPoliticallyExposedDropDownFocusNode(){
    setState(() {
      FocusScope.of(context).requestFocus(_politicallyExposedDropDownFocusNode);
    });
  }

  void _requestOccupationDropDownFocusNode(){
    setState(() {
      FocusScope.of(context).requestFocus(_occupationDropDownFocusNode);
    });
  }

  void _requestGenderDropDownFocusNode(){
    setState(() {
      FocusScope.of(context).requestFocus(_genderDropDownFocusNode);
    });
  }

  @override
  void dispose() {
    _fatherNameTextFieldFocusNode.dispose();
    _motherNameTextFieldFocusNode.dispose();
    _occupationDropDownFocusNode.dispose();
    _maritialStatusDropDownFocusNode.dispose();
    _annualIncomeDropDownFocusNode.dispose();
    _genderDropDownFocusNode.dispose();
    _tradingExperienceDropDownFocusNode.dispose();
    _politicallyExposedDropDownFocusNode.dispose();
    _educationDropDownFocusNode.dispose();
    _incomeDropDownFocusNode.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() {
    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child:Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: WidgetHelper().NuniyoAppBar(),
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height:30.0),
                WidgetHelper().DetailsTitle('Personal Details'),
                //SizedBox(height: 20,),
                Flexible(
                    child: Container(
                      height: 80,
                      child: TextField(
                        //enabled:false,
                        onChanged: (_value){
                          if(_value.isNotEmpty){
                            showFatherNameErrorText = false;
                            print(_value);
                            setState(() {

                            });
                          }
                        },
                        enabled: enableFatherNameTextField,
                        cursorColor: primaryColorOfApp,
                        style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black, letterSpacing: .5,fontSize: 14,fontWeight: FontWeight.bold)),
                        focusNode: _fatherNameTextFieldFocusNode,
                        onTap: _requestFatherNameTextFieldFocusNode,
                        controller: fatherNameTextEditingController,
                        decoration: InputDecoration(
                          errorText: showFatherNameErrorText?"Father Name Cannot be Blank":null,
                            contentPadding: EdgeInsets.fromLTRB(25.0,40.0,0.0,40.0),
                            counter: Offstage(),
                            labelText: _fatherNameTextFieldFocusNode.hasFocus ? 'Father\'s Full Name' : 'Father\'s Full Name',
                            labelStyle: TextStyle(
                              color: _fatherNameTextFieldFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,
                            )
                        ),
                      ),
                    )
                ),
                SizedBox(height: 10,),
                Flexible(
                    child: Container(
                      height: 80,
                      child: TextField(
                        enabled: enableMotherNameTextField,
                        onChanged: (_value){
                          if(_value.isNotEmpty){
                            showMotherNameErrorText = false;
                            print(_value);
                            setState(() {

                            });
                          }
                        },
                        cursorColor: primaryColorOfApp,
                        style: GoogleFonts.openSans(textStyle: TextStyle(color: Colors.black, letterSpacing: 0.5,fontSize: 14,fontWeight: FontWeight.bold)),
                        focusNode: _motherNameTextFieldFocusNode,
                        controller: motherNameTextEditingController,
                        onTap: _requestMotherNameTextFieldFocusNode,
                        decoration: InputDecoration(
                            errorText: showMotherNameErrorText?"Mother Name Cannot Be Blank":null,
                            contentPadding: EdgeInsets.fromLTRB(25.0,40.0,0.0,40.0),
                            counter: Offstage(),
                            labelText: _motherNameTextFieldFocusNode.hasFocus ? 'Mother\'s Full Name' : 'Mother\'s Full Name',
                            labelStyle: GoogleFonts.openSans(textStyle:TextStyle(fontSize: 14,letterSpacing: 0.5,
                              color: _motherNameTextFieldFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,
                            ))
                        ),
                      ),
                    )
                ),
                SizedBox(height: 10,),
                Container(
                  height: 75.0,
                  child: InputDecorator(
                    decoration: InputDecoration(
                        labelText: _maritialStatusDropDownFocusNode.hasFocus ? 'Maritial Status' : 'Maritial Status',
                        labelStyle: GoogleFonts.openSans(textStyle:TextStyle(fontSize: 14,letterSpacing: 0.5,
                          color: _maritialStatusDropDownFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,
                        )),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    //isEmpty: _currentSelectedValue == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        icon: Icon(NuniyoCustomIcons.down_open,size: 24.0,color:  _maritialStatusDropDownFocusNode.hasFocus ?primaryColorOfApp : Colors.black,),
                        value: maritialStatus,
                        style: GoogleFonts.openSans(textStyle: TextStyle(color:  _maritialStatusDropDownFocusNode.hasFocus ?primaryColorOfApp : Colors.black, letterSpacing: .5,fontSize: 14,fontWeight: FontWeight.bold)),
                        underline: Container(
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            maritialStatus = newValue!;
                          });
                        },
                        onTap: _requestMaritialStatusDropDownFocusNode,
                        items: <String>['Single','Married','Divorced']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 75.0,
                  child: InputDecorator(
                    decoration: InputDecoration(
                        labelText: _genderDropDownFocusNode.hasFocus ? 'Gender' : 'Gender',
                        labelStyle: GoogleFonts.openSans(textStyle:TextStyle(fontSize: 14,letterSpacing: 0.5,
                          color: _genderDropDownFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,
                        )),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    //isEmpty: _currentSelectedValue == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        onTap: _requestGenderDropDownFocusNode,
                        icon: Icon(NuniyoCustomIcons.down_open,size: 24.0,color:  _genderDropDownFocusNode.hasFocus ?primaryColorOfApp : Colors.black,),
                        value: gender,
                        style: GoogleFonts.openSans(textStyle: TextStyle(color: _genderDropDownFocusNode.hasFocus ?primaryColorOfApp : Colors.black, letterSpacing: .5,fontSize: 14,fontWeight: FontWeight.bold)),
                        underline: Container(
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            gender = newValue!;
                          });
                        },
                        items: <String>['Male','Female','Others']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                WidgetHelper().DetailsTitle('Background'),
                Container(
                  height: 75.0,
                  child: InputDecorator(
                    decoration: InputDecoration(
                        labelText: _annualIncomeDropDownFocusNode.hasFocus ? 'Annual Income' : 'Annual Income',
                        labelStyle: GoogleFonts.openSans(textStyle:TextStyle(fontSize: 14,letterSpacing: 0.5,
                          color: _annualIncomeDropDownFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,
                        )),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    //isEmpty: _currentSelectedValue == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        onTap: _requestIncomeDropDownFocusNode,
                        icon: Icon(NuniyoCustomIcons.down_open,size: 24.0,color: _incomeDropDownFocusNode.hasFocus ?primaryColorOfApp : Colors.black,),
                        value: annualIncome,
                        style: GoogleFonts.openSans(textStyle: TextStyle(color: _incomeDropDownFocusNode.hasFocus ?primaryColorOfApp : Colors.black, letterSpacing: .5,fontSize: 14,fontWeight: FontWeight.bold)),
                        underline: Container(
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            annualIncome = newValue!;
                          });
                        },
                        items: <String>['1-5 Lac','5-10 Lac','10-25 Lac','>25 Lac' ,'25 Lac-1 Cr','> 1 Cr']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 75.0,
                  child: InputDecorator(
                    decoration: InputDecoration(
                        labelText: _occupationDropDownFocusNode.hasFocus ? 'Occupation' : 'Occupation',
                        labelStyle: GoogleFonts.openSans(textStyle:TextStyle(fontSize: 14,letterSpacing: 0.5,
                          color: _occupationDropDownFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,
                        )),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    //isEmpty: _currentSelectedValue == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        onTap: _requestOccupationDropDownFocusNode,
                        icon: Icon(NuniyoCustomIcons.down_open,size: 24.0,color: _occupationDropDownFocusNode.hasFocus ?primaryColorOfApp : Colors.black,),
                        value: occupation,
                        style: GoogleFonts.openSans(textStyle: TextStyle(color: _occupationDropDownFocusNode.hasFocus ?primaryColorOfApp : Colors.black, letterSpacing: .5,fontSize: 14,fontWeight: FontWeight.bold)),
                        underline: Container(
                          color: Colors.black,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            occupation = newValue!;
                          });
                        },
                        items: <String>['PRIVATE SECTOR','PUBLIC SECTOR','GOVERNMENT SECTOR']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 75.0,
                  child: InputDecorator(
                    decoration: InputDecoration(
                        labelText: _tradingExperienceDropDownFocusNode.hasFocus ? 'Trading Experience' : 'Trading Experience',
                        labelStyle: GoogleFonts.openSans(textStyle:TextStyle(fontSize: 14,letterSpacing: 0.5,
                          color: _tradingExperienceDropDownFocusNode.hasFocus ?primaryColorOfApp : Colors.grey,
                        )),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    //isEmpty: _currentSelectedValue == '',
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        icon: Icon(NuniyoCustomIcons.down_open,size: 24.0,color: _tradingExperienceDropDownFocusNode.hasFocus ?primaryColorOfApp : Colors.black,),
                        value: tradingExperience,
                        style: GoogleFonts.openSans(textStyle: TextStyle(color: _tradingExperienceDropDownFocusNode.hasFocus ?primaryColorOfApp : Colors.black, letterSpacing: .5,fontSize: 14,fontWeight: FontWeight.bold)),
                        underline: Container(
                          color: Colors.black,
                        ),
                        onTap: _requestTradingExperienceDropDownFocusNode,
                        onChanged: (String? newValue) {
                          setState(() {
                            tradingExperience = newValue!;
                          });
                        },
                        items: <String>['Beginner','Intermediate','Professional']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    SizedBox(
                      height: 24.0,
                      width: 24.0,
                      child: Padding(
                        padding: EdgeInsets.only(bottom:12,right: 10),
                        child:Checkbox(
                        value: this.nationality,
                        checkColor: Colors.white,
                        activeColor: primaryColorOfApp,
                        fillColor: showNationalityError?MaterialStateProperty.all(Colors.red):null,
                        onChanged: (value) {
                          setState(() {
                            this.nationality = value!;
                            if(nationality==true){
                              showNationalityError = false;
                            }
                            print(nationality);
                          });
                        },
                      ),)
                    ),
                    Expanded(child:Text("I was born in India, my nationality is Indian & my country of tax in India.",textAlign:TextAlign.left,style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12,color:Colors.black, letterSpacing: .5),),),)
                  ],
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    SizedBox(
                        height: 24.0,
                        width: 24.0,
                        child: Padding(
                          padding: EdgeInsets.only(bottom:12,right: 10),
                          child:Checkbox(
                            value: this.declaration,
                            checkColor: Colors.white,
                            activeColor: primaryColorOfApp,
                            fillColor: showDeclarationError?MaterialStateProperty.all(Colors.red):null,
                            onChanged: (value) {
                              setState(() {
                                this.declaration = value!;
                                if(declaration==true){
                                  showDeclarationError = false;
                                }
                                print(declaration);
                              });
                            },
                          ),)
                    ),
                    Expanded(child:Text("I have read and accepted the declaration and I am neither mentally challenged nor a politically exposed person.",textAlign:TextAlign.left,style: GoogleFonts.openSans(textStyle: TextStyle(fontSize: 12,color:Colors.black, letterSpacing: .5),),),)
                  ],
                ),
                SizedBox(height: 20,),
                Container(
                  color: Colors.transparent,
                  width: MediaQuery.of(context).size.width,
                  height: 75,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    onPressed: (declaration&&nationality)&&(motherNameTextEditingController.text!=""&&fatherNameTextEditingController.text!="")?() async {
                      await ApiRepository().PersonalDetailsLocal(fatherNameTextEditingController.text.trim(),motherNameTextEditingController.text.trim(),annualIncome,gender,maritialStatus,politicallyExposed,occupation,tradingExperience);
                      await ApiRepository().UpdateStage_Id();
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString("GENDER",gender);
                      String stage_id = prefs.getString(STAGE_KEY);
                      print("Let\'s go To");
                      print(stage_id);
                      Navigator.pushNamed(context, stage_id);
                    }:null,
                    disabledTextColor: Colors.blue,
                    disabledColor: Color(0xffD2D0E1),
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

  Future<void> manageSteps() async {
    ///SET STEP ID HERE
    String currentRouteName = 'Personal';
    await StoreLocal().StoreRouteNameToLocalStorage(currentRouteName);
    String routeName = await StoreLocal().getRouteNameFromLocalStorage();
    print("YOU ARE ON THIS STEP : "+routeName);
  }

  Future<void> prefillTexts() async {
    Map valueMap = await ApiRepository().GetPersonalDetails();
    if(valueMap.isNotEmpty){
      String father_Name = valueMap["res_Output"][0]["father_Name"];
      String mother_Name = valueMap["res_Output"][0]["mother_Name"];
      String income = valueMap["res_Output"][0]["income"];
      String gender = valueMap["res_Output"][0]["gender"];
      String marital_Status = valueMap["res_Output"][0]["marital_Status"];
      String occupation = valueMap["res_Output"][0]["occupation"];
      String trading_Experience = valueMap["res_Output"][0]["trading_Experience"];

      fatherNameTextEditingController.text = father_Name;
      motherNameTextEditingController.text = mother_Name;

      print(gender);
      if(gender=="M"||gender=="Male"){
        //Do Nothing
        this.gender = "Male";
      }
      else{
        this.gender = "Female";
      }



      //this.gender = gender;
      //this.occupation = occupation;
      //this.tradingExperience = trading_Experience;
      //this.maritialStatus = marital_Status;
      //this.annualIncome = income;

      setState(() {});
    }
    if(fatherNameTextEditingController.text.isEmpty || fatherNameTextEditingController.text ==""){
      showFatherNameErrorText  = true;
      print("Some Erorr");
      print(showFatherNameErrorText);
      enableFatherNameTextField = true;
    }
    else if(fatherNameTextEditingController.text.isNotEmpty){
      showFatherNameErrorText  = false;
      enableFatherNameTextField = false;
    }

    if(motherNameTextEditingController.text=="" || motherNameTextEditingController.text.isEmpty){
      showMotherNameErrorText  = true;
      enableMotherNameTextField = true;
    }
    else if(motherNameTextEditingController.text.isNotEmpty){
      showMotherNameErrorText  = true;
      enableMotherNameTextField = true;
    }
    setState(() {});
  }
}
