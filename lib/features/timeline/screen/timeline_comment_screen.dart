import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/profile/vms/profiles_vm.dart';
import 'package:golfbu_kun/features/timeline/models/post_comment_model.dart';
import 'package:golfbu_kun/features/timeline/vms/upload_video_comment_vm.dart';
import 'package:golfbu_kun/features/timeline/widgets/timeline_comment.dart';

class TimelineCommentScreen extends ConsumerStatefulWidget {
  const TimelineCommentScreen({
    super.key,
    required this.comments,
    required this.createdAt,
  });
  // videoDataのcreateAt なので UnixTime.
  final int createdAt;
  // commentsをItemBuildする時に必要
  final List<PostCommentModel> comments;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TimelineCommentScreenState();
}

class _TimelineCommentScreenState extends ConsumerState<TimelineCommentScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String commentText = "";

  void _onSendCommentTap() async {
    if (_textEditingController.text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      final text = _textEditingController.text;
      print(text);
      _textEditingController.text = "";
      final profile = await ref.read(profileProvider.notifier).fetchProfile();
      ref.read(uploadVideoCommentProvider.notifier).uploadVideoComment(
          comment: PostCommentModel(
            uploaderName: profile.name,
            uploaderGrade: profile.grade,
            text: text,
            createdAt: DateTime.now().toString().substring(0, 16),
            createdAtUnix: DateTime.now().millisecondsSinceEpoch,
            uploaderUid: profile.uid,
          ),
          createdAt: widget.createdAt);
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Comment"),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: ListView.separated(
          itemCount: widget.comments.length,
          padding: const EdgeInsets.only(bottom: 100),
          separatorBuilder: (context, index) => const SizedBox(
            height: 15,
          ),
          itemBuilder: (context, index) => Stack(
            children: [
              TimelineComment(
                comment: widget.comments[index],
                videoCreatedAt: widget.createdAt,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            border: const Border(
              top: BorderSide(
                color: Colors.white38,
              ),
            ),
          ),
          child: Column(
            children: [
              const Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _textEditingController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        validator: (value) {
                          if (value != null && value.isEmpty) {
                            return;
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          if (newValue != null) {
                            commentText = newValue;
                          }
                        },
                        decoration: const InputDecoration(
                          hintText: "コメントを入力してください",
                          hintStyle:
                              TextStyle(color: Colors.white38, fontSize: 14),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    // upload comment
                    onPressed: _onSendCommentTap,
                    icon: const FaIcon(
                      FontAwesomeIcons.paperPlane,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
