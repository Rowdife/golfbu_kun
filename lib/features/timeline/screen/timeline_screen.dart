import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:golfbu_kun/features/timeline/widgets/timeline_post.dart';

class TimelineScreen extends ConsumerWidget {
  const TimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          title: const Text("Timeline"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const FaIcon(FontAwesomeIcons.upload),
            ),
          ],
        ),
        body: ListView.separated(
          itemCount: 5,
          separatorBuilder: (context, index) => const Divider(
            height: 20,
            thickness: 0,
            color: Colors.transparent,
          ),
          itemBuilder: (context, index) {
            return TimelinePost(
                videoURL: "以後FirebaseのStorageのURLに変更する",
                caption: "右腋を締めることを意識してます。",
                date: DateTime.now(),
                userName: "4年 パク・シヒョン");
          },
        ));
  }
}
