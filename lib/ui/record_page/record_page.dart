import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:movie_notes/database/record_db.dart';
import 'package:movie_notes/entities/record_data.dart';
import 'package:movie_notes/ui/record_page/controllers/record_controller.dart';
import 'package:movie_notes/utils/palette.dart';
import 'package:movie_notes/utils/text_getter.dart';
import 'package:provider/provider.dart';

@RoutePage()
class RecordPage extends ConsumerStatefulWidget {
  const RecordPage({super.key, this.recordData});

  final RecordData? recordData;

  @override
  ConsumerState<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends ConsumerState<RecordPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final theaterController = TextEditingController();
  final contentController = TextEditingController();
  DateTime? dateTime;

  File? _image;
  final picker = ImagePicker();

//Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(_image);
      }
    });
  }

//Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  @override
  void initState() {
    if (widget.recordData != null) {
      titleController.text = widget.recordData!.title;
      theaterController.text = widget.recordData!.theater;
      contentController.text = widget.recordData!.content ?? "";
      dateTime = DateTime.fromMillisecondsSinceEpoch(
          widget.recordData!.datetime * 1000);
      _image = File(widget.recordData!.imagePath ?? "");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final palette = ref.watch<Palette>(paletteProvider);
    final textGetter = ref.watch<TextGetter>(textGetterProvider);
    final ddd = ref.read(recordProvider.notifier);
    final sss = ref.watch(recordDBProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: palette.appBarColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "電影記事本",
          style: textGetter.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700, color: palette.titleTextColor),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                // TODO: 記得寫入DB
                if (_formKey.currentState?.validate() == true) {
                  RecordData recordData = RecordData(
                      title: titleController.text,
                      datetime:
                          ref.watch(dateTimeProvider).millisecondsSinceEpoch ~/
                              1000,
                      theater: theaterController.text,
                      content: contentController.text,
                      imagePath: _image?.path);
                  await ddd.addRecord(record: recordData);
                }
              },
              child: Text(
                "完成",
                style: textGetter.bodyLarge?.copyWith(color: Colors.white),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                Container(
                  child: TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(hintText: "請輸入標題"),
                    validator: (value) {
                      return value?.isEmpty == true ? "還沒輸入標題喔！" : null;
                    },
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Text(
                        "時間",
                        style:
                            textGetter.bodyLarge?.copyWith(color: Colors.black),
                      ),
                      Expanded(
                        child: TextButton(
                            onPressed: () {
                              DatePicker.showDateTimePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime(2000, 1, 1),
                                maxTime: DateTime(2034, 1, 1),
                                onChanged: (date) {
                                  print("change $date");
                                },
                                onConfirm: (date) {
                                  ref.read(dateTimeProvider.notifier).state =
                                      date;
                                },
                                currentTime: DateTime.now(),
                                locale: LocaleType.zh,
                              );
                            },
                            child: Text(
                                "${DateFormat("yyyy/MM/dd HH:mm").format(ref.watch(dateTimeProvider))}")),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Text(
                        "劇院",
                        style:
                            textGetter.bodyLarge?.copyWith(color: Colors.black),
                      ),
                      const Padding(padding: EdgeInsets.all(12)),
                      Expanded(
                          child: TextFormField(
                        controller: theaterController,
                        decoration: InputDecoration(hintText: "請輸入劇院名稱"),
                        validator: (value) {
                          return value?.isEmpty == true ? "還沒輸入劇院名稱喔！" : null;
                        },
                      )),
                    ],
                  ),
                ),
                Container(
                    child: TextFormField(
                  controller: contentController,
                  minLines: 1,
                  maxLines: 100,
                  decoration:
                      InputDecoration(hintText: "內容", border: InputBorder.none),
                )),
                Padding(padding: EdgeInsets.all(4)),
                GestureDetector(
                  onTap: () async {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                        title: Text("請選擇上傳方式"),
                        actions: [
                          CupertinoActionSheetAction(
                            child: Text('相簿'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              getImageFromGallery();
                            },
                          ),
                          CupertinoActionSheetAction(
                            child: Text('拍照'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              getImageFromCamera();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: palette.selectImageBgColor,
                        borderRadius: BorderRadius.circular(8)),
                    width: MediaQuery.of(context).size.width,
                    height: 220,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: _image != null
                          ? Image.file(
                              _image!,
                              fit: BoxFit.cover,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("images/selectImageBg.png"),
                                const Padding(padding: EdgeInsets.all(3)),
                                Text(
                                  "選擇圖片",
                                  style: textGetter.bodyLarge
                                      ?.copyWith(color: Color(0xffE6E6E6)),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
