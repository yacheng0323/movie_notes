import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_notes/database/record_db.dart';
import 'package:movie_notes/entities/record_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final homePageProvider =
    StateNotifierProvider<HomePageController, AsyncValue<List<RecordData>>>(
        (ref) {
  return HomePageController(ref);
});

final class HomePageController
    extends StateNotifier<AsyncValue<List<RecordData>>> {
  final Ref _ref;

  HomePageController(this._ref) : super(const AsyncValue.loading()) {
    fetctRecords();
  }

  Future<void> fetctRecords({bool isRefreshing = false}) async {
    if (isRefreshing) state = const AsyncValue.loading();
    try {
      final item = await _ref.read(recordDBProvider).fetchAll();
      if (mounted) {
        state = AsyncValue.data(item);
      }
    } catch (err, s) {
      state = AsyncValue.error(err, s);
    }
  }
}

enum HomePageStatus {
  init,
  showResult,
}
