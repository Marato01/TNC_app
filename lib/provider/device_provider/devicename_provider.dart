import 'package:flutter/material.dart';

class DeviceProvider with ChangeNotifier {
  String _selectedDevice = '';

  String get selectedDevice => _selectedDevice;

  void setSelectedDevice(String device) {
    _selectedDevice = device;
    notifyListeners(); // Notify listeners of the change
  }
}
