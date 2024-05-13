import 'package:flutter/cupertino.dart';
import 'package:movie_notes/database/record_db_provider.dart';
import 'package:movie_notes/entities/record_data.dart';

RecordDBProvider recordDBProvider = RecordDBProvider();

class HomePageProvider extends ChangeNotifier {
  HomePageStatus status = HomePageStatus.init;

  List<RecordData> _records = [];

  List<RecordData> get records => _records;

  Future<void> fetchRecords() async {
    status = HomePageStatus.loading;
    notifyListeners();

    try {
      _records = await recordDBProvider.fetchRecords();

      status = HomePageStatus.showResult;

      notifyListeners();
    } catch (err) {
      status = HomePageStatus.failed;
      notifyListeners();
    }
  }

  Future<void> deleteData(RecordData data) async {
    int? id = await recordDBProvider.getId(data);

    if (id != null) {
      await recordDBProvider.deleteRecord(data, id);
    }

    _records = await recordDBProvider.fetchRecords();

    status = HomePageStatus.showResult;

    notifyListeners();
  }
}

enum HomePageStatus {
  init,
  loading,
  showResult,
  failed,
}
