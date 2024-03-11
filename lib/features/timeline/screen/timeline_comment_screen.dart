import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/timeline/widgets/timeline_comment.dart';

class TimelineCommentScreen extends ConsumerWidget {
  const TimelineCommentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comment"),
      ),
      body: ListView.separated(
          itemCount: 3,
          separatorBuilder: (context, index) => const Divider(
                height: 1,
              ),
          itemBuilder: (context, index) => const TimelineComment()),
    );
  }
}
