import 'package:flutter_riverpod/flutter_riverpod.dart';

final sendingRequestProgress = StateProvider.autoDispose<int>((ref) => 0);