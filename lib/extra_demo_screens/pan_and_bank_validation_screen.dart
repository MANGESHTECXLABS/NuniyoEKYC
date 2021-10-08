import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:nuniyoekyc/ApiRepository/apirepository.dart';
import 'package:nuniyoekyc/widgets/widgets.dart';


bool isPanValidatedSuccessfully = false;
bool isBankValidatedSuccessfully = false;

class Task {
  String name;
  DateTime date;
  Task({required this.name, required this.date});
}


class PanAndBankValidation extends StatefulWidget {
  @override
  State createState() {
    return PanAndBankValidationState();
  }
}

class PanAndBankValidationState extends State<PanAndBankValidation> {

  ///User - Friendly Strings - only used for UI
  String bankFormDescriptionText = "TAP to Enter Your BANK DETAILS";
  String panFormDescriptionText= "TAP to Enter Your PAN DETAILS";
  List<Color> myGradientColor = <Color>[
    Color.fromARGB(255, 127, 0, 255),
    Color.fromARGB(255, 225, 0, 255)
  ];
  double panSubmittedHeight = 100.0;
  double bankSubmittedHeight = 100.0;
  ExpandableController _panExpandableController = ExpandableController(initialExpanded: true);
  ExpandableController _bankExpandableController = ExpandableController(initialExpanded: true);

  //Fetching User Data inside this Variables
  late Task task ;
  TextEditingController _fullNameTextEditingController = TextEditingController() ;
  TextEditingController _panNumberTextEditingController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  TextEditingController _ifscCodeTextEditingController = TextEditingController();
  TextEditingController _bankTextEditingController = TextEditingController();

