import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/bluetooth_provider/blu_provider.dart';
import '../provider/switch_provider/switch_provider.dart';
import 'body/connected_screen/connected_screen.dart';
import 'body/turnoff_bluetooth_screen/screen_turnoff_bluetooth.dart';
import 'body/turnon_bluetooth_screen/screen_turnon_bluetooth.dart';
import 'header/header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final switchProvider = Provider.of<BluetoothSwitchProvider>(context);
    final bleProvider = Provider.of<BLEProvider>(context);

    final heightSize = MediaQuery.of(context).size.height * 0.20;
    final gridmargin = MediaQuery.of(context).size.height * 0.05;

    //display body with condition ble_On, ble_Off and connected

    Widget bodyContent;

    // Determine body content based on conditions
    if (bleProvider.isConnected) {
      bodyContent = const ConnectedScreen();
    } else if (switchProvider.blueSwitch) {
      bodyContent = const ScreenTurnOnBluetooth();
    } else {
      bodyContent = const ScreenTurnoffBluetooth();
    }

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.05,
          left: MediaQuery.of(context).size.width * 0.03,
          right: MediaQuery.of(context).size.width * 0.03,
        ),
        child: Column(
          children: [
            const Header(), // Keep the header constant
            if (!switchProvider.blueSwitch) SizedBox(height: heightSize), // Optional spacing
            if (bleProvider.isConnected) SizedBox(height: gridmargin), // Optional spacing
            Expanded(child: bodyContent), // Change only the body content
          ],
        ),
      ),
    );
  }
}
