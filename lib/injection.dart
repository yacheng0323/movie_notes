import 'package:get_it/get_it.dart';
import 'package:movie_notes/database/database_service.dart';
import 'package:movie_notes/routes/app_router.dart';

class Injection {
  late GetIt i;

  init() async {
    i = GetIt.instance;
    i.registerSingleton(() => AppRouter());
    i.registerSingleton(() => DatabaseService());
  }
}
