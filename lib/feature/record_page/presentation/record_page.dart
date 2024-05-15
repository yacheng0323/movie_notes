import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  const RecordPage({super.key, this.recordData});

  final RecordData? recordData;

  @override
  RecordPageState createState() => RecordPageState();
}

class RecordPageState extends State<RecordPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final theaterController = TextEditingController();
  final contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    theaterController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette();
    final TextGetter textgetter = TextGetter(context);

    return ChangeNotifierProvider(
      create: (context) {
        final RecordPageProvider recordPageProvider = RecordPageProvider();

        WidgetsBinding.instance.addPostFrameCallback((_) {
          recordPageProvider.cleanState();
          if (widget.recordData != null) {
            titleController.text = widget.recordData!.title;
            theaterController.text = widget.recordData!.theater;
            contentController.text = widget.recordData!.content ?? "";

            recordPageProvider.setSelectedDateTime(
                DateTime.fromMillisecondsSinceEpoch(
                    widget.recordData!.datetime * 1000));
            recordPageProvider.setImageFromDB(widget.recordData!.imagepath);
            recordPageProvider.setRecordId(widget.recordData!);
          }
        });

        return recordPageProvider;
      },
      builder: (context, child) {
        return Consumer<RecordPageProvider>(
          builder: (context, recordPageProvider, child) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: palette.appBarColor,
                centerTitle: true,
                iconTheme: const IconThemeData(color: Colors.white),
                title: Text(
                  "電影記事本",
                  style: textgetter.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: palette.titleTextColor),
                ),
                actions: [
                  TextButton(
                      onPressed: () async {
                        //* 寫入DB
                        if (_formKey.currentState?.validate() == true) {
                          RecordData recordData = RecordData(
                              title: titleController.text,
                              datetime: recordPageProvider.selectedDateTime
                                      .millisecondsSinceEpoch ~/
                                  1000,
                              theater: theaterController.text,
                              content: contentController.text,
                              imagepath: recordPageProvider.databaseImagePath);

                          if (widget.recordData != null) {
                            await recordPageProvider.updateRecord(
                                record: recordData,
                                id: recordPageProvider.recordId ?? 0);
                          } else {
                            await recordPageProvider.addRecord(
                                record: recordData);
                          }

                          if (!context.mounted) return;
                          switch (recordPageProvider.status) {
                            case RecordPageStatus.addSuccess:
                              Navigator.pop(context, true);

                              ShowSnackBarHelper.successSnackBar(
                                      context: context)
                                  .showSnackbar("新增成功");
                            case RecordPageStatus.addFailed:
                              ShowSnackBarHelper.errorSnackBar(context: context)
                                  .showSnackbar("新增失敗");
                            case RecordPageStatus.updateSuccess:
                              Navigator.pop(context, true);

                              ShowSnackBarHelper.successSnackBar(
                                      context: context)
                                  .showSnackbar("更新紀錄成功");
                            case RecordPageStatus.updateFailed:
                              ShowSnackBarHelper.errorSnackBar(context: context)
                                  .showSnackbar("更新紀錄失敗");
                            default:
                          }
                        }
                      },
                      child: Text(
                        "完成",
                        style:
                            textgetter.bodyLarge?.copyWith(color: Colors.white),
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
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(200)
                          ],
                          decoration: const InputDecoration(hintText: "請輸入標題"),
                          validator: (value) {
                            return value?.isEmpty == true ? "還沒輸入標題喔！" : null;
                          },
                        ),
                        Row(
                          children: [
                            Text(
                              "時間",
                              style: textgetter.titleMedium
                                  ?.copyWith(color: Colors.black),
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
                                          recordPageProvider
                                              .setSelectedDateTime(date);
                                        },
                                        currentTime:
                                            recordPageProvider.selectedDateTime,
                                        locale: LocaleType.zh,
                                      );
                                    },
                                    child: Text(
                                      DateFormat("yyyy/MM/dd HH:mm").format(
                                          context
                                              .watch<RecordPageProvider>()
                                              .selectedDateTime),
                                    ))),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "劇院",
                              style: textgetter.titleMedium
                                  ?.copyWith(color: Colors.black),
                            ),
                            const Padding(padding: EdgeInsets.all(12)),
                            Expanded(
                                child: Container(
                              // height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextFormField(
                                controller: theaterController,
                                style: textgetter.bodyMedium,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(200)
                                ],
                                decoration: const InputDecoration(
                                  hintText: "請輸入劇院名稱",
                                  filled: true,
                                  fillColor: Color(0xffECECEC),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(12, 8, 8, 0),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                ),
                                validator: (value) {
                                  return value?.isEmpty == true
                                      ? "還沒輸入劇院名稱喔！"
                                      : null;
                                },
                              ),
                            )),
                          ],
                        ),
                        TextFormField(
                          controller: contentController,
                          minLines: 1,
                          maxLines: 100,
                          decoration: const InputDecoration(
                              hintText: "請輸入內容", border: InputBorder.none),
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
                                    child: const Text('從圖片庫'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      recordPageProvider.getImage(
                                          fromCamera: false);
                                    },
                                  ),
                                  CupertinoActionSheetAction(
                                    child: const Text('拍照'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      recordPageProvider.getImage(
                                          fromCamera: true);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: palette.selectImageBgColor,
                                  borderRadius: BorderRadius.circular(8)),
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    recordPageProvider.displayImagePath != null
                                        ? Image.file(
                                            File(recordPageProvider
                                                .displayImagePath!),
                                            fit: BoxFit.cover,
                                          )
                                        : Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                  "images/selectImageBg.png"),
                                              const Padding(
                                                  padding: EdgeInsets.all(3)),
                                              Text(
                                                "選擇圖片",
                                                style: textgetter.bodyLarge
                                                    ?.copyWith(
                                                        color: const Color(
                                                            0xffE6E6E6)),
                                              ),
                                            ],
                                          ),
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
          },
        );
      },
    );
  }
}
