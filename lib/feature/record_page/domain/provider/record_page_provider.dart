import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_notes/database/record_db_provider.dart';
import 'package:movie_notes/entities/record_data.dart';
import 'package:path_provider/path_provider.dart';

RecordDBProvider recordDBProvider = RecordDBProvider();

class RecordPageProvider extends ChangeNotifier {
  RecordPageStatus status = RecordPageStatus.init;

  DateTime _selectedDateTime = DateTime.now();

  DateTime get selectedDateTime => _selectedDateTime;

  int? _recordId;

  int? get recordId => _recordId;

  String? _imagePath;

  String? get imagePath => _imagePath;

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
        maxHeight: 720);

    if (pickedFile != null) {
      File image = File(pickedFile.path);

      File? croppedImage = await cropImage(pickerImage: image);

      Directory documentDirectory = await getApplicationDocumentsDirectory();

      String imagePath =
          '${documentDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.png';

      if (croppedImage != null) {
        await croppedImage.copy(imagePath);

        _imagePath = imagePath;

        log("croppedImage = ${croppedImage.lengthSync() / 1024} kb");

        notifyListeners();
      } else {
        await image.copy(imagePath);

        _imagePath = imagePath;
        log("image = ${image.lengthSync() / 1024} kb");

        notifyListeners();
      }
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
      _imagePath = newImageFile;

      File imageFile = File(_imagePath!);

      if (imageFile.existsSync()) {
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
    _imagePath = null;
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
