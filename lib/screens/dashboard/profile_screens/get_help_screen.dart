// ignore_for_file: deprecated_member_use

import 'package:auto_route/auto_route.dart';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

@RoutePage()
class GetHelpScreen extends StatefulWidget {
  const GetHelpScreen({super.key});

  @override
  State<GetHelpScreen> createState() => _GetHelpScreenState();
}

class _GetHelpScreenState extends State<GetHelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get Help'),
        leading: IconButton(
          onPressed: () => context.maybePop(),
          icon: SvgPicture.asset(
            'assets/images/arrow-left.svg',
            color: blackText,
          ),
        ),
        centerTitle: true,
      ),
      body: const Column(
        children: [
          //chat screen
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No messages yet',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                      color: blackText,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'You have not started any conversation yet',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                      color: greyText,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
