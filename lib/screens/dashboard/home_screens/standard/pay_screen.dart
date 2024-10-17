import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import "package:webview_flutter/webview_flutter.dart";

@RoutePage()
class PayScreen extends StatefulWidget {
  final String url;
  const PayScreen({super.key, required this.url});

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  @override
  Widget build(BuildContext context) {
    WebViewController controller;

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://standard.paystack.co/close')) {
              Navigator.of(context).pop(); //close webview
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    return Scaffold(
      body: WebViewWidget(controller: controller),
    );
  }
}
