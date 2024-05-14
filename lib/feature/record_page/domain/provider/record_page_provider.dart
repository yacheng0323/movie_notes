import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_notes/database/record_db_provider.dart';
import 'package:movie_notes/entities/record_data.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

RecordDBProvider recordDBProvider = RecordDBProvider();

class RecordPageProvider extends ChangeNotifier {
  RecordPageStatus status = RecordPageStatus.init;

  DateTime _selectedDateTime = DateTime.now();

  DateTime get selectedDateTime => _selectedDateTime;

  int? _recordId;

  int? get recordId => _recordId;

  String? _databaseImagePath;

  String? get databaseImagePath => _databaseImagePath;

  String? _displayImagePath;

  String? get displayImagePath => _displayImagePath;

  Future<void> addRecord({required RecordData record}) async {
    try {
      await recordDBProvider.addRecord(record);
      status = RecordPageStatus.addSuccess;
      notifyListeners();
    } catch (err) {
      status = RecordPageStatus.addFailed;
      notifyListeners();
    }
  }

  Future<void> updateRecord(
      {required RecordData record, required int id}) async {
    try {
      await recordDBProvider.updateRecord(record, id);
      status = RecordPageStatus.updateSuccess;
      notifyListeners();
    } catch (err) {
      status = RecordPageStatus.updateFailed;
      notifyListeners();
    }
  }

  void setSelectedDateTime(DateTime newDateTime) {
    _selectedDateTime = newDateTime;
    notifyListeners();
  }

  Future<void> getImage({required bool fromCamera}) async {
    final pickedFile = await ImagePicker().pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxWidth: 1280,
      maxHeight: 720,
    );

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      File? croppedImage = await cropImage(pickerImage: image);

      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String relativePath = '${DateTime.now().millisecondsSinceEpoch}.png';
      String imagepath;

      if (croppedImage != null) {
        imagepath = path.join(documentDirectory.path, relativePath);
        await croppedImage.copy(imagepath);
      } else {
        imagepath = path.join(documentDirectory.path, relativePath);
        await image.copy(imagepath);
      }

      _displayImagePath = imagepath;
      _databaseImagePath = relativePath;

      if (croppedImage != null) {
        log("croppedImage = ${croppedImage.lengthSync() / 1024} kb");
      } else {
        log("image = ${image.lengthSync() / 1024} kb");
      }

      notifyListeners();
    }
  }

  Future<File?> cropImage({required File pickerImage}) async {
    final cropped = await ImageCropper().cropImage(
        maxHeight: 720,
        maxWidth: 1280,
        sourcePath: pickerImage.path,
        aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
        aspectRatioPresets: [CropAspectRatioPreset.ratio16x9],
        cropStyle: CropStyle.rectangle,
        uiSettings: [
          IOSUiSettings(title: "Cropper", aspectRatioLockEnabled: true)
        ],
        compressQuality: 90);

    if (cropped != null) {
      return File(cropped.path);
    }
    return null;
  }

  Future<void> setImageFromDB(String? newImageFile) async {
    if (newImageFile != null) {
      _databaseImagePath = newImageFile;

      Directory documentDirectory = await getApplicationDocumentsDirectory();

      File imageFile =
          File(path.join(documentDirectory.path, _databaseImagePath));

      if (imageFile.existsSync()) {
        _displayImagePath = imageFile.path;
        notifyListeners();
      } else {
        log('圖片文件不存在');
      }
    } else {
      log('路徑為空');
    }
  }

  void cleanState() {
    _selectedDateTime = DateTime.now();
    _databaseImagePath = null;
    _displayImagePath = null;
    notifyListeners();
  }

  Future<void> setRecordId(RecordData record) async {
    _recordId = await recordDBProvider.getId(record);
    notifyListeners();
  }
}

enum RecordPageStatus {
  init,
  addSuccess,
  addFailed,
  updateSuccess,
  updateFailed
}
