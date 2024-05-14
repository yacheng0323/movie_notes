class RecordData {
  final String title;
  final int datetime;
  final String theater;
  final String? content;
  final String? imagepath;

  RecordData({
    required this.title,
    required this.datetime,
    required this.theater,
    this.content,
    this.imagepath,
  });

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "datetime": datetime,
      "theater": theater,
      "content": content,
      "imagepath": imagepath,
    };
  }

  factory RecordData.fromSqfliteDatabase(Map<String, dynamic> map) =>
      RecordData(
          title: map["title"],
          datetime: map["datetime"],
          theater: map["theater"],
          content: map["content"],
          imagepath: map["imagepath"]);
}
