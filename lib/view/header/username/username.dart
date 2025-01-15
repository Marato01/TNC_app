import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/bluetooth_provider/blu_provider.dart';
import '../../../provider/device_provider/devicename_provider.dart';
import '../../selectdevice/select_device_screen.dart';

class Username extends StatelessWidget {
  const Username({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedDevice = context.watch<DeviceProvider>().selectedDevice;
    final bleProvider = Provider.of<BLEProvider>(context);
    return Row(
      children: [


        if(!bleProvider.isConnected)
          GestureDetector(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelectDeviceScreen()));
            },
            child: Icon(
              Icons.arrow_back_ios,
              size: MediaQuery.of(context).size.width * 0.08,
              color: Colors.white,
            ),
          ),

        Column(
          children: [
            const Text(
              'Welcome, Home',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              '@$selectedDevice',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        )
      ],
    );
  }
}
