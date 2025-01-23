import 'dart:async';
import 'dart:convert';
import 'package:app_settings/app_settings.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import '../switch_provider/switch_provider.dart';

class BLEProvider extends ChangeNotifier {
  final FlutterReactiveBle flutterReactiveBle = FlutterReactiveBle();
  StreamSubscription? _scanStream;
  StreamSubscription? _connectionStream;
  final List<DiscoveredDevice> _devices = [];
  final Set<String> _deviceIds = {};
  bool _isScanning = false;
  bool _isConnected = false;
  DiscoveredDevice? _selectedDevice;
  // ignore: prefer_typing_uninitialized_variables
  var serviceUuid;
  // ignore: prefer_typing_uninitialized_variables
  var characteristicUuid;

  // Getters
  List<DiscoveredDevice> get devices => _devices;
  bool get isScanning => _isScanning;
  bool get isConnected => _isConnected;
  DiscoveredDevice? get selectedDevice => _selectedDevice;
  Stream<List<int>>? characteristicValueStream;

  @override
  void dispose() {
    _scanStream?.cancel();
    _connectionStream?.cancel();
    super.dispose();
  }

  // Function scan device
  Future<void> startScan(BuildContext context) async {
    bool goForIt = false;

    if (Platform.isAndroid) {
      bool locationEnabled = await Permission.locationWhenInUse.serviceStatus.isEnabled;

      // Check Bluetooth state
      final bluetoothState = await flutterReactiveBle.statusStream.first;

      if (bluetoothState == BleStatus.poweredOff) {
        bool? bluetoothDialogResult = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF373737),
              title: const Text("Enable Bluetooth", style: TextStyle(color: Colors.white)),
              content: const Text("Bluetooth is disabled. Please enable it in settings.", style: TextStyle(color: Colors.white)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    bool value = false;
                    final blue = Provider.of<BluetoothSwitchProvider>(context, listen: false);
                    blue.setBlueSwitch(value);
                  },
                  child: const Text("Cancel", style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                    await AppSettings.openAppSettings();
                  },
                  child: const Text("Go to Settings", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
        if (bluetoothDialogResult == true) {
          // Wait for a moment to allow settings to update
          await Future.delayed(const Duration(seconds: 2));
          final newBluetoothState = await flutterReactiveBle.statusStream.first;

          if (newBluetoothState == BleStatus.poweredOff) {
            throw Exception('Bluetooth must be enabled to scan for BLE devices');
          }
        } else {
          // User cancelled, abort scan
          throw Exception('Bluetooth is required to scan for BLE devices');
        }
      }


      // Check location state
      if (!locationEnabled) {
        bool? dialogResult = await showDialog<bool>(
          // ignore: use_build_context_synchronously
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: const Color(0xFF373737),
              title: const Text("Enable Location Services",style: TextStyle(color: Colors.white),),
              content: const Text("Location services are disabled. Please enable them in settings.",style: TextStyle(color: Colors.white),),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    bool value = false;
                    final blue = Provider.of<BluetoothSwitchProvider>(context, listen: false);
                    blue.setBlueSwitch(value);
                  },
                  child: const Text("Cancel",style: TextStyle(color: Colors.white),),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                    await Geolocator.openLocationSettings();
                  },
                  child: const Text("Go to Settings",style: TextStyle(color: Colors.white),),
                ),
              ],
            );
          },
        );

        // Check if location was enabled after returning from settings
        if (dialogResult == true) {
          // Wait for a moment to allow settings to update
          await Future.delayed(const Duration(seconds: 2));
          locationEnabled = await Permission.locationWhenInUse.serviceStatus.isEnabled;

          // If still not enabled, show error message
          if (!locationEnabled) {
            throw Exception('Location services must be enabled to scan for BLE devices');
          }
        } else {
          // User cancelled, abort scan
          throw Exception('Location services are required to scan for BLE devices');
        }
      }

      int sdkInt = 0;
      try {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        sdkInt = androidInfo.version.sdkInt;
      } catch (e) {
        sdkInt = 31;
        debugPrint('Could not determine Android SDK version: $e');
      }

      if (sdkInt >= 31) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
          Permission.bluetoothAdvertise,
          Permission.location,
          Permission.locationWhenInUse,
        ].request();

        goForIt = statuses.values.every((status) => status == PermissionStatus.granted);

        if (!goForIt) {
          String deniedPermissions = statuses.entries
              .where((entry) => entry.value != PermissionStatus.granted)
              .map((entry) => entry.key.toString())
              .join(', ');
          throw Exception('Required permissions not granted: $deniedPermissions');
        }
      } else {
        PermissionStatus locationPermission = await Permission.location.request();
        PermissionStatus finePermission = await Permission.locationWhenInUse.request();

        goForIt = locationPermission == PermissionStatus.granted &&
            finePermission == PermissionStatus.granted;

        if (!goForIt) {
          throw Exception('Location permission is required to scan for BLE devices');
        }
      }
    } else if (Platform.isIOS) {
      PermissionStatus bluetoothPermission = await Permission.bluetooth.request();
      goForIt = bluetoothPermission == PermissionStatus.granted;
    }

    if (goForIt) {
      _devices.clear();
      _deviceIds.clear();
      _isScanning = true;
      notifyListeners();

      _scanStream = flutterReactiveBle.scanForDevices(
        withServices: [],
        scanMode: ScanMode.balanced,
        requireLocationServicesEnabled: true,
      ).listen(
            (device) {
          if (device.name.isNotEmpty && !_deviceIds.contains(device.id)) {
            _deviceIds.add(device.id);
            _devices.add(device);
            notifyListeners();
          }
        },
        onError: (error) {
          debugPrint('Scanning error: $error');
          stopScan();
          throw Exception('Scanning error: $error');
        },
      );

      Future.delayed(const Duration(seconds: 30), () {
        if (_isScanning) {
          stopScan();
        }
      });
    }
  }

  // Function connect device
  Future<void> connectToDevice(BuildContext context, DiscoveredDevice device) async {
    try {
      _isScanning = false;
      _selectedDevice = device;
      notifyListeners();
      stopScan();

      _connectionStream = flutterReactiveBle.connectToDevice(
        id: device.id,
        servicesWithCharacteristicsToDiscover: null,
        connectionTimeout: const Duration(seconds: 10),
      ).listen(
            (connectionState) async {
          debugPrint('Connection state: ${connectionState.connectionState}');
          if (connectionState.connectionState == DeviceConnectionState.connected) {
            _isConnected = true;
            //stream after connect device successful
            readCharacteristic();
            notifyListeners();

            //handle connected mesasge
            CherryToast.success(  // Changed to error type instead of info
              toastDuration: const Duration(milliseconds: 1),
              disableToastAnimation: true,
              title: const Text(
                'Connection successful',  // Added error message
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              inheritThemeColors: true,
              actionHandler: () {},
              onToastClosed: () {},
            ).show(context);

            final services = await flutterReactiveBle.discoverServices(device.id);
            for (var service in services) {
              serviceUuid = service.serviceId;
              for (var characteristic in service.characteristics) {
                characteristicUuid = characteristic.characteristicId;
              }
            }
          }
          else if (connectionState.connectionState == DeviceConnectionState.disconnected) {
            _isConnected = false;
            notifyListeners();

            //handle disconnected message
            CherryToast.info(  // Changed to error type instead of info
              toastDuration: const Duration(milliseconds: 1),
              disableToastAnimation: true,
              title: const Text(
                'Connection failed',  // Added error message
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              inheritThemeColors: true,
              actionHandler: () {},
              onToastClosed: () {},
            ).show(context);

          }
        },
        onError: (error) {
          debugPrint('Connection error: $error');
          throw Exception('Connection error: $error');
        },
      );
    } catch (e) {
      debugPrint('Error connecting to device: $e');
      throw Exception('Error connecting to device: $e');
    }
  }

  // Function write value
  Future<void> writeCharacteristic(String message) async {
    if (_selectedDevice == null || !_isConnected) {
      throw Exception('No device connected');
    }

    try {
      final value = message.codeUnits;
      final characteristic = QualifiedCharacteristic(
        serviceId: serviceUuid,
        characteristicId: characteristicUuid,
        deviceId: _selectedDevice!.id,
      );

      await flutterReactiveBle.writeCharacteristicWithResponse(characteristic, value: value);
    } catch (e) {
      throw Exception('Error writing characteristic: $e');
    }
  }

  // Function read value
  Future<void> readCharacteristic() async {

    // Ensure a device is connected
    if (_selectedDevice == null || !_isConnected) {
      throw Exception('No device connected.');
    }

    try {
      // Discover services and characteristics
      final services = await flutterReactiveBle.discoverServices(_selectedDevice!.id);
      QualifiedCharacteristic? notifiableCharacteristic;

      // Find a notifiable characteristic
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.isNotifiable) {
            var servicesUuid = service.serviceId;
            var characteristicUuids = characteristic.characteristicId;

            notifiableCharacteristic = QualifiedCharacteristic(
              serviceId: servicesUuid,
              characteristicId: characteristicUuids,
              deviceId: _selectedDevice!.id,
            );
            break;
          }
        }
        if (notifiableCharacteristic != null) break;
      }

      // Throw exception if no notifiable characteristic is found
      if (notifiableCharacteristic == null) {
        throw Exception('No notifiable characteristic found.');
      }


      // Subscribe to the notifiable characteristic
      characteristicValueStream = flutterReactiveBle.subscribeToCharacteristic(notifiableCharacteristic);

      characteristicValueStream?.listen(
            (data) {
          final value = utf8.decode(data); // Decode bytes to UTF-8 string
          print('Received value: $value');

        },
        onError: (error) {
          debugPrint('Error receiving notifications: $error');
        },
      );
    } catch (e) {
      debugPrint('Error in readCharacteristic: $e');
      throw Exception('Error reading characteristic: $e');
    }
  }

  // function for disconnect
  void disconnect() {
    _connectionStream?.cancel();
    _isConnected = false;
    _selectedDevice = null;
    notifyListeners();
  }

  // function for stop scan
  void stopScan() {
    _scanStream?.cancel();
    _isScanning = false;
    notifyListeners();
  }
}

