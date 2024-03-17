import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:golfbu_kun/features/timeline/models/post_video_model.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_comment_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TimelinePost extends ConsumerStatefulWidget {
  const TimelinePost({
    super.key,
    required this.videoData,
    required this.index,
  });

  final PostVideoModel videoData;
  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TimelinePostState();
}

class _TimelinePostState extends ConsumerState<TimelinePost>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;

  bool _isPlaying = false;

  void _initVideoPlayer() async {
    try {
      _videoPlayerController =
          VideoPlayerController.network(widget.videoData.fileUrl);
      await _videoPlayerController.initialize();
    } catch (e) {
      print(widget.videoData.fileUrl);
    }
  }

  void _onTogglePlay() {
    if (_videoPlayerController.value.isPlaying) {
      _videoPlayerController.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      _videoPlayerController.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }

  void _onCommentTap(BuildContext context) {
    showModalBottomSheet(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.8,
      builder: (context) => const TimelineCommentScreen(),
    );
  }

  @override
  void initState() {
    super.initState();
    _initVideoPlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (!mounted) return;
    if (_videoPlayerController.value.isPlaying && info.visibleFraction == 0) {
      _onTogglePlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return VisibilityDetector(
      onVisibilityChanged: _onVisibilityChanged,
      key: Key("${widget.index}"),
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black87,
          ),
          alignment: Alignment.center,
          child: Column(
            children: [
              const Gap(10),
              Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Colors.black,
                    child: FaIcon(
                      FontAwesomeIcons.user,
                      color: Colors.white,
                    ),
                  ),
                  const Gap(10),
                  Text(
                    widget.videoData.uploaderName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const Gap(10),
              Container(
                height: size.height * 0.65,
                width: size.width * 0.9,
                color: Colors.grey.shade900,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: _onTogglePlay,
                      child: VideoPlayer(_videoPlayerController),
                    ),
                    Positioned(
                      child: Container(
                        padding: const EdgeInsets.only(top: 40),
                        child: _isPlaying
                            ? null
                            : const Align(
                                alignment: Alignment.topCenter,
                                child: FaIcon(
                                  FontAwesomeIcons.play,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Text(
                    "posted at ${DateTime.fromMillisecondsSinceEpoch(widget.videoData.createdAt).toString().substring(0, 16)}"),
              ),
              Container(
                child: Text(widget.videoData.description),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      IconButton(
                        onPressed: () => _onCommentTap(context),
                        icon: const FaIcon(
                          FontAwesomeIcons.solidComment,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      Text("${widget.videoData.comments}"),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
