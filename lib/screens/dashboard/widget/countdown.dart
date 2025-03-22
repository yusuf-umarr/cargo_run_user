import 'dart:async';
import 'package:cargo_run/styles/app_colors.dart';
import 'package:flutter/material.dart';

class CountdownTimer extends StatefulWidget {
  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  static const int startTime = 300; // 5 minutes in seconds
  int remainingTime = startTime;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() {
          remainingTime--;
        });
      } else {
        setState(() {
          remainingTime = startTime; // Reset to 5 minutes
        });
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int secs = seconds % 60;
    return "$minutes:$secs mins";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          height: size.width * 0.02,
          width: size.width * 0.9,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size.width * 0.024),
            color: (remainingTime == 0) ? primaryColor1 : Colors.grey,
          ),
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: remainingTime / startTime,
            child: Container(
              height: size.width * 0.02,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size.width * 0.024),
                color: primaryColor1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          formatTime(remainingTime),
          textAlign: TextAlign.left,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.w500, color: primaryColor1,),
        ),
      ],
    );
  }
}
