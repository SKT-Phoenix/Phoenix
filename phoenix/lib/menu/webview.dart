import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phoenix/baner.dart';
// import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

int progress_data = 0;
bool progress_flag = false;

class IssueWebView extends StatefulWidget {
  const IssueWebView({Key? key, this.cookieManager}) : super(key: key);

  final CookieManager? cookieManager;

  @override
  State<IssueWebView> createState() => _IssueWebViewState();
}

class _IssueWebViewState extends State<IssueWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          '이슈닷',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: <Widget>[
          IssueWebMenu(_controller.future, widget.cookieManager),
        ],
      ),
      body: WebView(
        initialUrl: Get.arguments,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        onProgress: (int progress) {
          progress_data = progress;
          if (progress_flag == false) {
            _fetchData(context);
            progress_flag = true;
          }
          if (progress_flag == true && progress == 100) {
            progress_flag = false;
            Get.back();
          }
          print('WebView is loading (progress : $progress%)');
        },
        javascriptChannels: <JavascriptChannel>{
          _toasterJavascriptChannel(context),
        },
        navigationDelegate: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            print('blocking navigation to $request}');
            return NavigationDecision.prevent;
          }
          print('allowing navigation to $request');
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) {
          print('Page started loading: $url');
        },
        onPageFinished: (String url) {
          print('Page finished loading: $url');
        },
        gestureNavigationEnabled: true,
        backgroundColor: const Color(0x00000000),
      ),
    );
  }

  void _fetchData(BuildContext context) async {
    // show the loading dialog

    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text("Loading...")
                ],
              ),
            ),
          );
        });

    // Your asynchronous computation here (fetching data from an API, processing files, inserting something to the database, etc)
    // await Future.delayed(const Duration(milliseconds: 100));
    // await (progress_data == 100)
    // ? Navigator.of(context).pop()
    // : Future.delayed(const Duration(seconds: 10));

    // Close the dialog programmatically
    // Navigator.of(context).pop();
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }
}

enum MenuOptions { showUserAgent, doPostRequest }

class IssueWebMenu extends StatelessWidget {
  IssueWebMenu(this.controller, CookieManager? cookieManager, {Key? key})
      : cookieManager = cookieManager ?? CookieManager(),
        super(key: key);

  final Future<WebViewController> controller;
  late final CookieManager cookieManager;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: controller,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        return PopupMenuButton<MenuOptions>(
          key: const ValueKey<String>('ShowPopupMenu'),
          onSelected: (MenuOptions value) {
            switch (value) {
              case MenuOptions.showUserAgent:
                _onShowUserAgent(controller.data!, context);
                break;
              case MenuOptions.doPostRequest:
                _onDoPostRequest(controller.data!, context);
                break;
            }
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
            PopupMenuItem<MenuOptions>(
              value: MenuOptions.showUserAgent,
              enabled: controller.hasData,
              child: const Text('내 정보'),
            ),
            PopupMenuItem<MenuOptions>(
              value: MenuOptions.doPostRequest,
              child: Text('Post Request'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onDoPostRequest(
      WebViewController controller, BuildContext context) async {
    final WebViewRequest request = WebViewRequest(
      uri: Uri.parse('http://20.249.210.78:8000/rank'),
      method: WebViewRequestMethod.post,
      headers: <String, String>{'user': 'kimchan', 'point': '20'},
      body: Uint8List.fromList('Test Body'.codeUnits),
    );
    await controller.loadRequest(request);
    print(request);
  }

  Future<void> _onShowUserAgent(
      WebViewController controller, BuildContext context) async {
    await controller.runJavascript(
        'Toaster.postMessage("User Agent: " + navigator.userAgent);');
  }
}
