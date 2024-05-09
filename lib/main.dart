import 'package:flutter/material.dart';
import 'package:movie_notes/core/injections.dart';
import 'package:movie_notes/core/router/app_router.dart';
import 'package:movie_notes/feature/home_page/domain/provider/home_page_provider.dart';
import 'package:movie_notes/feature/record_page/domain/provider/record_page_provider.dart';
import 'package:movie_notes/utils/palette.dart';
import 'package:movie_notes/utils/text_getter.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initInjections();
  runApp(
    (const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppRouter appRouter = AppRouter();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => Palette()),
        Provider(create: (context) => TextGetter(context)),
        ChangeNotifierProvider(create: (_) => HomePageProvider()),
        ChangeNotifierProvider(create: (_) => RecordPageProvider()),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter.config(),
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
      ),
    );
  }
}
