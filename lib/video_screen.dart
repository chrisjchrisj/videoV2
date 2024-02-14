import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class VideoRecordingScreen extends StatefulWidget {
  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      CameraDescription(),
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _recordVideo() async {
    try {
      await _initializeControllerFuture;
      final XFile video = await _controller.recordVideo();

      // Upload the video to Firebase Storage after recording
      await _uploadVideo(video);
    } catch (e) {
      print('Error recording video: $e');
    }
  }

  Future<void> _uploadVideo(XFile video) async {
    try {
      final Reference storageReference =
          FirebaseStorage.instance.ref().child('videos');
      final String postId = Uuid().v1();
      final TaskSnapshot uploadTask = await storageReference
          .child('$postId.mp4')
          .putFile(File(video.path));

      final String downloadUrl =
          await uploadTask.ref.getDownloadURL();
      print('Download URL: $downloadUrl');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload succeeded'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Error uploading video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Recording'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _recordVideo,
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
