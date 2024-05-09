import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_notes/database/record_db_provider.dart';
import 'package:movie_notes/entities/record_data.dart';
import 'package:movie_notes/utils/image_usecase.dart';

RecordDBProvider recordDBProvider = RecordDBProvider();

class RecordPageProvider extends ChangeNotifier {
  RecordPageStatus status = RecordPageStatus.init;

  DateTime _selectedDateTime = DateTime.now();

  DateTime get selectedDateTime => _selectedDateTime;

  String? _imageFile;

  String? get imageFile => _imageFile;

  int? _recordId;

  int? get recordId => _recordId;

  Future<void> addRecord({required RecordData record}) async {
    try {
      await recordDBProvider.addRecord(record);
      status = RecordPageStatus.addSuccess;
      notifyListeners();
    } catch (err, s) {
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
    } catch (err, s) {
      status = RecordPageStatus.updateFailed;
      notifyListeners();
    }
  }

  void setSelectedDateTime(DateTime newDateTime) {
    _selectedDateTime = newDateTime;
    notifyListeners();
  }

  Future<void> getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      _imageFile = ImageUsecase().imageToBase64(image);
      notifyListeners();
    }
  }

  Future<void> getImageFromCamera() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      File image = File(pickedFile.path);
      _imageFile = ImageUsecase().imageToBase64(image);
      notifyListeners();
    }
  }

  Future<void> setImageFromDB(String? newImageFile) async {
    _imageFile = newImageFile;
    notifyListeners();
  }

  void cleanState() {
    _selectedDateTime = DateTime.now();
    _imageFile = null;
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
