import 'package:flutter/material.dart';
import 'package:movie_notes/routes/app_router.dart';
import 'package:movie_notes/ui/home_page/home_page.dart';
import 'package:movie_notes/utils/palette.dart';
import 'package:movie_notes/utils/text_getter.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
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
