import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:movie_notes/core/router/app_router.gr.dart';
import 'package:movie_notes/entities/record_data.dart';
import 'package:movie_notes/feature/home_page/domain/provider/home_page_provider.dart';
import 'package:movie_notes/utils/palette.dart';
import 'package:movie_notes/utils/text_getter.dart';
import 'package:provider/provider.dart';
import 'package:searchable_listview/searchable_listview.dart';

@RoutePage()
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette();
    final TextGetter textgetter = TextGetter(context);

    return ChangeNotifierProvider(
      create: (context) {
        final homePageProvider = HomePageProvider();

        homePageProvider.fetchRecords();
        return homePageProvider;
      },
      builder: (context, child) {
        return Consumer<HomePageProvider>(
          builder: (context, provider, child) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: palette.appBarColor,
                title: Text(
                  "Movie Notes",
                  style: textgetter.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: palette.titleTextColor),
                ),
                actions: [
                  IconButton(
                      onPressed: () {
                        AutoRouter.of(context)
                            .push(RecordPageRoute(recordData: null))
                            .then((value) {
                          if (value == true) provider.fetchRecords();
                        });
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
                    builder: (context, homePageProvider, child) {
                      Widget widget;
                      switch (homePageProvider.status) {
                        case HomePageStatus.init:
                          widget = const SizedBox.shrink();
                          break;

                        case HomePageStatus.showResult:
                          widget = Padding(
                              padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                              child: SearchableList<RecordData>.sliver(
                                initialList: homePageProvider.records,
                                displayClearIcon: false,
                                itemBuilder: (RecordData record) {
                                  final index =
                                      homePageProvider.records.indexOf(record);
                                  BorderRadiusGeometry borderRadius =
                                      BorderRadius.zero;

                                  if (homePageProvider.records.length == 1) {
                                    borderRadius = const BorderRadius.all(
                                        Radius.circular(8));
                                  } else if (index == 0) {
                                    borderRadius = const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8),
                                    );
                                  } else if (index ==
                                      homePageProvider.records.length - 1) {
                                    borderRadius = const BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                      bottomRight: Radius.circular(8),
                                    );
                                  }

                                  return Dismissible(
                                    confirmDismiss: (direction) async {
                                      return await showCupertinoDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CupertinoAlertDialog(
                                            title:
                                                const Text("Confirm deletion?"),
                                            content: const Text(
                                                "Are you sure you want to delete this record??"),
                                            actions: <Widget>[
                                              TextButton(
                                                  onPressed: () async {
                                                    if (mounted) {
                                                      await homePageProvider
                                                          .deleteData(record);
                                                    }

                                                    // ignore: use_build_context_synchronously
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("Delete")),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.of(context).pop(),
                                                child: const Text("Cancel"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    key: UniqueKey(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: borderRadius),
                                      padding: const EdgeInsets.fromLTRB(
                                          16, 12, 16, 12),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                child: Text(
                                                  record.title,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: textgetter.titleMedium
                                                      ?.copyWith(
                                                          color: const Color(
                                                              0xff2E2E2E),
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 8,
                                              ),
                                              Text(
                                                record.theater,
                                                style: textgetter.bodyMedium
                                                    ?.copyWith(
                                                        color: const Color(
                                                            0xffAAAAAA)),
                                              )
                                            ],
                                          ),
                                          const Padding(
                                              padding: EdgeInsets.all(4)),
                                          Row(
                                            children: [
                                              Text(
                                                DateFormat("yyyy/MM/dd HH:mm")
                                                    .format(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            record.datetime *
                                                                1000)),
                                                style: textgetter.bodyMedium
                                                    ?.copyWith(
                                                        color: const Color(
                                                            0xffAAAAAA)),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  (record.content ?? "")
                                                      .replaceAll('\n', ''),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: textgetter.bodyMedium
                                                      ?.copyWith(
                                                          color: const Color(
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
                                          index !=
                                                  homePageProvider
                                                          .records.length -
                                                      1
                                              ? const Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 4, 0, 0),
                                                  child: Divider(
                                                    height: 1,
                                                    thickness: 1,
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                filter: (value) => homePageProvider.records
                                    .where(
                                      (element) => element.title
                                          .toLowerCase()
                                          .contains(value),
                                    )
                                    .toList(),
                                onItemSelected: (record) {
                                  AutoRouter.of(context)
                                      .push(RecordPageRoute(recordData: record))
                                      .then((value) {
                                    if (value == true) {
                                      homePageProvider.fetchRecords();
                                    }
                                  });
                                },
                                emptyWidget: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 24, 0, 24),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          width: 220,
                                          height: 220,
                                          child: Image.asset(
                                              "images/records_empty.png")),
                                      const Padding(
                                          padding: EdgeInsets.all(20)),
                                      Text(
                                        "Movie waiting...",
                                        style: textgetter.bodyLarge?.copyWith(
                                            color: const Color(0xffAAAAAA)),
                                      ),
                                    ],
                                  ),
                                ),
                                inputDecoration: const InputDecoration(
                                  hintText: "Search",
                                  fillColor: Color(0xffECECEC),
                                  filled: true,
                                  prefixIcon: Icon(Icons.search),
                                  prefixIconColor: Color(0xffAAAAAA),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(16, 8, 0, 8),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                ),
                              ));
                          break;
                        case HomePageStatus.loading:
                          widget = Align(
                            alignment: Alignment.center,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                              height: 80,
                              padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const LinearProgressIndicator(),
                                  const Padding(padding: EdgeInsets.all(4)),
                                  Text(
                                    "Loading...",
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
                                homePageProvider.fetchRecords();
                              },
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  child: const Center(
                                    child: Text("Failed to retrieve data"),
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
          },
        );
      },
    );
  }
}
