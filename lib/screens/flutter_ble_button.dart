import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class NewBleScreen extends StatefulWidget {
  const NewBleScreen({super.key});

  @override
  State<NewBleScreen> createState() => _BleScreenState();
}

class _BleScreenState extends State<NewBleScreen> {
  final flutterReactiveBle = FlutterReactiveBle();

  // ESP32 UUID (phải trùng với code ESP32 của bạn)
  final Uuid serviceUuid =
      Uuid.parse("4fafc201-1fb5-459e-8fcc-c5c9c331914b");
  final Uuid charUuid =
      Uuid.parse("beb5483e-36e1-4688-b7f5-ea07361b26a8");

  DiscoveredDevice? espDevice;
  String connectionStatus = "Chưa kết nối";
  String receivedData = "";

  StreamSubscription<DiscoveredDevice>? scanStream;
  StreamSubscription<ConnectionStateUpdate>? connStream;
  StreamSubscription<List<int>>? notifyStream;

  @override
  void initState() {
    super.initState();
    // Tự động bắt đầu quét khi màn hình khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkPermissionsAndStartScan();
    });
  }

  void checkPermissionsAndStartScan() async {
    // Kiểm tra và yêu cầu quyền truy cập vị trí
    var locationPermission = await Permission.locationWhenInUse.status;
    if (!locationPermission.isGranted) {
      setState(() {
        connectionStatus = "Đang yêu cầu quyền truy cập vị trí...";
      });
      
      locationPermission = await Permission.locationWhenInUse.request();
    }
    
    if (!locationPermission.isGranted) {
      setState(() {
        connectionStatus = "Cần cấp quyền truy cập vị trí để quét BLE";
      });
      return;
    }

    // Kiểm tra quyền Bluetooth (Android 12+)
    if (await Permission.bluetoothScan.isDenied) {
      await Permission.bluetoothScan.request();
    }
    
    if (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }
    
    // Kiểm tra trạng thái BLE
    final bleStatus = await flutterReactiveBle.statusStream.first;
    print("BLE Status: $bleStatus");
    
    if (bleStatus == BleStatus.ready) {
      startScan();
    } else {
      setState(() {
        connectionStatus = "BLE không sẵn sàng: $bleStatus";
      });
    }
  }

  void startScan() {
    setState(() {
      connectionStatus = "Đang quét thiết bị...";
    });

    print("Bắt đầu quét với Service UUID: $serviceUuid");

    scanStream = flutterReactiveBle.scanForDevices(
      withServices: [serviceUuid],
      scanMode: ScanMode.lowLatency,
    ).listen(
      (device) {
        print("Tìm thấy thiết bị: ${device.name} - ${device.id}");
        // Bắt được ESP32 thì dừng scan
        if (device.name.isNotEmpty) {
          setState(() {
            espDevice = device;
            connectionStatus = "Đã tìm thấy: ${device.name}";
          });
          scanStream?.cancel();
        }
      },
      onError: (error) {
        print("Lỗi khi quét: $error");
        setState(() {
          connectionStatus = "Lỗi quét: $error";
        });
      },
    );

    // Timeout sau 30 giây nếu không tìm thấy thiết bị
    Timer(Duration(seconds: 30), () {
      if (espDevice == null) {
        scanStream?.cancel();
        setState(() {
          connectionStatus = "Không tìm thấy ESP32 sau 30 giây";
        });
      }
    });
  }

  void connectToDevice() {
    if (espDevice == null) {
      // Nếu chưa tìm thấy thiết bị, bắt đầu quét lại
      startScan();
      return;
    }

    setState(() {
      connectionStatus = "Đang kết nối tới ESP32...";
    });

    connStream = flutterReactiveBle.connectToDevice(
      id: espDevice!.id,
      servicesWithCharacteristicsToDiscover: {serviceUuid: [charUuid]},
      connectionTimeout: const Duration(seconds: 5),
    ).listen((update) {
      switch (update.connectionState) {
        case DeviceConnectionState.connected:
          setState(() {
            connectionStatus = "✅ Đã kết nối ESP32";
          });
          subscribeToData();
          break;
        case DeviceConnectionState.disconnected:
          setState(() {
            connectionStatus = "⚠️ Mất kết nối ESP32";
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
      setState(() {
        receivedData = String.fromCharCodes(data);
      });
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Trạng thái: $connectionStatus"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: connectToDevice,
              child: const Text("🔗 Kết nối ESP32"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: startScan,
              child: const Text("🔄 Quét lại"),
            ),
            const SizedBox(height: 20),
            Text("📩 Dữ liệu nhận từ ESP32:"),
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(receivedData.isEmpty ? "Chưa có dữ liệu" : receivedData),
            ),
          ],
        ),
      ),
    );
  }
}