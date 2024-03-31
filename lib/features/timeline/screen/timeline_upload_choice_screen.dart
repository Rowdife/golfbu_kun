import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/widgets/auth_button.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_question_screen.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_upload_video_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class TimelineUploadChoiceScreen extends ConsumerStatefulWidget {
  const TimelineUploadChoiceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TimelineUploadChoiceScreenState();
}

class _TimelineUploadChoiceScreenState
    extends ConsumerState<TimelineUploadChoiceScreen> {
  bool _hasPermission = false;
  bool _deniedPermission = false;

  Future<void> _onUploadVideoTap(BuildContext context) async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (video == null) return;
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimelineUploadVideoScreen(
          video: video,
        ),
      ),
    );
  }

  void _onUploadQuestionTap(BuildContext context) {
    context.pushNamed(TimelineUploadQuestionScreen.routeName);
  }

  Future<void> initPermissions() async {
    final photosPermission = await Permission.photos.request();
    final cameraPermission = await Permission.camera.request();
    final microphonePermission = await Permission.microphone.request();

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;
    final photosDenied =
        photosPermission.isDenied || photosPermission.isPermanentlyDenied;
    final micDenied = microphonePermission.isDenied ||
        microphonePermission.isPermanentlyDenied;

    if (!cameraDenied && !micDenied && !photosDenied) {
      _hasPermission = true;

      setState(() {});
    }

    if (cameraDenied || micDenied || photosDenied) {
      setState(() {
        _deniedPermission = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (_deniedPermission) {
      initPermissions();
    } else {
      _hasPermission = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("upload")),
        body: _deniedPermission
            ? const Center(
                child: Text(
                    "写真、カメラ、もしくはマイクのアクセスを拒否しました。このアプリをご利用いただくには全てに同意する必要がありますので、設定にてアクセスを許可してください。"),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Text(
                              "５秒以内の動画だけアップロードできます。\n自分で5秒以内の動画に編集してください。"),
                          const Gap(10),
                          GestureDetector(
                            onTap: () => _onUploadVideoTap(context),
                            child: const AuthButton(
                                color: Colors.blueAccent,
                                text: "スイング動画を投稿(動画)"),
                          ),
                          const Gap(150)
                        ],
                      ),
                    ],
                  ),
                ],
              ));
  }
}
