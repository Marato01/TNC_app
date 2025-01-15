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

  // Define as final to ensure it's initialized before controllers
  final List<String> nameParam = ["WiFi Name", "Password", "Field One", "Field Two", "Field Three"];

  // Initialize controllers list immediately with the nameParam length
  final List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers in initState
    for (int i = 0; i < nameParam.length; i++) {
      _controllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    // Dispose of all controllers to free resources
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

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
              _hasShownToast = false;
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

            Expanded(
              child: ListView.builder(
                itemCount: nameParam.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            nameParam[index],
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _controllers[index],
                            decoration: InputDecoration(
                              labelText: nameParam[index],
                              border: const OutlineInputBorder(),
                            ),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Material(
              elevation: 8.0,
              shadowColor: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              child: FloatingActionButton.extended(
                onPressed: () {
                  // Print controller values instead of controller objects
                  for (int i = 0; i < _controllers.length; i++) {
                    print('${nameParam[i]}: ${_controllers[i].text}');
                  }
                },
                label: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                backgroundColor: const Color(0xFF6B6B6B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.05,)
          ],
        ),
      ),
    );
  }
}