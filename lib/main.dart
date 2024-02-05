import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video/camera_page.dart';

//Added-In Flutter-AuthX code

import 'package:get/get.dart';
import 'package:res/routes/app_routes.dart';
import 'package:view/sign%20up/sign_up.dart';

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

void main() async {
WidgetsFlutterBinding.ensureInitialized();
camera = await availableCameras();
Firebase.initializeApp();
runApp(App());
}

class App extends StatelessWidget {
const App({
Key? key,
}) : super(key: key);

@override
Widget build(BuildContext context) {
return MaterialApp(home: MyApp());
}
}

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