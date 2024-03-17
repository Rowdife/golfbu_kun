import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/widgets/auth_button.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_choice_screen.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_question_screen.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_video_screen.dart';

import 'package:golfbu_kun/features/timeline/widgets/timeline_post.dart';

class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  void _onUploadTap(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const TimelineUploadChoiceScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          title: const Text("Timeline"),
          actions: [
            IconButton(
              onPressed: () => _onUploadTap(context),
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