  bool isValidIFSC = true;

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime(1920, 1),
        firstDate: DateTime(1920, 1),
        lastDate: DateTime(2002));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        var date =
            "${picked.toLocal().day}-${picked.toLocal().month}-${picked.toLocal().year}";
        _dateController.text = date;
      });
  }

  //API Header
  var headers = {
    'Authorization': 'Basic QUlZM0gxWFM1QVBUMkVNRkU1NFVXWjU2SVE4RlBLRlA6R083NUZXMllBWjZLUU0zRjFaU0dRVlVRQ1pQWEQ2T0Y=',
    'Content-Type': 'application/json'
  };

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
      body: ExpandableTheme(
        data: const ExpandableThemeData(
          iconColor: Colors.blue,
          useInkWell: true,
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            ExpandableNotifier(
              controller: _panExpandableController,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: panSubmittedHeight,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                                gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: myGradientColor)
                            ),
                          ),
                        ),
                        ScrollOnExpand(
                          scrollOnExpand: true,
                          scrollOnCollapse: false,
                          child: ExpandablePanel(
                            theme: const ExpandableThemeData(
                              headerAlignment: ExpandablePanelHeaderAlignment.center,
                              tapBodyToCollapse: true,
                            ),
                            header: Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  "PAN VALIDATION",
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),
                                )),
                            collapsed: Text(
                              panFormDescriptionText,
                              softWrap: true,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            expanded:PanForm(),
                            builder: (_, collapsed, expanded) {
                              return Padding(
                                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                child: Expandable(
                                  collapsed: collapsed,
                                  expanded: expanded,
                                  theme: const ExpandableThemeData(crossFadePoint: 0),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            Visibility(
                visible: isPanValidatedSuccessfully,
                child: ExpandableNotifier(
                    controller: _bankExpandableController,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: bankSubmittedHeight,
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    gradient: LinearGradient(
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                        colors: myGradientColor
                                    )
                                ),
                              ),
                            ),
                            ScrollOnExpand(
                              scrollOnExpand: true,
                              scrollOnCollapse: false,
                              child: ExpandablePanel(
                                theme: const ExpandableThemeData(
                                  headerAlignment: ExpandablePanelHeaderAlignment.center,
                                  tapBodyToCollapse: true,
                                ),
                                header: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text(
                                      "BANK VALIDATION",
                                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),
                                    )),
                                collapsed: Text(
                                  bankFormDescriptionText,
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                expanded:BankForm(),
                                builder: (_, collapsed, expanded) {
                                  return Padding(
                                    padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                    child: Expandable(
                                      collapsed: collapsed,
                                      expanded: expanded,
                                      theme: const ExpandableThemeData(crossFadePoint: 0),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
            ),
            WidgetHelper().GradientButton(context,(){Navigator.pushNamed(context,'/ocrvalidation');},'Next')
          ],
        ),
      ),
    );
  }



  Widget PanForm(){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _fullNameTextEditingController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter Your Full Name',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => _selectDate(context),
            child: AbsorbPointer(
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'DD/MM/YYYY',
                ),
                controller: _dateController,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _panNumberTextEditingController,
            onChanged: (panNumber) async {
              if(panNumber.length==10 && _fullNameTextEditingController.text!="" && _dateController.text!=""){
                print("Full Name :"+_fullNameTextEditingController.text+"Date Time :"+_dateController.text+"Pan Number :"+_panNumberTextEditingController.text);
                isPanValidatedSuccessfully = await ApiRepo().fetchIsPanValid(_fullNameTextEditingController.text,_dateController.text,_panNumberTextEditingController.text);
                if(isPanValidatedSuccessfully){
                  _panExpandableController.expanded=false;
                  panFormDescriptionText = "PAN Verified Successfully!";
                  panSubmittedHeight = 10.0;
                  isPanValidatedSuccessfully = true;
                  setState(() {

                  });
                }
              }
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'e.g HCAPKLLL',
            ),
          ),
        ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: RaisedButton(
        onPressed: (){setState(() {
          _panExpandableController.expanded = false;
          isPanValidatedSuccessfully = true;
          panFormDescriptionText = "PAN Verified Successfully!";
          panSubmittedHeight = 10.0;
        });},
        textColor: Colors.white,
        padding: const EdgeInsets.all(0.0),
          child: Container(
          width: 300,
          decoration: BoxDecoration(
            gradient: new LinearGradient(
              colors: [
                Color.fromARGB(255, 127, 0, 255),
                Color.fromARGB(255, 225, 0, 255)
              ],
            )
          ),
          padding: const EdgeInsets.all(10.0),
          child: Text("VALIDATE PAN", textAlign: TextAlign.center,),
          ),
        ),
      ),
    ),
      ],
    );
  }


  Widget BankForm(){
    return Column(
      children: [
        TextField(
          controller: _bankTextEditingController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter BANK A/C NUMBER',
          ),
        ),
        Row(
          children: [
            Flexible(
              child: TextField(

                controller: _ifscCodeTextEditingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'IFSC CODE',
                  suffixIcon: Icon(Icons.check_circle,color: Colors.black12,size: 20.0,),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(25),
              child: FlatButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('SEARCH', style: TextStyle(fontSize: 20.0),),
                ),
                color: Colors.yellow,
                textColor: Colors.black,
                onPressed: () {},
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security,color: Colors.blue,),
                  Text("Your Financial Information is Secure With In Us",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: RaisedButton(
                    onPressed: () async {
                      isBankValidatedSuccessfully = await ApiRepo().fetchIsBankValid(_bankTextEditingController.text.trim(), _ifscCodeTextEditingController.text.trim());
                      if(isBankValidatedSuccessfully){
                        _bankExpandableController.expanded=false;
                        isBankValidatedSuccessfully = true;
                        bankFormDescriptionText = "BANK Verified Successfully!";
                        bankSubmittedHeight = 10.0;
                        setState(() {});
                      }
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    child: Container(
                      width: 300,
                      decoration: BoxDecoration(
                          gradient: new LinearGradient(
                            colors: [
                              Color.fromARGB(255, 127, 0, 255),
                              Color.fromARGB(255, 225, 0, 255)
                            ],
                          )
                      ),
                      padding: const EdgeInsets.all(10.0),
                      child: Text("PROCEED", textAlign: TextAlign.center,),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
