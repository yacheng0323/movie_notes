import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_notes/database/record_db.dart';
import 'package:movie_notes/ui/record_page/provider/record_provider.dart';
import 'package:movie_notes/utils/palette.dart';
import 'package:movie_notes/utils/text_getter.dart';
import 'package:provider/provider.dart';

@RoutePage()
class RecordPage extends ConsumerStatefulWidget {
  const RecordPage({super.key});

  @override
  ConsumerState<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends ConsumerState<RecordPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final theaterController = TextEditingController();
  final contentController = TextEditingController();

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
    // context.read<RecordProvider>().getRecordData(title: title, theater: theater, content: content);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final textGetter = context.watch<TextGetter>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: palette.appBarColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "新增備忘錄",
          style: textGetter.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700, color: palette.titleTextColor),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                // TODO: 記得寫入DB
                // if (_formKey.currentState?.validate() == true) {}
                final ss = await RecordDB().fetchAll();
                print(ss[0].theater);
                // print(ss[0].);
              },
              child: Text(
                "完成",
                style: textGetter.bodyLarge?.copyWith(color: Colors.white),
              )),
          IconButton(
              onPressed: () async {
                await RecordDB().deleteAll();
                // await RecordDB().create(
                //     title: "蜘蛛人2",
                //     datetime: DateTime.utc(
                //           2024,
                //           3,
                //           24,
                //         ).millisecondsSinceEpoch ~/
                //         1000,
                //     theater: "比漾廣場的4f",
                //     content: "輸入測試",
                //     filename: "????");
                // await RecordDB().update(
                //     id: 1,
                //     theater: "比漾廣場5樓拉",
                //     title: '蜘蛛人2',
                //     content: "",
                //     datetime: DateTime.utc(
                //           2024,
                //           3,
                //           24,
                //         ).millisecondsSinceEpoch ~/
                //         1000);
              },
              icon: Icon(Icons.add)),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Form(
            key: _formKey,
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
                              DatePicker.showDatePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime(2000, 1, 1),
                                maxTime: DateTime(2034, 1, 1),
                                onChanged: (date) {
                                  print("change $date");
                                },
                                onConfirm: (date) {
                                  print("confirm $date");
                                },
                                currentTime: DateTime.now(),
                                locale: LocaleType.zh,
                              );
                            },
                            child: Text("${DateTime.now()}")),
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
                      Padding(padding: EdgeInsets.all(4)),
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
                              // close the options modal
                              Navigator.of(context).pop();
                              // get image from gallery
                              getImageFromGallery();
                            },
                          ),
                          CupertinoActionSheetAction(
                            child: Text('拍照'),
                            onPressed: () {
                              // close the options modal
                              Navigator.of(context).pop();
                              // get image from camera
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
                      // 使用 ClipRRect 包裹 Image
                      borderRadius:
                          BorderRadius.circular(8), // 设置相同的 BorderRadius
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
