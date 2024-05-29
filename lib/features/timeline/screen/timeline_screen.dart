import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/widgets/auth_button.dart';
import 'package:golfbu_kun/features/timeline/models/post_video_model.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_team_list_screen.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_choice_screen.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_question_screen.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_video_screen.dart';
import 'package:golfbu_kun/features/timeline/vms/timeline_vm.dart';
import 'package:golfbu_kun/features/timeline/vms/upload_video_comment_vm.dart';

import 'package:golfbu_kun/features/timeline/widgets/timeline_post.dart';
import 'package:golfbu_kun/features/timeline/widgets/timline_post_pageview.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TimelineScreen extends ConsumerStatefulWidget {
  const TimelineScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController(viewportFraction: 1);
  final VisibilityDetectorController _visibilityDetectorController =
      VisibilityDetectorController();
  int _itemCount = 0;
  int pageNumber = 0;
  bool hasData = false;

  Future<void> _onRefresh() async {
    await ref.read(timelineProvider.notifier).refresh();
    _pageController.jumpToPage(0);
    setState(() {});
  }

  void _onPageChanged(int page) async {
    if (pageNumber != page) {
      pageNumber = page;
    }
  }

  void _onVisibilityChanged(VisibilityInfo info) async {
    if (info.visibleFraction == 1.0) {
      if (pageNumber == _itemCount - 2) {
        await ref.read(timelineProvider.notifier).fetchNextVideos();
        _pageController.jumpToPage(pageNumber);
      }
    } else {}
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videos = ref.watch(timelineProvider).when(
          data: (data) => data,
          loading: () => [],
          error: (_, __) => [],
        );
    _itemCount = videos.length;
    return Scaffold(
      body: RefreshIndicator(
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
                VisibilityDetector(
                  onVisibilityChanged: _onVisibilityChanged,
                  key: ValueKey(videoData.createdAt),
                  child: TimelinePostPageView(
                    videoData: videoData,
                    index: index,
                    keyValue: ValueKey(videoData.createdAt),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
