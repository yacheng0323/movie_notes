class RecordData {
  final String title;
  final int datetime;
  final String theater;
  final String? content;
  final String? imagefile;

  RecordData({
    required this.title,
    required this.datetime,
    required this.theater,
    this.content,
    this.imagefile,
  });

  factory RecordData.fromSqfliteDatabase(Map<String, dynamic> map) =>
      RecordData(
          title: map["title"],
          datetime: map["datetime"],
          theater: map["theater"],
          content: map["content"],
          imagefile: map["imagefile"]);
}
