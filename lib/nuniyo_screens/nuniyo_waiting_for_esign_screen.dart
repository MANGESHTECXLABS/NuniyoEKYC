import 'package:flutter/material.dart';
import 'package:nuniyoekyc/ApiRepository/api_repository.dart';
import 'package:nuniyoekyc/widgets/widgets.dart';
class WaitingScreenForESign extends StatefulWidget {
  const WaitingScreenForESign({Key? key}) : super(key: key);

  @override
  _WaitingScreenForESignState createState() => _WaitingScreenForESignState();
}

class _WaitingScreenForESignState extends State<WaitingScreenForESign> {
  Future<bool> _onWillPop() {
    return Future.value(false);
  }

  @override
  void initState() {
    CheckForEsignResponse();
  }

  CheckForEsignResponse() async {
    bool validAadharUsedForEsign = await ApiRepository().Get_eSign_Document_Details();
    if(validAadharUsedForEsign){
      Navigator.pushReplacementNamed(context, "UCC");
    }
    else{
      Navigator.pushReplacementNamed(context, "ESign");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: WidgetHelper().NuniyoAppBar(),
            body: Center(
              child: Container(
                child: Text("Please Wait...."),
              ),
            )
        ));
  }
}
