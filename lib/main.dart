import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as river;
import 'package:movie_notes/ui/record_page/provider/record_provider.dart';
import 'package:movie_notes/routes/app_router.dart';
import 'package:movie_notes/utils/palette.dart';
import 'package:movie_notes/utils/text_getter.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    const river.ProviderScope(child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppRouter appRouter = AppRouter();

    return MultiProvider(
      providers: [
        Provider(create: (context) => Palette()),
        Provider(create: (context) => TextGetter(context)),
        ChangeNotifierProvider(create: (context) => RecordProvider()),
      ],
      child: MaterialApp.router(
        routerConfig: appRouter.config(),
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        // home: const HomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}
