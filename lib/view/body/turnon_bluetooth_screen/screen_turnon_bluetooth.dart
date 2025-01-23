import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../provider/bluetooth_provider/blu_provider.dart';

class ScreenTurnOnBluetooth extends StatefulWidget {
  const ScreenTurnOnBluetooth({super.key});

  @override
  State<ScreenTurnOnBluetooth> createState() => _ScreenTurnOnBluetoothState();
}

class _ScreenTurnOnBluetoothState extends State<ScreenTurnOnBluetooth> {

  @override
  Widget build(BuildContext context) {
    final bleProvider = Provider.of<BLEProvider>(context);
    return Expanded(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
            child: Row(
              children: [
                 const Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Device", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),

                SizedBox(width: MediaQuery.of(context).size.width * 0.05),

                if(bleProvider.isScanning)
                LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.white,
                  size: 25,
                ),
              ],
            ),
          ),

          Consumer<BLEProvider>(
            builder: (context, bleProvider, child) {
              return Expanded(
                child: ListView.separated(
                  itemCount: bleProvider.devices.length,
                  separatorBuilder: (context, index) => const Divider(
                    color: Colors.black, // Color of the divider
                    thickness: 1.0, // Thickness of the divider
                    height: 1.0, // Space occupied by the divider
                  ),
                  itemBuilder: (context, index) {
                    final device = bleProvider.devices[index];
                    final isSelected = device.id == bleProvider.selectedDevice?.id;
      
                    return GestureDetector(
                      onTap: () async {
                          await bleProvider.connectToDevice(context, device);
                      },

                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isSelected
                                      ? Icons.bluetooth_connected
                                      : Icons.bluetooth,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 10), // Add some spacing
                                Text(
                                  device.name.isNotEmpty
                                      ? device.name
                                      : 'Unknown Device',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                const SizedBox(width: 10), // Add some spacing
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
