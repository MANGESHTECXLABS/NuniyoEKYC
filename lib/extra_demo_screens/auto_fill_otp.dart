import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_autofill/otp_autofill.dart';

class AutoOTPFillScreen extends StatefulWidget {
  const AutoOTPFillScreen({Key? key}) : super(key: key);

  @override
  _AutoOTPFillScreenState createState() => _AutoOTPFillScreenState();
}

class _AutoOTPFillScreenState extends State<AutoOTPFillScreen> {

  late OTPTextEditController controller;

  @override
  void initState() {
    super.initState();
    OTPInteractor.getAppSignature()
    //ignore: avoid_print
        .then((value) => print('signature - $value'));
    controller = OTPTextEditController(
      codeLength: 6,
      //ignore: avoid_print
      onCodeReceive: (code) => print('Your Application receive code - $code'),
    )..startListenUserConsent(
          (code) {
        final exp = RegExp(r'(\d{6})');
        return exp.stringMatch(code ?? '') ?? '';
      },
      strategies: [
        //SampleStrategy(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              controller: controller,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> dispose() async {
    await controller.stopListen();
    super.dispose();
  }
}
