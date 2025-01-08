import 'package:flutter/material.dart';
import 'package:riff_switch/riff_switch.dart';

class SwitchButton extends StatefulWidget {
  const SwitchButton({super.key});

  @override
  State<SwitchButton> createState() => _SwitchButtonState();
}
class _SwitchButtonState extends State<SwitchButton> {
  late bool _switchValue_9 = false;

  @override
  Widget build(BuildContext context) {
    return RiffSwitch(
      value: _switchValue_9,
      onChanged: (value) => setState(() {
        _switchValue_9 = value;
      }),
      type: RiffSwitchType.cupertino,
    );
  }
}
