import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:movie_notes/entities/record_data.dart';
import 'package:movie_notes/routes/app_router.gr.dart';
import 'package:movie_notes/ui/home_page/controllers/home_controller.dart';
import 'package:movie_notes/ui/record_page/record_page.dart';
import 'package:movie_notes/utils/palette.dart';
import 'package:movie_notes/utils/text_getter.dart';
import 'package:provider/provider.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final palette = ref.watch(paletteProvider);
    final textGetter = ref.watch(textGetterProvider);
    final items = ref.watch(homePageProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: palette.appBarColor,
        title: Text(
          "電影記事本",
          style: textGetter.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700, color: palette.titleTextColor),
        ),
        actions: [
          IconButton(
              onPressed: () {
                AutoRouter.of(context).push(RecordPageRoute(recordData: null));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 32,
              ))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SearchAnchor(
                viewShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                isFullScreen: false,
                viewElevation: 0,
                builder: (context, controller) {
                  return SearchBar(
                    controller: controller,
                    constraints: BoxConstraints(minHeight: 40),
                    hintText: "搜尋",
                    hintStyle: MaterialStatePropertyAll(textGetter.bodyLarge
                        ?.copyWith(color: Color(0xffAAAAAA), fontSize: 18)),
                    leading: Icon(
                      Icons.search,
                      color: Color(0xffAAAAAA),
                      size: 24,
                    ),
                    elevation: MaterialStatePropertyAll(0),
                    backgroundColor:
                        MaterialStatePropertyAll(palette.searchBarColor),
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                    padding: const MaterialStatePropertyAll<EdgeInsets>(
                      EdgeInsets.fromLTRB(12, 0, 0, 0),
                    ),
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (value) {
                      controller.openView();
                    },
                  );
                },
                // viewBackgroundColor: Colors.white.withOpacity(0),
                suggestionsBuilder: (context, controller) async {
                  return [
                    items.when(data: (records) {
                      List<RecordData> recordList = records;
                      return recordList.isEmpty
                          ? Container(
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.fromLTRB(55, 32, 55, 40),
                                    child: Image(
                                      image: AssetImage(
                                          "images/records_empty.png"),
                                    ),
                                  ),
                                  // Padding(padding: EdgeInsets.all(40)),
                                  Text("電影等待中...",
                                      style: textGetter.headlineSmall
                                          ?.copyWith(color: Color(0xffAAAAAA))),
                                  // Padding(padding: EdgeInsets.all(20))
                                ],
                              ),
                            )
                          : ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  hoverColor: Colors.white,
                                  title: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 4, 0, 4),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                          child: Text(
                                            recordList[index].title,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: textGetter.titleMedium
                                                ?.copyWith(
                                                    color: Color(0xff2E2E2E),
                                                    fontWeight:
                                                        FontWeight.w700),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          recordList[index].theater,
                                          style: textGetter.bodyMedium
                                              ?.copyWith(
                                                  color: Color(0xffAAAAAA)),
                                        )
                                      ],
                                    ),
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Text(
                                        "${DateFormat("yyyy/MM/dd HH:mm").format(DateTime.fromMillisecondsSinceEpoch(recordList[index].datetime * 1000))}",
                                        style: textGetter.bodyMedium?.copyWith(
                                            color: Color(0xffAAAAAA)),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Text(
                                          (recordList[index].content ?? "")
                                              .replaceAll('\n', ''),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: textGetter.bodyMedium
                                              ?.copyWith(
                                                  color: Color(0xffAAAAAA)),
                                        ),
                                      ),
                                      const Icon(
                                        Symbols.edit_square_rounded,
                                        size: 20,
                                        color: Color(0xff7C27D1),
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    AutoRouter.of(context).push(RecordPageRoute(
                                        recordData: recordList[index]));
                                  },
                                );
                              },
                              itemCount: recordList.length,
                            );
                    }, error: (error, stackTrace) {
                      return Text("錯誤");
                    }, loading: () {
                      return const CircularProgressIndicator();
                    }),
                  ];
                })
          ],
        ),
      ),
    );
  }
}
