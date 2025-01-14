import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/device_provider/devicename_provider.dart';
import '../homepage.dart';

class SelectDeviceScreen extends StatelessWidget {
  SelectDeviceScreen({super.key});

  final List<String> nameDevice = ['Aqua-B', 'Green-B', 'Hydro-B'];
  final double version = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/icons/chiptree.png',
                height: MediaQuery.of(context).size.height * 0.40,
                width: MediaQuery.of(context).size.width * 0.40,
              ),
              Text('Select Device',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.05)),
              Expanded(
                child: ListView.builder(
                  itemCount: nameDevice.length, // Number of items in the list
                  itemBuilder: (BuildContext context, int index) {
                    // Returns the widget to display at the specified index
                    return GestureDetector(
                      onTap: (){

                        // Set the selected device name in the provider
                        context.read<DeviceProvider>().setSelectedDevice(nameDevice[index]);

                        // Navigate to the HomePage
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02),
                          height: MediaQuery.of(context).size.height * 0.05,
                          width: MediaQuery.of(context).size.width * 0.05,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFF6B6B6B),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  nameDevice[index],
                                  style: const  TextStyle(color: Colors.white),
                                ),
                                const Icon(Icons.navigate_next_outlined)
                              ],
                            ),
                          )),
                    );
                  },
                ),
              ),
              Text(
                'Version ${version.toString()}',
                style: const TextStyle(color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
