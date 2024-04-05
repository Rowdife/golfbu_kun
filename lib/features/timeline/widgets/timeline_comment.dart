import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/timeline/models/post_comment_model.dart';
import 'package:golfbu_kun/features/timeline/repos/post_repo.dart';
import 'package:golfbu_kun/features/timeline/vms/timeline_vm.dart';
import 'package:golfbu_kun/features/timeline/vms/upload_video_comment_vm.dart';

class TimelineComment extends ConsumerWidget {
  const TimelineComment(
      {super.key, required this.comment, required this.videoCreatedAt});

  final PostCommentModel comment;
  final int videoCreatedAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          tileColor: Colors.grey.shade900,
          leading: const Column(
            children: [
              CircleAvatar(
                backgroundColor: Colors.black,
                child: FaIcon(
                  FontAwesomeIcons.user,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.createdAt,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "${comment.uploaderGrade} ${comment.uploaderName}",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      if (comment.uploaderUid == ref.read(authRepo).user!.uid)
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onSelected: (value) async {
                            switch (value) {
                              case 'Delete':
                                ref
                                    .read(uploadVideoCommentProvider.notifier)
                                    .deleteVideoComment(
                                        videoCreatedAt: videoCreatedAt,
                                        commentCreatedAtUnix:
                                            comment.createdAtUnix);
                                context.pop();
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
                ],
              ),
            ],
          ),
          subtitle: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.85),
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                comment.text,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
