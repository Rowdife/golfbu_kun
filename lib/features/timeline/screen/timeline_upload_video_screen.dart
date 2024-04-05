import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/timeline/vms/timeline_vm.dart';
import 'package:golfbu_kun/features/timeline/vms/upload_video_vm.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class TimelineUploadVideoScreen extends ConsumerStatefulWidget {
  static const routeName = "uploadvideo";
  static const routeUrl = "/uploadvideo";
  const TimelineUploadVideoScreen({
    super.key,
    required this.video,
  });
  final XFile video;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TimelineUploadScreenState();
}

class _TimelineUploadScreenState
    extends ConsumerState<TimelineUploadVideoScreen> {
  late final VideoPlayerController _videoPlayerController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String title = "";
  String description = "";
  bool underFiveSeconds = false;
  bool _isPlaying = false;

  Future<void> _initVideo() async {
    _videoPlayerController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await _videoPlayerController.initialize();

    underFiveSeconds = _videoPlayerController.value.duration.inSeconds < 8;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initVideo();
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

  void _onUploadPressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await ref.read(uploadVideoProvider.notifier).uploadVideo(
            File(widget.video.path),
            description,
            context,
          );
      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("アップロード完了"),
          content: const Text("動画のアップロードが完了しました"),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
      context.pop();
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("upload video"),
          actions: [
            IconButton(
              onPressed: ref.watch(uploadVideoProvider).isLoading
                  ? () {}
                  : () => _onUploadPressed(context),
              icon: ref.watch(uploadVideoProvider).isLoading
                  ? const CircularProgressIndicator()
                  : const FaIcon(FontAwesomeIcons.upload),
            ),
          ],
        ),
        body: _videoPlayerController.value.isInitialized && underFiveSeconds
            ? Stack(
                children: [
                  Positioned(
                    child: GestureDetector(
                        onTap: _onTogglePlay,
                        child: VideoPlayer(_videoPlayerController)),
                  ),
                  Center(
                      child: _isPlaying
                          ? const SizedBox.shrink()
                          : const FaIcon(
                              FontAwesomeIcons.play,
                              size: 40,
                              color: Colors.white,
                            )),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 170,
                      color: Colors.grey.shade900,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText:
                                      "今抱えてる悩みやミスの傾向を書いて、改善したい方向を具体的に書くと良質なアドバイスをもらえる可能性が高まります。",
                                  hintStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.5)),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).primaryColor),
                                  ),
                                ),
                                textInputAction: TextInputAction.newline,
                                maxLines: 4,
                                maxLength: 200,
                                validator: (value) {
                                  if (value != null && value.isEmpty) {
                                    return "Plase write a description";
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  if (newValue != null) {
                                    description = newValue;
                                  }
                                },
                              ),
                              const Gap(20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : const Center(
                child: Text("7秒以内の動画を使用してください"),
              ));
  }
}
