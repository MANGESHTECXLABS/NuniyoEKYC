import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/platform_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';


class BrowserView extends StatefulWidget {

  @override
  _BrowserViewState createState() => _BrowserViewState();
}

class _BrowserViewState extends State<BrowserView> {
  Completer<WebViewController> _controller = Completer<WebViewController>();
  final Set<String> _favorites = Set<String>();

  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid){
      WebView.platform = SurfaceAndroidWebView();

    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuniyo'),
        // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: WebView(

        initialUrl: 'https://accounts.digitallocker.gov.in/signin/oauth_partner/%252Foauth2%252F1%252Fauthorize%253Fresponse_type%253Dcode%2526client_id%253D140FF210%2526state%253D123%2526redirect_uri%253Dhttps%25253A%25252F%25252Fnuniyo.tech%25252F%2526orgid%253D005685%2526txn%253D6142ec01cf20bfd78e500611oauth21631775745%2526hashkey%253D64fbbfafa80c49a7f3cfef7e6c7dbca5d6b1a417c89930f394ae107a2f9bf22b%2526requst_pdf%253DY%2526signup%253Dsignup',
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}