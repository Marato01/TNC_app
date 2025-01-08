import 'package:flutter/material.dart';

class ScreenTurnoffBluetooth extends StatelessWidget {
  const ScreenTurnoffBluetooth({super.key});

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Column(
        children: [
          Icon(Icons.bluetooth, color: const Color(0xFF8D8D8D), size: MediaQuery.of(context).size.width * 0.50),
          Text('Bluetooth Turn off', style: TextStyle(color: Colors.white,fontSize: MediaQuery.of(context).size.width * 0.05),),
          Text('Turn on to connect device and receive file transfer', style: TextStyle(color: Colors.white, fontSize: MediaQuery.of(context).size.width * 0.03)),
        ],
      ),
    );
  }
}
