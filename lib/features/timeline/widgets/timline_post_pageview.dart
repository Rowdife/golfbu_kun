import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/timeline/models/post_video_model.dart';
import 'package:golfbu_kun/features/timeline/repos/post_repo.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_comment_screen.dart';
import 'package:golfbu_kun/features/timeline/vms/timeline_vm.dart';
import 'package:golfbu_kun/features/timeline/vms/upload_video_comment_vm.dart';
import 'package:smooth_video_progress/smooth_video_progress.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TimelinePostPageView extends ConsumerStatefulWidget {
  const TimelinePostPageView({
    super.key,
    required this.videoData,
    required this.index,
    required this.keyValue,
  });

  final ValueKey keyValue;
  final PostVideoModel videoData;
  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TimelinePostPageViewState();
}

class _TimelinePostPageViewState extends ConsumerState<TimelinePostPageView>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;

  bool _isPlaying = false;
  bool _isFullCaptionShowed = false;

  int _captionLengthLimit = 30;

  final TextStyle _textButton = const TextStyle(color: Colors.white60);

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

  void _initVideoPlayer() async {
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoData.fileUrl));
    await _videoPlayerController.initialize();
    _videoPlayerController.setLooping(true);
    setState(() {});
  }
//videoData.createdAt 으로 Comment가져오기.

  Future<void> _onCommentTap(BuildContext context) async {
    final comments = await ref
        .read(timelineProvider.notifier)
        .fetchComments(createdAt: widget.videoData.createdAt);

    showModalBottomSheet(
      context: context,
      scrollControlDisabledMaxHeightRatio: 0.8,
      builder: (context) => TimelineCommentScreen(
        createdAt: widget.videoData.createdAt,
        comments: comments,
      ),
    );
  }

  void _toggleMoreAndClose() {
    setState(() {
      _isFullCaptionShowed = !_isFullCaptionShowed;
    });
  }

  String _autoEditedCaptionText(String description) {
    if (description.length > _captionLengthLimit) {
      return "${description.substring(0, _captionLengthLimit)}...";
    } else {
      return description;
    }
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
      key: Key(widget.keyValue.toString()),
      child: Stack(
        children: [
          Container(
            color: Colors.grey.shade900,
            height: size.height - 80, // 80 is the height of the bottom bar,
            child: Stack(
              children: [
                Positioned.fill(
                  child: _videoPlayerController.value.isInitialized
                      ? VideoPlayer(
                          _videoPlayerController,
                        )
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Colors.green,
                          ),
                        ),
                ),
                Positioned.fill(
                  bottom: 500,
                  child: !_isPlaying
                      ? Center(
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: FaIcon(
                                FontAwesomeIcons.play,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Center(),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: const Text(''),
                  ),
                ),
                Positioned.fill(
                  child: GestureDetector(onTap: _onTogglePlay),
                ),
                Positioned(
                  bottom: 15,
                  left: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.push(
                              "/profileinfo/${widget.videoData.uploaderUid}");
                        },
                        child: Text(
                          "@${widget.videoData.uploaderName}",
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(DateTime.fromMillisecondsSinceEpoch(
                              widget.videoData.createdAt)
                          .toString()
                          .substring(0, 16)),
                      Gap(20),
                      SizedBox(
                        width: 300,
                        child: widget.videoData.description.length >
                                _captionLengthLimit
                            ? Text.rich(
                                TextSpan(
                                  text: _isFullCaptionShowed
                                      ? widget.videoData.description
                                      : _autoEditedCaptionText(
                                          widget.videoData.description),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                  children: [
                                    _isFullCaptionShowed
                                        ? TextSpan(
                                            text: "   減らす",
                                            style: _textButton,
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = _toggleMoreAndClose,
                                          )
                                        : TextSpan(
                                            text: "  もっと見る",
                                            style: _textButton,
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = _toggleMoreAndClose,
                                          )
                                  ],
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: _isFullCaptionShowed ? 50 : 3,
                              )
                            : Text(
                                widget.videoData.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 10,
                  child: Column(
                    children: [
                      if (widget.videoData.uploaderUid ==
                          ref.read(authRepo).user?.uid)
                        PopupMenuButton<String>(
                          icon: const FaIcon(
                            FontAwesomeIcons.ellipsisVertical,
                            color: Colors.white,
                            size: 30,
                          ),
                          onSelected: (value) async {
                            switch (value) {
                              case 'Delete':
                                await ref.read(postRepo).deleteVideo(
                                      createdAt: widget.videoData.createdAt,
                                    );
                                await ref
                                    .read(timelineProvider.notifier)
                                    .refresh();
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Delete',
                              child: Center(
                                  child: FaIcon(
                                FontAwesomeIcons.trash,
                                color: Colors.red,
                              )),
                            ),
                          ],
                        ),
                      Gap(10),
                      GestureDetector(
                        onTap: () => _onCommentTap(context),
                        child: FaIcon(
                          FontAwesomeIcons.solidCommentDots,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      Gap(10),
                      Text(widget.videoData.comments.toString()),
                      Gap(30),
                      GestureDetector(
                        onTap: () {
                          context.push(
                              "/profileinfo/${widget.videoData.uploaderUid}");
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl:
                                  "https://firebasestorage.googleapis.com/v0/b/golfbukun.appspot.com/o/avatars%2F${widget.videoData.uploaderUid}?alt=media&token=${Random().nextInt(100)}",
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, dynamic error) {
                                return Center(
                                  child: const FaIcon(
                                    FontAwesomeIcons.user,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              width: size.width,
              child: SmoothVideoProgress(
                controller: _videoPlayerController,
                builder: (context, position, duration, child) => SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight:
                        1, // Set the track height to 0 to remove padding
                    overlayShape: SliderComponentShape.noThumb,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                  ),
                  child: Slider(
                    onChangeStart: (_) => _videoPlayerController.pause(),
                    onChangeEnd: (_) => _videoPlayerController.pause(),
                    onChanged: (value) => _videoPlayerController
                        .seekTo(Duration(milliseconds: value.toInt())),
                    value: position.inMilliseconds.toDouble(),
                    min: 0,
                    max: duration.inMilliseconds.toDouble(),
                    activeColor: Colors.green,
                    inactiveColor: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
