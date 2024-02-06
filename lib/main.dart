import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video/res/routes/app_routes.dart';
import 'package:video/view/sign%20up/sign_up.dart';
import 'package:video/camera_page.dart'; // Ensure this import is correct for your camera page

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  try {
    // Attempt to get the available cameras.
    // Note: You might need to handle permissions before calling this.
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Define the initial route or home depending on your app structure
      // home: App(), // If you want to navigate to the camera screen directly, consider using initialRoute and routes instead.
      getPages: AppRoutes.routes(), // This line setups your navigation with GetX.
      // You might need to adjust your routing setup to incorporate the camera page properly.
    );
  }
}

// Remove or comment out the second MyApp class and other duplicated elements if necessary.

// Adjust the rest of your code to integrate the camera funct






// void main()async{
// WidgetsFlutterBinding.ensureInitialized();
// await Firebase.initializeApp();
// runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
// const MyApp({super.key});
// @override
// Widget build(BuildContext context) {
// return GetMaterialApp(
// debugShowCheckedModeBanner: false,
// theme: ThemeData(
// colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
// useMaterial3: true,
// ),
// getPages: AppRoutes.routes(),
// );
// }
// }

//End Added-In Flutter-AuthX code

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  try {
    // Attempt to get the available cameras.
    // Note: You might need to handle permissions before calling this.
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error in fetching the cameras: $e');
  }
  runApp(const MyApp());
}


//void main() async {
//WidgetsFlutterBinding.ensureInitialized();
//camera = await availableCameras();
//Firebase.initializeApp();
//runApp(App());
//}




//class App extends StatelessWidget {
//const App({
//Key? key,
//}) : super(key: key);

//@override
//Widget build(BuildContext context) {
//return MaterialApp(home: MyApp());
//}
//}

class MyApp extends StatefulWidget {
const MyApp({Key? key}) : super(key: key);
@override
_MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
@override
Widget build(BuildContext context) {
return Scaffold(
body: const Center(
child: Text(
'Flutter camera and video recording app',
style: TextStyle(fontSize: 20),
),
),
floatingActionButton: FloatingActionButton.extended(
onPressed: () {
Navigator.push(context,
CupertinoPageRoute(builder: (context) => cameraScreen()));
},
label: const Text('start'),
),
);
}
}