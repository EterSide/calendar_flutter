import 'package:flutter/material.dart';

class AlarmFragment extends StatelessWidget {
  const AlarmFragment({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '알람',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: Container(),
    );
  }
}
