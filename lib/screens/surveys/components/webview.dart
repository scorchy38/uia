import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SurveyWebView extends StatefulWidget {
  String url;
  SurveyWebView(this.url);
  @override
  SurveyWebViewState createState() => SurveyWebViewState();
}

class SurveyWebViewState extends State<SurveyWebView> {
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: WebView(

            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: widget.url,
          ),
        ),
      ),
    );
  }
}