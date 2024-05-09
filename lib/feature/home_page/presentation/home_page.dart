import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:movie_notes/core/router/app_router.gr.dart';
import 'package:movie_notes/feature/home_page/domain/provider/home_page_provider.dart';
import 'package:movie_notes/feature/record_page/domain/provider/record_page_provider.dart';
import 'package:movie_notes/utils/palette.dart';
import 'package:movie_notes/utils/text_getter.dart';
import 'package:provider/provider.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final HomePageProvider homePageProvider;

  @override
  void initState() {
    super.initState();
    homePageProvider = Provider.of<HomePageProvider>(context, listen: false);
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      homePageProvider.fetchRecords();
    });
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();
    final textgetter = context.watch<TextGetter>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: palette.appBarColor,
        title: Text(
          "電影記事本",
          style: textgetter.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700, color: palette.titleTextColor),
        ),
        actions: [
          IconButton(
              onPressed: () {
                AutoRouter.of(context).push(RecordPageRoute(recordData: null));
                context.read<RecordPageProvider>().cleanState();
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 32,
              ))
        ],
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Consumer<HomePageProvider>(
            builder: (context, provider, child) {
              final items = provider.records;
              Widget widget;
              switch (provider.status) {
                case HomePageStatus.init:
                  widget = const SizedBox.shrink();
                  break;

                case HomePageStatus.showResult:
                  widget = Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    child: SearchAnchor(
                        viewShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        isFullScreen: false,
                        viewElevation: 0,
                        builder: (context, controller) {
                          return SearchBar(
                            controller: controller,
                            constraints: const BoxConstraints(minHeight: 40),
                            hintText: "搜尋",
                            hintStyle: MaterialStatePropertyAll(
                                textgetter.bodyLarge?.copyWith(
                                    color: const Color(0xffAAAAAA),
                                    fontSize: 18)),
                            leading: const Icon(
                              Icons.search,
                              color: Color(0xffAAAAAA),
                              size: 24,
                            ),
                            elevation: const MaterialStatePropertyAll(0),
                            backgroundColor: MaterialStatePropertyAll(
                                palette.searchBarColor),
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8))),
                            padding: const MaterialStatePropertyAll<EdgeInsets>(
                              EdgeInsets.fromLTRB(12, 0, 0, 0),
                            ),
                            onTap: () async {
                              controller.openView();
                            },
                            onChanged: (value) {
                              controller.openView();
                            },
                          );
                        },
                        suggestionsBuilder: (context, controller) async {
                          return [
                            items.isEmpty
                                ? Container(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                        color: Colors.white),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              55, 32, 55, 40),
                                          child: const Image(
                                            image: AssetImage(
                                                "images/records_empty.png"),
                                          ),
                                        ),
                                        Text("電影等待中...",
                                            style: textgetter.headlineSmall
                                                ?.copyWith(
                                                    color: Color(0xffAAAAAA))),
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return Dismissible(
                                        onDismissed: (direction) {
                                          //* 刪除後要執行？
                                        },
                                        key: UniqueKey(),
                                        child: ListTile(
                                          hoverColor: Colors.white,
                                          title: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 4, 0, 4),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      3,
                                                  child: Text(
                                                    items[index].title,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: textgetter
                                                        .titleMedium
                                                        ?.copyWith(
                                                            color: Color(
                                                                0xff2E2E2E),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Text(
                                                  items[index].theater,
                                                  style: textgetter.bodyMedium
                                                      ?.copyWith(
                                                          color: Color(
                                                              0xffAAAAAA)),
                                                )
                                              ],
                                            ),
                                          ),
                                          subtitle: Row(
                                            children: [
                                              Text(
                                                "${DateFormat("yyyy/MM/dd HH:mm").format(DateTime.fromMillisecondsSinceEpoch(items[index].datetime * 1000))}",
                                                style: textgetter.bodyMedium
                                                    ?.copyWith(
                                                        color:
                                                            Color(0xffAAAAAA)),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  (items[index].content ?? "")
                                                      .replaceAll('\n', ''),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: textgetter.bodyMedium
                                                      ?.copyWith(
                                                          color: Color(
                                                              0xffAAAAAA)),
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
                                            controller.closeView("");
                                            context
                                                .read<RecordPageProvider>()
                                                .cleanState();

                                            AutoRouter.of(context).push(
                                                RecordPageRoute(
                                                    recordData: items[index]));
                                          },
                                        ),
                                      );
                                    },
                                    itemCount: items.length,
                                  )
                          ];
                        }),
                  );
                  break;
                case HomePageStatus.loading:
                  widget = Align(
                    alignment: Alignment.center,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(24, 0, 24, 0),
                      height: 80,
                      padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const LinearProgressIndicator(),
                          const Padding(padding: EdgeInsets.all(4)),
                          Text(
                            "載入中...",
                            style: textgetter.bodyLarge
                                ?.copyWith(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  );

                  break;

                case HomePageStatus.failed:
                  widget = RefreshIndicator(
                      onRefresh: () async {
                        provider.fetchRecords();
                      },
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2,
                          child: Center(
                            child: Text("獲取資料失敗"),
                          ),
                        ),
                      ));
                  break;

                default:
                  widget = Container();
                  break;
              }
              return widget;
            },
          )
        ],
      ),
    );
  }
}
