import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/widgets/auth_button.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_team_list_screen.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_choice_screen.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_question_screen.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_video_screen.dart';
import 'package:golfbu_kun/features/timeline/vms/timeline_vm.dart';
import 'package:golfbu_kun/features/timeline/vms/upload_video_comment_vm.dart';

import 'package:golfbu_kun/features/timeline/widgets/timeline_post.dart';
import 'package:golfbu_kun/features/timeline/widgets/timline_post_pageview.dart';

class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  final ScrollController _scrollController = ScrollController();
  final _pageController = PageController(viewportFraction: 1);
  int _itemCount = 0;

  Future<void> _onRefresh() async {
    await ref.read(timelineProvider.notifier).refresh();
    setState(() {});
  }

  void _onPageChanged(int page) {
    print(page);
    print(_itemCount);
    if (page == _itemCount - 1) {
      ref.read(timelineProvider.notifier).fetchNextVideos(
            context,
          );
      setState(() {});
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const TimelineTeamListScreen(),
      // backgroundColor: Colors.grey.shade900,
      // appBar: AppBar(
      //   title: const Text("Timeline"),
      //   actions: [
      //     IconButton(
      //       onPressed: () => _onUploadTap(context),
      //       icon: const FaIcon(FontAwesomeIcons.upload),
      //     ),
      //   ],
      // ),
      body: ref.watch(timelineProvider).when(
          loading: () {
            const Center(
              child: CircularProgressIndicator(),
            );
            return null;
          },
          error: (error, stackTrace) => Center(
                child: Text(
                  '投稿をロードできません $error',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
          data: (videos) {
            _itemCount = videos.length;
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: PageView.builder(
                onPageChanged: _onPageChanged,
                scrollDirection: Axis.vertical,
                itemCount: _itemCount,
                controller: _pageController,
                itemBuilder: (context, index) {
                  final videoData = videos[index];
                  return Column(
                    children: [
                      TimelinePostPageView(
                        videoData: videoData,
                        index: index,
                        keyValue: ValueKey(videoData.createdAt),
                      ),
                    ],
                  );
                },
              ),
            );
          }),
    );
  }
}
