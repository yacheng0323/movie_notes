import 'package:get_it/get_it.dart';
import 'package:movie_notes/database/database_service.dart';
import 'package:movie_notes/core/router/app_router.dart';

final sl = GetIt.instance;

Future<void> initInjections() async {
  sl.registerSingleton<AppRouter>(AppRouter());
  sl.registerSingleton<DatabaseService>(DatabaseService());
}
