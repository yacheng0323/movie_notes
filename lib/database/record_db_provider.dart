import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:movie_notes/database/record_db.dart';
import 'package:movie_notes/entities/record_data.dart';

class RecordDBProvider extends ChangeNotifier {
  final _recordDB = RecordDB();

  Future<List<RecordData>> fetchRecords() async {
    try {
      return await _recordDB.fetchAll();
    } catch (err, s) {
      throw Error.throwWithStackTrace(err, s);
    }
  }

  Future<void> addRecord(RecordData record) async {
    try {
      await _recordDB.create(
          title: record.title,
          datetime: record.datetime,
          content: record.content,
          theater: record.theater,
          imagefile: record.imagefile);
    } catch (err, s) {
      throw Error.throwWithStackTrace(err, s);
    }
  }

  Future<int?> getId(RecordData record) async {
    try {
      return await _recordDB.getId(record.title);
    } catch (err, s) {
      throw Error.throwWithStackTrace(err, s);
    }
  }

  Future<void> updateRecord(RecordData record, int id) async {
    Map<String, dynamic> item = record.toMap();

    try {
      await _recordDB.update(
          id: id,
          title: item["title"],
          datetime: item["datetime"],
          theater: item["theater"],
          content: item["content"],
          imagefile: item["imagefile"]);
    } catch (err, s) {
      throw Error.throwWithStackTrace(err, s);
    }
  }

  Future<void> deleteRecord(RecordData record, int id) async {
    try {
      await _recordDB.delete(id);
    } catch (err, s) {
      throw Error.throwWithStackTrace(err, s);
    }
  }
}
