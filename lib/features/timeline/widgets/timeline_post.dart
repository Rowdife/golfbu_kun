import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_comment_screen.dart';
import 'package:video_player/video_player.dart';

class TimelinePost extends ConsumerStatefulWidget {
  const TimelinePost({
    super.key,
    required this.videoURL,
    required this.userName,
    required this.caption,
    required this.date,
  });
  final String videoURL;
  final String userName;
  final String caption;
  final DateTime date;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TimelinePostState();
}

class _TimelinePostState extends ConsumerState<TimelinePost>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;
  late final AnimationController _animationController;

  final Duration _animationDuration = const Duration(milliseconds: 200);

  bool _isPlaying = false;

  void _initVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.asset("assets/videos/golf_swing.MOV");
    await _videoPlayerController.initialize();
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
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 1.0,
      upperBound: 1.5,
      value: 1.0,
      duration: _animationDuration,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return FractionallySizedBox(
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
                  widget.userName,
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
              child:
                  Text("posted at ${widget.date.toString().substring(0, 16)}"),
            ),
            Container(
              child: Text(widget.caption),
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
                    const Text("1"),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
