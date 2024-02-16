//021624-238
// ignore_for_file: non_constant_identifier_names, prefer_const_constructors, use_build_context_synchronously
import 'dart:developer';
import 'dart:io';

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
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(cameras[0], ResolutionPreset.high);
    _cameraValue = _cameraController.initialize();
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
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  return GestureDetector(
                    onTap: () async {
                      await _cameraController.setFocusMode(FocusMode.auto);
                    },
                    onLongPress: () async {
                      await _cameraController.setFocusMode(FocusMode.locked);
                    },
                    child: CameraPreview(_cameraController),
                  );
                }
              },
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (!flip) {
                        flash = false;
                      } else {
                        setState(() {
                          flash = !flash;
                        });
                      }
                      _cameraController.setFlashMode(
                          flash ? FlashMode.torch : FlashMode.off);
                    },
                    icon: Icon(
                      flash ? Icons.flash_on : Icons.flash_off,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              right: 0,
              left: 0,
              child: Column(
                children: [
                  // Widgets for zoom and other controls
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
