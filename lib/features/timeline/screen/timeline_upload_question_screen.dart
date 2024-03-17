import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimelineUploadQuestionScreen extends ConsumerStatefulWidget {
  static const routeName = "uploadquestion";
  static const routeUrl = "/uploadquestion";
  const TimelineUploadQuestionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TimelineUploadScreenState();
}

class _TimelineUploadScreenState
    extends ConsumerState<TimelineUploadQuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("upload question"),
      ),
      body: const Column(),
    );
  }
}
