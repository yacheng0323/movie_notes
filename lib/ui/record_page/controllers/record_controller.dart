import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_notes/database/record_db.dart';
import 'package:movie_notes/entities/record_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

final recordProvider =
    StateNotifierProvider<RecordController, AsyncValue<RecordData>>((ref) {
  return RecordController(ref);
});

final dateTimeProvider = StateProvider<DateTime>((ref) => DateTime.now());

class RecordController extends StateNotifier<AsyncValue<RecordData>> {
  final Ref _ref;

  RecordController(this._ref) : super(const AsyncValue.loading());

  Future<void> fetchRecord({bool isRefreshing = false, String? title}) async {
    if (isRefreshing) state = const AsyncValue.loading();
    try {
      int id = await _ref.read(recordDBProvider).insertData({"title": title});
      final item = await _ref.read(recordDBProvider).fetchById(id);
      if (mounted) {
        state = AsyncValue.data(item);
      }
    } catch (err, s) {
      state = AsyncValue.error(err, s);
    }
  }

  Future<void> addRecord({required RecordData record}) async {
    try {
      await _ref.read(recordDBProvider).create(
          title: record.title,
          datetime: record.datetime + 28800,
          theater: record.theater,
          content: record.content,
          imagepath: record.imagePath);
      state.whenData((value) {
        state = AsyncValue.data(value);
      });
    } catch (err, s) {
      state = AsyncValue.error(err, s);
    }
  }

  Future<void> updateRecord({required RecordData record}) async {
    try {
      int id =
          await _ref.read(recordDBProvider).insertData({"title": record.title});
      await _ref.read(recordDBProvider).update(
          id: id,
          title: record.title,
          datetime: record.datetime,
          theater: record.theater,
          content: record.content,
          imagepath: record.imagePath);
      state.whenData((value) {
        state = AsyncValue.data(value);
      });
    } catch (err, s) {
      state = AsyncValue.error(err, s);
    }
  }
}

enum RecordStatus {
  init,
  success,
  failed,
}
