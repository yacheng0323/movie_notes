import 'dart:convert';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:movie_notes/entities/record_data.dart';
import 'package:movie_notes/feature/home_page/domain/provider/home_page_provider.dart';
import 'package:movie_notes/feature/record_page/domain/provider/record_page_provider.dart';
import 'package:movie_notes/utils/palette.dart';
import 'package:movie_notes/utils/show_snack_bar.dart';
import 'package:movie_notes/utils/text_getter.dart';
import 'package:provider/provider.dart';

@RoutePage()
class RecordPage extends StatefulWidget {
  const RecordPage({Key? key, this.recordData}) : super(key: key);

  final RecordData? recordData;

  @override
  _RecordPageState createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final theaterController = TextEditingController();
  final contentController = TextEditingController();
  late RecordPageProvider recordPageProvider;

  @override
  void initState() {
    recordPageProvider = context.read<RecordPageProvider>();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      if (widget.recordData != null) {
        titleController.text = widget.recordData!.title;
        theaterController.text = widget.recordData!.theater;
        contentController.text = widget.recordData!.content ?? "";

        recordPageProvider.setSelectedDateTime(
            DateTime.fromMillisecondsSinceEpoch(
                widget.recordData!.datetime * 1000));
        recordPageProvider.setImageFromDB(widget.recordData!.imagefile);
        recordPageProvider.setRecordId(widget.recordData!);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final textgetter = context.watch<TextGetter>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: palette.appBarColor,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "電影記事本",
          style: textgetter.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700, color: palette.titleTextColor),
        ),
        actions: [
          TextButton(
              onPressed: () async {
                //* 寫入DB
                if (_formKey.currentState?.validate() == true) {
                  RecordData recordData = RecordData(
                      title: titleController.text,
                      datetime: recordPageProvider
                              .selectedDateTime.millisecondsSinceEpoch ~/
                          1000,
                      theater: theaterController.text,
                      content: contentController.text,
                      imagefile: recordPageProvider.imageFile);
                  if (widget.recordData != null) {
                    recordPageProvider.updateRecord(
                        record: recordData,
                        id: recordPageProvider.recordId ?? 0);
                  } else {
                    recordPageProvider.addRecord(record: recordData);
                  }

                  switch (recordPageProvider.status) {
                    case RecordPageStatus.addSuccess:
                      ShowSnackBarHelper.successSnackBar(context: context)
                          .showSnackbar("新增成功");
                    case RecordPageStatus.addFailed:
                      ShowSnackBarHelper.errorSnackBar(context: context)
                          .showSnackbar("新增失敗");
                    case RecordPageStatus.updateSuccess:
                      ShowSnackBarHelper.successSnackBar(context: context)
                          .showSnackbar("更新紀錄成功");
                    case RecordPageStatus.updateFailed:
                      ShowSnackBarHelper.errorSnackBar(context: context)
                          .showSnackbar("更新紀錄失敗");
                    default:
                  }

                  Navigator.pop(context);
                  await context.read<HomePageProvider>().fetchRecords();
                }
              },
              child: Text(
                "完成",
                style: textgetter.bodyLarge?.copyWith(color: Colors.white),
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: "請輸入標題"),
                  validator: (value) {
                    return value?.isEmpty == true ? "還沒輸入標題喔！" : null;
                  },
                ),
                Row(
                  children: [
                    Text(
                      "時間",
                      style:
                          textgetter.bodyLarge?.copyWith(color: Colors.black),
                    ),
                    Expanded(
                        child: TextButton(
                            onPressed: () {
                              DatePicker.showDateTimePicker(
                                context,
                                showTitleActions: true,
                                minTime: DateTime(2000, 1, 1),
                                maxTime: DateTime(2034, 1, 1),
                                onConfirm: (date) {
                                  recordPageProvider.setSelectedDateTime(date);
                                },
                                currentTime:
                                    recordPageProvider.selectedDateTime,
                                locale: LocaleType.zh,
                              );
                            },
                            child: Text(
                              DateFormat("yyyy/MM/dd HH:mm").format(context
                                  .watch<RecordPageProvider>()
                                  .selectedDateTime),
                            ))),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "劇院",
                      style:
                          textgetter.bodyLarge?.copyWith(color: Colors.black),
                    ),
                    const Padding(padding: EdgeInsets.all(12)),
                    Expanded(
                        child: TextFormField(
                      controller: theaterController,
                      decoration: const InputDecoration(hintText: "請輸入劇院名稱"),
                      validator: (value) {
                        return value?.isEmpty == true ? "還沒輸入劇院名稱喔！" : null;
                      },
                    )),
                  ],
                ),
                TextFormField(
                  controller: contentController,
                  minLines: 1,
                  maxLines: 100,
                  decoration: const InputDecoration(
                      hintText: "內容", border: InputBorder.none),
                ),
                const Padding(padding: EdgeInsets.all(4)),
                GestureDetector(
                  onTap: () async {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                        title: const Text("請選擇上傳方式"),
                        actions: [
                          CupertinoActionSheetAction(
                            child: const Text('相簿'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              context
                                  .read<RecordPageProvider>()
                                  .getImageFromGallery();
                            },
                          ),
                          CupertinoActionSheetAction(
                            child: const Text('拍照'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              context
                                  .read<RecordPageProvider>()
                                  .getImageFromCamera();
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
                      child: recordPageProvider.imageFile != null
                          ? Image.memory(
                              base64Decode(context
                                      .watch<RecordPageProvider>()
                                      .imageFile ??
                                  ""),
                              gaplessPlayback: true,
                              fit: BoxFit.cover,
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset("images/selectImageBg.png"),
                                const Padding(padding: EdgeInsets.all(3)),
                                Text(
                                  "選擇圖片",
                                  style: textgetter.bodyLarge
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
