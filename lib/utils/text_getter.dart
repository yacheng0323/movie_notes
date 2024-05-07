import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

final textGetterProvider = Provider<TextGetter>((ref) {
  // final context = ref.container.read(BuildContext);
  return TextGetter(TextTheme());
});

class TextGetter {
  final TextTheme textTheme;

  TextGetter(this.textTheme);
  // final BuildContext context;

  // TextGetter(this.context);

  // TextTheme get _textTheme => Theme.of(context).textTheme;
  TextTheme get _googleTextTheme => GoogleFonts.notoSansTextTheme(textTheme);

  TextStyle? get displayLarge => _googleTextTheme.displayLarge?.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 57,
      height: 64 / 57,
      letterSpacing: -0.25);
  TextStyle? get displayMedium => _googleTextTheme.displayMedium
      ?.copyWith(fontWeight: FontWeight.w400, fontSize: 45, height: 52 / 45);
  TextStyle? get displaySmall => _googleTextTheme.displaySmall
      ?.copyWith(fontWeight: FontWeight.w400, fontSize: 36, height: 44 / 36);
  TextStyle? get headlineLarge => _googleTextTheme.headlineLarge
      ?.copyWith(fontWeight: FontWeight.w400, fontSize: 32, height: 40 / 32);
  TextStyle? get headlineMedium => _googleTextTheme.headlineMedium
      ?.copyWith(fontWeight: FontWeight.w400, fontSize: 28, height: 36 / 28);
  TextStyle? get headlineSmall => _googleTextTheme.headlineSmall
      ?.copyWith(fontWeight: FontWeight.w400, fontSize: 24, height: 32 / 24);
  TextStyle? get titleLarge => _googleTextTheme.titleLarge
      ?.copyWith(fontWeight: FontWeight.w400, fontSize: 22, height: 28 / 22);
  TextStyle? get titleMedium => _googleTextTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      height: 24 / 16,
      letterSpacing: 0.1);
  TextStyle? get titleSmall => _googleTextTheme.titleSmall?.copyWith(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 20 / 14,
      letterSpacing: 0.1);
  TextStyle? get labelLarge => _googleTextTheme.labelLarge
      ?.copyWith(fontWeight: FontWeight.w500, fontSize: 14, height: 20 / 14);
  TextStyle? get labelMedium => _googleTextTheme.labelMedium
      ?.copyWith(fontWeight: FontWeight.w500, fontSize: 12, height: 16 / 12);
  TextStyle? get labelSmall => _googleTextTheme.labelSmall
      ?.copyWith(fontWeight: FontWeight.w500, fontSize: 11, height: 16 / 11);
  TextStyle? get bodyLarge => _googleTextTheme.bodyLarge
      ?.copyWith(fontWeight: FontWeight.w400, fontSize: 16, height: 24 / 16);
  TextStyle? get bodyMedium => _googleTextTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 20 / 14,
      letterSpacing: 0.015);
  TextStyle? get bodySmall => _googleTextTheme.bodySmall
      ?.copyWith(fontWeight: FontWeight.w400, fontSize: 12, height: 16 / 12);
}
