import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/bluetooth_provider/blu_provider.dart';
import '../../homepage.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  bool _hasShownToast = false;

  @override
  Widget build(BuildContext context) {

    final bleProvider = Provider.of<BLEProvider>(context);

    if (!bleProvider.isConnected && !_hasShownToast) {
      _hasShownToast = true;
      Future.microtask(() {
        CherryToast.warning(
          toastDuration: const Duration(seconds: 2),
          disableToastAnimation: true,
          title: const Text(
            'Disconnected',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          inheritThemeColors: true,
          actionHandler: () {},
          onToastClosed: () {
            setState(() {
              _hasShownToast = false; // Allow re-showing the toast later
            });
          },
        ).show(context);
      });
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
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                    );
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_outlined,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.02),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configuration',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),


            Text(
              'Please fill out the fields below to configure your Wi-Fi and additional settings.',
              style: TextStyle(
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.03
              ),
            ),


          ],
        ),
      ),
    );
  }
}
