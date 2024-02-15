import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';

Future<String> selectUploadFileTask(
  String pathDir,
  String uploadPlusName,
  bool webBool,
) async {
  // Add your function code here!

  if (webBool == false) {
    var result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final fileName = basename(result.files.single.path!);
      final newPath = '$tempPath/$fileName';

      File(result.files.single.path!).copy(newPath);

      File file = File(newPath);

      FirebaseStorage storage = FirebaseStorage.instance;
      String fileNameAnd = basename(file.path);
      String newFileNameAnd = '$uploadPlusName-$fileNameAnd';
      Reference storageReference =
          storage.ref().child('$pathDir/$newFileNameAnd');

      UploadTask task = storageReference.putFile(file);

      task.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        int percentage = (progress * 100).round();
        int updatedProgress =
            percentage > 100 ? FFAppState().task + 7 : percentage;
        int hungredProgress = updatedProgress > 100 ? 99 : updatedProgress;
        FFAppState().update(() {
          FFAppState().task =
              hungredProgress; // AppState name "task". If necessary, replace with your name
        });
      });

      await task;

      String downloadURL = await storageReference.getDownloadURL();

      FFAppState().update(() {
        FFAppState().task = 100;    // AppState name "task". If necessary, replace with your name
      });
      File fileToDelete = File(newPath);
      await fileToDelete.delete();

      return downloadURL;
    } else {
      return "File not selected";
    }
  } else {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      final PlatformFile file = result.files.first;

      Uint8List fileBytes = file.bytes!;

      FirebaseStorage storage = FirebaseStorage.instance;

      String fileNameWeb = file.name!;
      String newFileNameWeb = '$uploadPlusName-$fileNameWeb';
      Reference storageReference =
          storage.ref().child('$pathDir/$newFileNameWeb');

      UploadTask task = storageReference.putData(fileBytes);

      task.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        int percentage = (progress * 100).round();
        int updatedProgress =
            percentage > 100 ? FFAppState().task + 7 : percentage;
        int hungredProgress = updatedProgress > 100 ? 99 : updatedProgress;
        FFAppState().update(() {
          FFAppState().task = hungredProgress;   // AppState name "task". If necessary, replace with your name
        });
      });

      await task;

      String downloadURL = await storageReference.getDownloadURL();

      FFAppState().update(() {
        FFAppState().task = 100;    // AppState name "task". If necessary, replace with your name
      });

      return downloadURL;
    } else {
      return "File not selected";
    }
  }
}








