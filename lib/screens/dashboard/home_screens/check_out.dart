// ignore_for_file: use_build_context_synchronously

import 'dart:developer' as dev;
import 'package:cargo_run/providers/app_provider.dart';
import 'package:cargo_run/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import 'package:webview_flutter/webview_flutter.dart';

class CheckoutScreen extends StatefulWidget {
  final String paymentUrl;
  final String reference;
  static const String routeName = '/checkout';

  const CheckoutScreen({
    super.key,
    required this.paymentUrl,
    required this.reference,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late WebViewController controller;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageFinished: (url) {},
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.contains('api/subscription/paystack/callback')) {
              //api/subscription/paystack/callback
              dev.log('===========X==========================: ${request.url}');

              context.read<OrderProvider>().verifyPayment(widget.reference);

              toast("Payment successful");
              Future.delayed(const Duration(seconds: 3), () {
                Navigator.of(context).pop();
              });

              return NavigationDecision.prevent;
            } else {}
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
    return PopScope(
      onPopInvokedWithResult: (a, b) {
        context.read<OrderProvider>().verifyPayment(widget.reference);
      },
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                  onPressed: () {
                    context
                        .read<OrderProvider>()
                        .verifyPayment(widget.reference);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              const Text(
                "Payment",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }
}
