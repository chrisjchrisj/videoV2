//0217-848
import 'package:camera/camera.dart'; // Import the camera package
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:video/camera_page.dart';

List<CameraDescription>? camera; // Declare the camera list

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  camera = await availableCameras(); // Initialize the camera list
  await Firebase.initializeApp();
  runApp(App());
}

class App extends StatelessWidget {
  const App({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CameraScreen(), // Use CameraScreen instead of cameraScreen
    );
  }
}

