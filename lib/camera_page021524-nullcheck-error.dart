import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:video/video_screen.dart';

List<CameraDescription>? camera;

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _cameraController;
  late Future<void> cameraValue;
  @override
  void initState() {
    //_cameraController = CameraController(camera![0], ResolutionPreset.high);
    _cameraController = CameraController(camera!.first, ResolutionPreset.high);

    cameraValue = _cameraController!.initialize();
    super.initState();
  }

  bool flip = true;
  bool flash = false;
  XFile? photo;

  @override
  void dispose() {
    _cameraController!.dispose();
    super.dispose();
  }

  bool isrecording = false;
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
            FutureBuilder(
              future: cameraValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GestureDetector(
                  onTap: () async {
                    await _cameraController!.setFocusMode(FocusMode.auto);
                  },
                  onLongPress: () async {
                    await _cameraController!.setFocusMode(FocusMode.locked);
                  },
                  child: CameraPreview(_cameraController!),
                );
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
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (!flip) {
                        flash = false;
                      } else {
                        if (flash) {
                          setState(() {
                            flash = false;
                          });
                        } else {
                          setState(() {
                            flash = true;
                          });
                        }
                      }
                      flash
                          ? _cameraController!.setFlashMode(FlashMode.torch)
                          : _cameraController!.setFlashMode(FlashMode.off);
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          !flip
                              ? Container(
                                  height: 27,
                                  width: 40,
                                  color: Colors.transparent,
                                )
                              : zoom == 10
                                  ? GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          zoom = 1;
                                          show = false;
                                        });
                                        await _cameraController!
                                            .setZoomLevel(zoom.toDouble());
                                      },
                                      child: const CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.white30,
                                        child: Text(
                                          '10x',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  : zoom == 4
                                      ? GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              zoom = 10;
                                            });
                                            await _cameraController!
                                                .setZoomLevel(
                                                    zoom.toDouble());
                                          },
                                          child: const CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.white30,
                                            child: Text(
                                              '4x',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        )
                                      : zoom == 2
                                          ? GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  zoom = 4;
                                                });
                                                await _cameraController!
                                                    .setZoomLevel(
                                                        zoom.toDouble());
                                              },
                                              child: const CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.white30,
                                                child: Text(
                                                  '2x',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () async {
                                                setState(() {
                                                  zoom = 2;
                                                  show = true;
                                                });
                                                await _cameraController!
                                                    .setZoomLevel(
                                                        zoom.toDouble());
                                              },
                                              child: CircleAvatar(
                                                radius: 20,
                                                backgroundColor: Colors.white30,
                                                child: Text(
                                                  '${zoom}x',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                              ),
                                            ),
                          !flip
                              ? Container(
                                  height: 27,
                                  width: 40,
                                  color: Colors.transparent,
                                )
                              : GestureDetector(
                                  onTap: () {
                                    if (show) {
                                      setState(() {
                                        show = false;
                                      });
                                    } else {
                                      setState(() {
                                        show = true;
                                      });
                                    }
                                  },
                                  child: Icon(
                                    show
                                        ? Icons.arrow_drop_up
                                        : Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (isrecording) {
                            photo = await _cameraController!
                                .stopVideoRecording();
                            Navigator.push(context, CupertinoPageRoute(builder: (_) {
                              return sendVideo(
                                imagepath: photo!,
                              );
                            }));
                          } else {
                            await _cameraController!.startVideoRecording();
                          }
                          setState(() {
                            isrecording = !isrecording;
                          });
                        },
                        child: Icon(
                          isrecording
                              ? Icons.radio_button_on
                              : Icons.panorama_fish_eye,
                          color: isrecording ? Colors.red : Colors.white,
                          size: 70,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          setState(() {
                            flip = !flip;
                            flash = false;
                          });
                          int n = flip ? 0 : 1;
                          _cameraController = CameraController(
                              camera![n], ResolutionPreset.high);
                          cameraValue = _cameraController!.initialize();
                        },
                        icon: const Icon(
                          Icons.camera_roll,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  show
                      ? SizedBox(
                          width: 300,
                          child: Slider(
                              max: 10,
                              min: 1,
                              value: zoom.toDouble(),
                              onChanged: (v) async {
                                await _cameraController!
                                    .setZoomLevel(zoom.toDouble());
                                setState(() {
                                  zoom = v.toInt();
                                  log(v.roundToDouble().toString());
                                });
                              }),
                        )
                      : const Text(
                          'Tap to Start Recording & Tap to Stop Recording',
                          style: TextStyle(color: Colors.grey),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
