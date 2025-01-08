import 'package:flutter/foundation.dart';

class BluetoothSwitchProvider with ChangeNotifier {
  bool _blueSwitch = false;

  bool get blueSwitch => _blueSwitch;

  void setBlueSwitch(bool value) {
    _blueSwitch = value;
    notifyListeners();
    print(blueSwitch);
  }
}
