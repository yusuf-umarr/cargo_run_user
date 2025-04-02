// ignore_for_file: use_build_context_synchronously

import 'package:cargo_run/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:webview_flutter/webview_flutter.dart';
import 'dart:developer' as dev;

class CheckoutScreen extends StatefulWidget {
  final String paymentUrl;
  final String reference;
  final String orderId;
  static const String routeName = '/checkout';

  const CheckoutScreen({
    super.key,
    required this.paymentUrl,
    required this.reference,
    required this.orderId,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageFinished: (url) {},
          onNavigationRequest: (NavigationRequest request) async {
            // dev.log(
            //     '==========print callback url=============: ${request.url}');
            if (request.url.contains('https://cargo-run-payment.com')) {
              // dev.log('===========X==========================: ${request.url}');

              context
                  .read<OrderProvider>()
                  .verifyPayment(widget.reference, widget.orderId, context);

              return NavigationDecision.prevent;
            } else {}
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payment",
          style: TextStyle(fontSize: 14),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
