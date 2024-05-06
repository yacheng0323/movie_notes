import 'package:flutter/material.dart';
import 'package:movie_notes/entities/record_data.dart';
// import 'package:movie_notes/provider/record_provider.dart';

class RecordProvider extends ChangeNotifier {
  RecordStatus _recordStatus = RecordStatus.init;

  RecordStatus get recordStatus => _recordStatus;

  RecordData? recordData;

  // String? title;

  // DateTime? dateTime;

  // String? theater;

  // String? content;

  // void getRecordData() async {
  //   title = title;
  //   theater = theater;
  //   content = content;
  //   notifyListeners();
  // }

  void modifyRecordData({
    required String title,
    required String theater,
    required String content,
  }) async {
    title = title;
    theater = theater;
    content = content;
    notifyListeners();
  }
}

enum RecordStatus {
  init,
  success,
  failed,
}
