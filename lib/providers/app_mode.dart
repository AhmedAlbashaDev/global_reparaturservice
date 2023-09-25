import 'package:flutter_riverpod/flutter_riverpod.dart';

/// APP MODES PROVIDER

final currentAppModeProvider = StateProvider<AppMode>((ref) =>
  AppMode.admins
);

/// APP MODES
enum AppMode {
  admins,
  technician,
}