import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:movie_notes/utils/palette.dart';
import 'package:movie_notes/utils/text_getter.dart';
import 'package:provider/provider.dart';

@RoutePage()
class RecordPage extends StatefulWidget {
  const RecordPage({super.key});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final textGetter = context.watch<TextGetter>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: palette.appBarColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "新增備忘錄",
          style: textGetter.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700, color: palette.titleTextColor),
        ),
        actions: [
          TextButton(
              onPressed: () {},
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
            child: Column(
              children: [
                Container(
                  child: TextFormField(),
                ),
                Container(
                  child: Text("時間"),
                ),
                Container(
                  child: Text("劇院"),
                ),
                Container(
                  child: Text("照片"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
