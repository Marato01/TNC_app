import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:riff_switch/riff_switch.dart';
import '../../../provider/bluetooth_provider/blu_provider.dart';
import '../../../provider/switch_provider/switch_provider.dart';

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
        }
      },
      type: RiffSwitchType.cupertino,
    );
  }
}
