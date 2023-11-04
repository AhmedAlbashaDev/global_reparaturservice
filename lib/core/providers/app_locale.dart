import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentAppLocaleProvider = StateProvider<AppLocale>((ref) =>
AppLocale.en
);

/// APP MODES
enum AppLocale {
  en,
  de,
}