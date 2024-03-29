import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class sendVideo extends StatefulWidget {
  XFile imagepath;
  sendVideo({super.key, required this.imagepath});

  @override
  State<sendVideo> createState() => _sendVideoState();
}

class _sendVideoState extends State<sendVideo> {
  VideoPlayerController? _controller;
  bool _isUploading = false;
  double _uploadProgress = 0;
  late Reference _storageReference;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.imagepath.path))
      ..initialize().then((_) {
        setState(() {});
      });
    _storageReference = FirebaseStorage.instance.ref().child('videos');    
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  Future<void> _stopRecordingAndUpload() async {
    // Stop the video recording
    await _controller!.pause();

    setState(() {
      _isUploading = true;
    });

    try {
      await _sendVideoStream();
      // Show upload success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Upload succeeded'),
          backgroundColor: Colors.green,
        ),
      );
      // Navigate back to camera_page.dart
      Navigator.pop(context);
    } catch (e) {
      print(e);
      // Show upload failure message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Upload failed'),
          backgroundColor: Colors.red,
        ),
      );
      // Navigate back to camera_page.dart
      Navigator.pop(context);
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _sendVideoStream() async {
    // Get the video file as bytes
    Uint8List bytes = await File(widget.imagepath.path).readAsBytes();
  
    // Upload the video bytes to Firebase Storage
    var postId = const Uuid().v1();
    UploadTask task = _storageReference.child('$postId.mp4').putData(bytes);
  
    // Track the upload progress
    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = snapshot.bytesTransferred / snapshot.totalBytes;
      setState(() {
        _uploadProgress = progress;
      });
    });
  
    // Wait for the upload to complete
    await task;
  
    // Get the download URL of the uploaded video
    String downloadUrl = await _storageReference.child('$postId.mp4').getDownloadURL();
  
    // Print the download URL
    print('Download URL: $downloadUrl');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CupertinoButton(
          child: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).bottomNavigationBarTheme.backgroundColor == Colors.white
                ? Colors.black
                : Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.crop,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.emoji_emotions,
                ),
              ),
            ],
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            ),
            if (_isUploading)
              Positioned(
                bottom: 20,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    '${(_uploadProgress * 100).toStringAsFixed(1)}% Uploaded',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            Center(
              child: InkWell(
                onTap: _stopRecordingAndUpload,
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.4),
                  radius: 24,
                  child: Center(
                    child: Icon(
                      _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
