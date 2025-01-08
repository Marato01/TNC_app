import 'package:airlora_app/provider/bluetooth_provider/blu_provider.dart';
import 'package:airlora_app/provider/switch_provider/switch_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view/homepage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BluetoothSwitchProvider()),
        ChangeNotifierProvider(create: (context) => BLEProvider()),
      ],
      child: const MyApp(), // `child` moved to the correct position
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: const Color(0xFF222831), // Set the background color
        useMaterial3: true,
      ),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
