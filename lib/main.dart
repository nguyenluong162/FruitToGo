import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:testapp/screens/favorite_screen.dart';
import 'package:testapp/screens/flutter_ble_button.dart';
import 'package:testapp/screens/noti_screen.dart';
import 'screens/start_screen.dart';
import 'screens/intro1_screen.dart';
import 'screens/intro2_screen.dart';
import 'screens/intro3_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/result_screen.dart';
import 'screens/scan_screen.dart';
import 'screens/flutter_ble.dart';
import 'screens/flutter_ble_button.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  runApp(FruitToGoApp(cameras: cameras));
}

class FruitToGoApp extends StatelessWidget {
  final List<CameraDescription> cameras;
  const FruitToGoApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'LeagueSpartan',
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => StartScreen(),
        '/intro1': (context) => const Intro1Screen(),
        '/intro2': (context) => const Intro2Screen(),
        '/intro3': (context) => const Intro3Screen(),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => HomeScreen(camera: cameras.first),
        '/favorite': (context) => const FavoriteScreen(),
        '/scan': (context) => ScanScreen(camera: cameras.first),
        '/noti': (context) => NotiScreen(),
      },
    );
  }
}