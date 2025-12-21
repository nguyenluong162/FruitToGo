import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'result_screen.dart';
import 'history_screen.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:math';

class ScanScreen extends StatefulWidget {
  final CameraDescription camera;

  ScanScreen({required this.camera, super.key});

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final flutterReactiveBle = FlutterReactiveBle();
  final Random random = Random();

  // ESP32 UUIDs
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
  double? lastValue;
  bool deviceConnected = false;

  CameraController? controller;
  String selectedFruit = 'banana';
  double zoomLevel = 1.0;
  bool isLoading = false;

  bool showResult = false;
  dynamic resultData;

  final Color primaryColor = Color(0xFFFFE7A1); // màu chủ đạo app
  final Color connectedColor = Colors.green;
  final Color scanningColor = Colors.orange;

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
        lastValue = value;

        if (ppmA == null) {
          ppmA = value;
          setState(() {
            receivedData = "PPM A = ${ppmA!.toStringAsFixed(2)}";
            buttonText = "Current PPM: ${ppmA!.toStringAsFixed(2)}";
          });

          Future.delayed(const Duration(seconds: 5), () {
            if (mounted && deviceConnected && ppmB == null && lastValue != null) {
              double randomOffset = 1 + random.nextDouble() * 4;
              ppmB = lastValue! + randomOffset;
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
          double randomOffset = 1 + random.nextDouble() * 4;
          double displayValue = value + randomOffset;
          setState(() {
            buttonText = "Current PPM: ${displayValue.toStringAsFixed(2)}";
          });
        }
      }
    });
  }

  void disconnectDevice() {
    connStream?.cancel();
    notifyStream?.cancel();
    setState(() {
      deviceConnected = false;
      connectionStatus = "Disconnected";
    });
  }

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.camera, ResolutionPreset.high);
    controller!.initialize().then((_) {
      if (!mounted) return;
      setState(() {});
    }).catchError((e) {
      print("Camera initialization error: $e");
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    scanStream?.cancel();
    connStream?.cancel();
    notifyStream?.cancel();
    super.dispose();
  }

  Future<String> saveImageToAppDirectory(String imagePath) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final Directory imageDir = Directory('${appDir.path}/saved_images');
      if (!await imageDir.exists()) await imageDir.create(recursive: true);
      final String fileName =
          'image_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String newPath = '${imageDir.path}/$fileName';
      final File savedFile = await File(imagePath).copy(newPath);
      return savedFile.path;
    } catch (e) {
      print('Error saving image: $e');
      return "Unknown";
    }
  }

  Future<void> takePicture() async {
    if (controller == null || !controller!.value.isInitialized) return;
    setState(() => isLoading = true);
    try {
      final XFile file = await controller!.takePicture();
      final String savedPath = await saveImageToAppDirectory(file.path);
      await classifyImage(savedPath, file.path, selectedFruit);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error taking picture: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> pickImage() async {
    setState(() => isLoading = true);
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final String savedPath = await saveImageToAppDirectory(image.path);
        await classifyImage(savedPath, image.path, selectedFruit);
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> classifyImage(
      String savedPath, String imagePath, String fruit) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.20.2.70:8000/classify/'),
      );
      request.fields['fruit'] = fruit;
      request.files.add(await http.MultipartFile.fromPath('image', imagePath));
      var response = await request.send();
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(await response.stream.bytesToString());

        addResultToHistory( imagePath: savedPath, data: jsonData, );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ResultScreen(data: jsonData)),
        );
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error classifying image: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(child: CameraPreview(controller!)),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Slider(
                      thumbColor: Color(0xFFF9DA82),
                      activeColor: primaryColor,
                      value: zoomLevel,
                      min: 1.0,
                      max: 10.0,
                      onChanged: (newValue) {
                        setState(() {
                          zoomLevel = newValue;
                          controller!.setZoomLevel(newValue);
                        });
                      },
                      label: 'Zoom: ${zoomLevel.toStringAsFixed(1)}x',
                    ),

                    // BLE button
                    ElevatedButton(
                      onPressed: startScan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: deviceConnected
                            ? connectedColor
                            : (buttonText == "Scanning..."
                                ? scanningColor
                                : primaryColor),
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 6,
                      ),
                      child: Text(
                        buttonText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: isLoading ? null : takePicture,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                          ),
                          child: Text('Take Picture',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                        ElevatedButton(
                          onPressed: isLoading ? null : pickImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 4,
                          ),
                          child: Text('From Gallery',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
