import 'package:flutter/material.dart';

class Username extends StatelessWidget {
  const Username({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Column(
      children: [
        Text('Welcome, Home', style: TextStyle(color: Colors.white),),
        Text('@Sam Sothavy', style: TextStyle(color: Colors.white),),
      ],
    );
  }
}
