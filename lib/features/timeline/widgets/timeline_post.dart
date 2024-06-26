import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
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
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

class TimelinePost extends ConsumerStatefulWidget {
  const TimelinePost({
    super.key,
    required this.videoData,
    required this.index,
    required this.keyValue,
  });

  final ValueKey keyValue;
  final PostVideoModel videoData;
  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TimelinePostState();
}

class _TimelinePostState extends ConsumerState<TimelinePost>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  bool _isPlaying = false;

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

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoData.fileUrl));
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 9 / 15,
      allowFullScreen: true,
      autoInitialize: true,
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
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
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black87,
            boxShadow: const [
              BoxShadow(
                color: Colors.white12,
                offset: Offset(0, 0),
                blurRadius: 10.0,
                spreadRadius: 1.0,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(10),
              GestureDetector(
                onTap: () {
                  context.push("/profileinfo/${widget.videoData.uploaderUid}");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
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
                        const Gap(10),
                        Text(
                          "${widget.videoData.uploaderGrade} ${widget.videoData.uploaderName}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    if (widget.videoData.uploaderUid ==
                        ref.read(authRepo).user?.uid)
                      PopupMenuButton<String>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
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
                            child: Text('Delete'),
                          ),
                        ],
                      )
                  ],
                ),
              ),
              const Gap(10),
              Container(
                height: size.height * 0.57,
                width: size.width * 0.8,
                color: Colors.grey.shade900,
                child: Stack(
                  children: [
                    Chewie(
                      controller: _chewieController,
                    ),
                  ],
                ),
              ),
              Container(
                child: Text(DateTime.fromMillisecondsSinceEpoch(
                        widget.videoData.createdAt)
                    .toString()
                    .substring(0, 16)),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.09),
                    border: Border.all(
                      color: Colors.white,
                      width: 0.5,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: Text(
                  widget.videoData.description,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () async {
                          _onCommentTap(context);
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.solidComment,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Text(
                        "${widget.videoData.comments}",
                      ),
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
