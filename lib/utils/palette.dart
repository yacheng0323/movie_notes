import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final paletteProvider = Provider<Palette>((ref) => Palette());

class Palette {
  Color get appBarColor => const Color(0xff262651);
  Color get titleTextColor => const Color(0xffFFFFFF);
  Color get selectImageBgColor => const Color(0xff939393);
  Color get searchBarColor => const Color(0xffECECEC);
}
