import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riff_switch/riff_switch.dart';
import '../../../provider/bluetooth_provider/blu_provider.dart';
import '../../../provider/switch_provider/switch_provider.dart';
import '../../selectdevice/select_device_screen.dart';

class SwitchButton extends StatefulWidget {
  const SwitchButton({super.key});

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}
class _SwitchButtonState extends State<SwitchButton> {

  @override
  Widget build(BuildContext context) {
    final bluetoothSwitchProvider = Provider.of<BluetoothSwitchProvider>(context);
    final bleProvider = Provider.of<BLEProvider>(context);
    return RiffSwitch(
      value: bluetoothSwitchProvider.blueSwitch,
      onChanged: (value) {
        bluetoothSwitchProvider.setBlueSwitch(value);
        if (value) {
          bleProvider.startScan(context);
        } else {
          bleProvider.stopScan();
          bleProvider.disconnect();
          // Navigate to the next screen with a transition
          Navigator.of(context).push(_createRoute());        }
      },
      type: RiffSwitchType.cupertino,
    );
  }
}

// Create a custom page route with transition
Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SelectDeviceScreen(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Start from the right
      const end = Offset.zero; // End at the original position
      const curve = Curves.easeInOut;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      var offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}

