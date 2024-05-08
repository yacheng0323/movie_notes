import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: "Page.Route")
class AppRouter extends $AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomePageRoute.page, path: '/', initial: true),
        AutoRoute(page: RecordPageRoute.page, path: '/record'),
      ];
}
