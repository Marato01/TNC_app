import 'package:airlora_app/provider/bluetooth_provider/blu_provider.dart';
import 'package:airlora_app/provider/switch_provider/switch_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'provider/device_provider/devicename_provider.dart';
import 'view/selectdevice/select_device_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BluetoothSwitchProvider()),
        ChangeNotifierProvider(create: (context) => BLEProvider()),
        ChangeNotifierProvider(create: (context) => DeviceProvider()),
      ],
      child: const MyApp(), // `child` moved to the correct position
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState(){
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFF232D3F), // Set the background color
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: SelectDeviceScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
