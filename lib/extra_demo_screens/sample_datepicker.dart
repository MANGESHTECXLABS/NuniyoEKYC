import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class Daty extends StatefulWidget {
  @override
  _DatyState createState() => _DatyState();
}

class _DatyState extends State<Daty> {
  String? _selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MaterialButton(
          child: Container(
            child: _selectedDate == null
                ? Text('Select a date ')
                : Text(_selectedDate!),
          ),
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: Text('Select Date Of Birth'),
                      content: Container(
                        height: 400,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 400,
                              width: 400,
                              child: getDateRangePicker(),
                            ),
                          ],
                        ),
                      ));
                });
          },
        ),);
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    _selectedDate = DateFormat('dd-MM-yyyy').format(args.value);

    SchedulerBinding.instance!.addPostFrameCallback((duration) {
      setState(() {});
    });
  }

  Widget getDateRangePicker() {
    return SfDateRangePicker(
      view: DateRangePickerView.decade,
      showActionButtons: true,
      selectionMode: DateRangePickerSelectionMode.single,
      onSelectionChanged: selectionChanged,
      onCancel:(){Navigator.pop(context);} ,
      onSubmit: (Object p1){Navigator.pop(context);},

    );
  }
}