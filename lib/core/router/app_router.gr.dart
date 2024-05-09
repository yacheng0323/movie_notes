// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:flutter/cupertino.dart' as _i4;
import 'package:movie_notes/entities/record_data.dart' as _i5;
import 'package:movie_notes/feature/home_page/presentation/home_page.dart'
    as _i1;
import 'package:movie_notes/feature/record_page/presentation/record_page.dart'
    as _i2;

abstract class $AppRouter extends _i3.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    HomePageRoute.name: (routeData) {
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomePage(),
      );
    },
    RecordPageRoute.name: (routeData) {
      final args = routeData.argsAs<RecordPageRouteArgs>(
          orElse: () => const RecordPageRouteArgs());
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i2.RecordPage(
          key: args.key,
          recordData: args.recordData,
        ),
      );
    },
  };
}

/// generated route for
/// [_i1.HomePage]
class HomePageRoute extends _i3.PageRouteInfo<void> {
  const HomePageRoute({List<_i3.PageRouteInfo>? children})
      : super(
          HomePageRoute.name,
          initialChildren: children,
        );

  static const String name = 'HomePageRoute';

  static const _i3.PageInfo<void> page = _i3.PageInfo<void>(name);
}

/// generated route for
/// [_i2.RecordPage]
class RecordPageRoute extends _i3.PageRouteInfo<RecordPageRouteArgs> {
  RecordPageRoute({
    _i4.Key? key,
    _i5.RecordData? recordData,
    List<_i3.PageRouteInfo>? children,
  }) : super(
          RecordPageRoute.name,
          args: RecordPageRouteArgs(
            key: key,
            recordData: recordData,
          ),
          initialChildren: children,
        );

  static const String name = 'RecordPageRoute';

  static const _i3.PageInfo<RecordPageRouteArgs> page =
      _i3.PageInfo<RecordPageRouteArgs>(name);
}

class RecordPageRouteArgs {
  const RecordPageRouteArgs({
    this.key,
    this.recordData,
  });

  final _i4.Key? key;

  final _i5.RecordData? recordData;

  @override
  String toString() {
    return 'RecordPageRouteArgs{key: $key, recordData: $recordData}';
  }
}
