import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_notes/routes/app_router.gr.dart';
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
    final palette = ref.context.watch<Palette>();
    final textGetter = ref.context.watch<TextGetter>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: palette.appBarColor,
        title: Text(
          "電影備忘錄",
          style: textGetter.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700, color: palette.titleTextColor),
        ),
        actions: [
          IconButton(
              onPressed: () {
                AutoRouter.of(context).push(const RecordRoute());
                // context.router.push(const RecordRoute());
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
                size: 32,
              ))
        ],
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SearchAnchor.bar(
                isFullScreen: false,
                suggestionsBuilder: (context, controller) {
                  // return [
                  //   FutureBuilder(
                  //       future: future,
                  //       builder: (context, snapshot) {
                  //         // if (snapshot.connectionState == Con)
                  //       })
                  // ];
                  return List.generate(
                      5,
                      (index) => ListTile(
                            titleAlignment: ListTileTitleAlignment.center,
                            title: Text("$index"),
                          ));
                })
          ],
        ),
      ),
    );
  }
}
