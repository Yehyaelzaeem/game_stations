import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../elements/widget_store_header.dart';
import '../../../helper/showtoast.dart';
import '../../root_pages.dart';
import '../cart/cart_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
class InAppWebViewExampleScreen extends StatefulWidget {
  final String? url;
  InAppWebViewExampleScreen({this.url});
  @override
  _InAppWebViewExampleScreenState createState() => new _InAppWebViewExampleScreenState();
}

class _InAppWebViewExampleScreenState extends State<InAppWebViewExampleScreen> {
  String url = "";
  double progress = 0;

  @override
  void initState() {
  /////  // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
        body: SafeArea(
            child: Column(children: <Widget>[
      globalHeader(context, translate("store.payment")),
      // Expanded(
      //   child: Container(
      //     decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
      //     child: InAppWebView(
      //         // contextMenu: contextMenu,
      //         initialUrl: "${widget.url}",
      //         // initialFile: "assets/index.html",
      //         initialHeaders: {},
      //         onLoadError: (controller, url, code, message) {
      //           return Text(message);
      //         },
      //         onLoadHttpError: (controller, url, statusCode, description) {
      //           return Text(description);
      //         },
      //         initialOptions: InAppWebViewGroupOptions(
      //           crossPlatform: InAppWebViewOptions(
      //             // debuggingEnabled: true,
      //             useShouldOverrideUrlLoading: true,
      //             javaScriptEnabled: true,
      //             javaScriptCanOpenWindowsAutomatically: true,
      //             mediaPlaybackRequiresUserGesture: false,
      //           ),
      //         ),
      //         onWebViewCreated: (InAppWebViewController controller) {
      //           webView = controller;
      //           log("onWebViewCreated");
      //         },
      //         onLoadStart: (InAppWebViewController controller, String url) {
      //           log("onLoadStart $url");
      //           setState(() {
      //             this.url = url;
      //           });
      //         },
      //         shouldOverrideUrlLoading: (controller, shouldOverrideUrlLoadingRequest) async {
      //           // var url = shouldOverrideUrlLoadingRequest.url;
      //           // var uri = Uri.parse(url);

      //           // if (!["http", "https", "file", "chrome", "data", "javascript", "about"].contains(uri.scheme)) {
      //           //   if (await canLaunch(url)) {
      //           //     // Launch the App
      //           //     await launch(
      //           //       url,
      //           //     );
      //           //     // and cancel the request
      //           //     return ShouldOverrideUrlLoadingAction.CANCEL;
      //           //   }
      //           // }

      //           return ShouldOverrideUrlLoadingAction.ALLOW;
      //         },
      //         onLoadStop: (InAppWebViewController controller, String url) async {
      //           log("onLoadStop $url");
      //           setState(() {
      //             this.url = url;
      //           });
      //         },
      //         onProgressChanged: (InAppWebViewController controller, int progress) {
      //           setState(() {
      //             this.progress = progress / 100;
      //           });
      //         },
      //         onUpdateVisitedHistory: (InAppWebViewController controller, String url, bool androidIsReload) {
      //           log("onUpdateVisitedHistory $url");
      //           log("check");
      //           if (url.contains('success') || url.contains("order_success")) {
      //             log("true");
      //             cartProvider.removeAll();

      //             showToast("Order submitted successfully");
      //             Navigator.of(context).pushAndRemoveUntil(
      //               MaterialPageRoute(builder: (context) => RootPages()),
      //               (Route<dynamic> route) => false,
      //             );
      //           } else {
      //             setState(() {
      //               this.url = url;
      //             });
      //           }
      //         }),
      //   ),
      // ),
///////////////////////////////
      Expanded(
        child: Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: "${widget.url}",
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
            onWebViewCreated: (WebViewController webViewController) {},
            onPageFinished: (url) {},
            gestureNavigationEnabled: true,
            navigationDelegate: (NavigationRequest navigation) {
              if (url.contains('success') || url.contains("order_success")) {
                log("true");
                cartProvider.removeAll();

                showToast("Order submitted successfully");
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => RootPages()),
                  (Route<dynamic> route) => false,
                );
              } else {
                setState(() {
                  this.url = url;
                });
              }
              return NavigationDecision.navigate;
            },
            onPageStarted: (url) {
              this.url = url;
              setState(() {});
            },
          ),
        ),
      ),
/////////////////////////////
      // ButtonBar(
      //   alignment: MainAxisAlignment.center,
      //   children: <Widget>[
      //     RaisedButton(
      //       child: Icon(Icons.arrow_back),
      //       onPressed: () {
      //         if (webView != null) {
      //           webView.goBack();
      //         }
      //       },
      //     ),
      //     RaisedButton(
      //       child: Icon(Icons.arrow_forward),
      //       onPressed: () {
      //         if (webView != null) {
      //           webView.goForward();
      //         }
      //       },
      //     ),
      //     RaisedButton(
      //       child: Icon(Icons.refresh),
      //       onPressed: () {
      //         if (webView != null) {
      //           webView.reload();
      //         }
      //       },
      //     ),
      //   ],
      // ),

      // Container(
      //     child: progress < 1.0
      //         ? Padding(
      //             padding: const EdgeInsets.all(8.0),
      //             child: LinearProgressIndicator(value: progress),
      //           )
      //         : Container()),
    ])));
  }
}
