import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/widgets/auth_button.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_choice_screen.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_question_screen.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_video_screen.dart';
import 'package:golfbu_kun/features/timeline/vms/timeline_vm.dart';

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

  Future<void> _onRefresh() async {
    return ref.read(timelineProvider.notifier).refresh();
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
        body: ref.watch(timelineProvider).when(
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
            error: (error, stackTrace) => Center(
                  child: Text(
                    '動画をロードできません $error',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
            data: (videos) => RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView.separated(
                    itemCount: videos.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 20,
                      thickness: 0,
                      color: Colors.transparent,
                    ),
                    itemBuilder: (context, index) {
                      final videoData = videos[index];
                      return TimelinePost(
                        videoData: videoData,
                        index: index,
                      );
                    },
                  ),
                )));
  }
}
