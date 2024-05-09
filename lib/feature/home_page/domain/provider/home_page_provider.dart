import 'package:flutter/cupertino.dart';
import 'package:movie_notes/database/record_db.dart';
import 'package:movie_notes/database/record_db_provider.dart';
import 'package:movie_notes/entities/record_data.dart';
import 'package:provider/provider.dart';

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

  // Future<void> deleteData(RecordData data) async {
  // final id =
  // await _ref.watch(recordDBProvider).insertData({"title": data.title});
  // await _ref.watch(recordDBProvider).delete(id);
  // }
}

enum HomePageStatus {
  init,
  loading,
  showResult,
  failed,
}
