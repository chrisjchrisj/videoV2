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
  sendVideo({Key? key, required this.imagepath}) : super(key: key);

  @override
  State<sendVideo> createState() => _sendVideoState();
}

class _sendVideoState extends State<sendVideo> {
  VideoPlayerController? _controller;
  UploadTask? task;
  bool _isUploading = false;
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

  Future<void> _uploadVideo() async {
    setState(() {
      _isUploading = true;
    });

    try {
      await _sendVideoStream();
      // Show upload success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload succeeded'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print(e);
      // Show upload failure message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _sendVideoStream() async {
    // Start streaming the video
    await _controller!.play();

    // Get the video file as bytes
    Uint8List bytes = await File(widget.imagepath.path).readAsBytes();

    // Upload the video bytes to Firebase Storage
    var postId = Uuid().v1();
    TaskSnapshot snapshot = await _storageReference.child('$postId.mp4').putData(bytes);

    // Get the download URL of the uploaded video
    String downloadUrl = await snapshot.ref.getDownloadURL();

    // Print the download URL
    print('Download URL: $downloadUrl');

    // Stop playing the video
    await _controller!.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _isUploading
          ? CircularProgressIndicator()
          : FloatingActionButton.extended(
              onPressed: _uploadVideo,
              label: Text('Upload'),
            ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
                icon: Icon(
                  Icons.crop,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
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
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: InkWell(
                onTap: () {
                  if (_controller!.value.isPlaying) {
                    setState(() {
                      _controller!.pause();
                    });
                  } else {
                    setState(() {
                      _controller!.play();
                    });
                  }
                },
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
