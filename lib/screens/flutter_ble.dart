import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:async';

class BleScreen extends StatefulWidget {
  const BleScreen({super.key});

  @override
  State<BleScreen> createState() => _BleScreenState();
}

class _BleScreenState extends State<BleScreen> {
  final flutterReactiveBle = FlutterReactiveBle();

  // ESP32 UUIDs (must match ESP32 code)
  final Uuid serviceUuid =
      Uuid.parse("4fafc201-1fb5-459e-8fcc-c5c9c331914b");
  final Uuid charUuid =
      Uuid.parse("beb5483e-36e1-4688-b7f5-ea07361b26a8");

  DiscoveredDevice? espDevice;
  String connectionStatus = "Not connected";
  String receivedData = "";
  String buttonText = "Scan & Connect ESP32";

  StreamSubscription<DiscoveredDevice>? scanStream;
  StreamSubscription<ConnectionStateUpdate>? connStream;
  StreamSubscription<List<int>>? notifyStream;

  double? ppmA;
  double? ppmB;
  double? lastValue; // ✅ always keep latest ppm value
  bool deviceConnected = false;

  // Start scanning
  void startScan() {
    setState(() {
      connectionStatus = "Scanning for device...";
      buttonText = "Scanning...";
      ppmA = null;
      ppmB = null;
      lastValue = null;
      receivedData = "";
    });

    scanStream = flutterReactiveBle.scanForDevices(
      withServices: [serviceUuid],
      scanMode: ScanMode.lowLatency,
    ).listen((device) {
      if (device.name == "FruitToGo") {
        setState(() {
          espDevice = device;
          connectionStatus = "Found: ${device.name}, connecting...";
        });
        scanStream?.cancel();
        connectToDevice();
      }
    });
  }

  // Connect to device
  void connectToDevice() {
    if (espDevice == null) return;

    connStream = flutterReactiveBle.connectToDevice(
      id: espDevice!.id,
      servicesWithCharacteristicsToDiscover: {serviceUuid: [charUuid]},
      connectionTimeout: const Duration(seconds: 5),
    ).listen((update) {
      switch (update.connectionState) {
        case DeviceConnectionState.connected:
          setState(() {
            connectionStatus = "✅ Connected to ESP32";
            deviceConnected = true;
          });
          subscribeToData();
          break;
        case DeviceConnectionState.disconnected:
          setState(() {
            connectionStatus = "⚠️ Disconnected from ESP32";
            deviceConnected = false;
          });
          break;
        default:
          break;
      }
    });
  }

  // Subscribe to PPM data
  void subscribeToData() {
    final characteristic = QualifiedCharacteristic(
      serviceId: serviceUuid,
      characteristicId: charUuid,
      deviceId: espDevice!.id,
    );

    notifyStream = flutterReactiveBle
        .subscribeToCharacteristic(characteristic)
        .listen((data) {
      String rawString = String.fromCharCodes(data);
      double? value =
          double.tryParse(rawString.replaceAll(RegExp(r'[^0-9.]'), ''));

      if (value != null) {
        lastValue = value; // ✅ keep updating latest value

        if (ppmA == null) {
          // first value → set as PPM A
          ppmA = value;
          setState(() {
            receivedData = "PPM A = ${ppmA!.toStringAsFixed(2)}";
            buttonText = "Current PPM: ${ppmA!.toStringAsFixed(2)}";
          });

          // after 5 seconds → set PPM B with latest value
          Future.delayed(const Duration(seconds: 5), () {
            if (mounted && deviceConnected && ppmB == null && lastValue != null) {
              ppmB = lastValue;
              double delta = ppmB! - ppmA!;
              setState(() {
                receivedData +=
                    "\nPPM B = ${ppmB!.toStringAsFixed(2)}\nΔ = ${delta.toStringAsFixed(2)}";
                buttonText =
                    "PPM A: ${ppmA!.toStringAsFixed(2)}, PPM B: ${ppmB!.toStringAsFixed(2)}, Δ: ${delta.toStringAsFixed(2)}";
              });
              disconnectDevice();
            }
          });
        } else {
          // update live ppm on button
          setState(() {
            buttonText = "Current PPM: ${value.toStringAsFixed(2)}";
          });
        }
      }
    });
  }

  // Disconnect device
  void disconnectDevice() {
    connStream?.cancel();
    notifyStream?.cancel();
    setState(() {
      deviceConnected = false;
      connectionStatus = "Disconnected";
    });
  }

  @override
  void dispose() {
    scanStream?.cancel();
    connStream?.cancel();
    notifyStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ESP32 BLE Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Status: $connectionStatus"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: startScan,
              child: Text(buttonText),
            ),
            const SizedBox(height: 20),
            Text("📩 Data from ESP32:"),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                receivedData.isEmpty ? "No data yet" : receivedData,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
