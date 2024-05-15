import 'dart:ui';

class Palette {
  static final Palette _instance = Palette._internal();

  factory Palette() {
    return _instance;
  }

  Palette._internal();
  Color get appBarColor => const Color(0xff262651);
  Color get titleTextColor => const Color(0xffFFFFFF);
  Color get selectImageBgColor => const Color(0xff939393);
  Color get searchBarColor => const Color(0xffECECEC);
}
