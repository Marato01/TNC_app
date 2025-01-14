import 'package:flutter/material.dart';

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
                    return Container(
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
                        ));
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
