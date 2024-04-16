import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalendarViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // TODO: implement build
    throw UnimplementedError();
  }
}

final calendarProvider = AsyncNotifierProvider<CalendarViewModel, void>(
  () => CalendarViewModel(),
);
