//021624-313
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video/video_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  late Future<void> _cameraValue;

  @override
  void initState() {
    _cameraController = CameraController(camera!.first, ResolutionPreset.high);
    _cameraValue = _initializeCamera();
    super.initState();
  }

  Future<void> _initializeCamera() async {
    await _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  bool flip = true;
  bool flash = false;
  XFile? photo;
  bool isRecording = false;
  int zoom = 1;
  bool show = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Stack(
          children: [
            FutureBuilder<void>(
              future: _cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GestureDetector(
                  onTap: () async {
                    await _cameraController.setFocusMode(FocusMode.auto);
                  },
                  onLongPress: () async {
                    await _cameraController.setFocusMode(FocusMode.locked);
                  },
                  child: CameraPreview(_cameraController),
                );
              },
            ),
            // Other widgets...
          ],
        ),
      ),
    );
  }
}
