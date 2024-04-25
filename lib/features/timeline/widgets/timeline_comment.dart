import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/authentication/repos/auth_repo.dart';
import 'package:golfbu_kun/features/timeline/models/post_comment_model.dart';
import 'package:golfbu_kun/features/timeline/models/post_video_model.dart';
import 'package:golfbu_kun/features/timeline/repos/post_repo.dart';
import 'package:golfbu_kun/features/timeline/vms/timeline_vm.dart';
import 'package:golfbu_kun/features/timeline/vms/upload_video_comment_vm.dart';

class TimelineComment extends ConsumerWidget {
  const TimelineComment({
    super.key,
    required this.comment,
    required this.createdAt,
  });

  final PostCommentModel comment;
  final int createdAt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String text = comment.text;
    RegExp exp = RegExp(r"\@\w+");
    List<TextSpan> textSpans = [];
    text.splitMapJoin(
      exp,
      onMatch: (m) {
        textSpans
            .add(TextSpan(text: m[0]!, style: TextStyle(color: Colors.blue)));
        return m[0]!;
      },
      onNonMatch: (n) {
        textSpans.add(TextSpan(text: n, style: TextStyle(color: Colors.black)));
        return n;
      },
    );

    return Column(
      children: [
        ListTile(
          tileColor: Colors.grey.shade900,
          leading: Column(
            children: [
              GestureDetector(
                onTap: () {
                  context.push("/profileinfo/${comment.uploaderUid}");
                },
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  child: ClipOval(
                    child: Image.network(
                        "https://firebasestorage.googleapis.com/v0/b/golfbukun.appspot.com/o/avatars%2F${comment.uploaderUid}?alt=media&token=${Random().nextInt(100)}",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                      return const FaIcon(
                        FontAwesomeIcons.user,
                        color: Colors.white,
                        size: 15,
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                          padding: EdgeInsets.zero,
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
                                        createdAt: createdAt,
                                        commentCreatedAtUnix:
                                            comment.createdAtUnix);
                                context.pop();
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              padding: EdgeInsets.zero,
                              value: 'Delete',
                              height: 10,
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.trash,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ],
              ),
              Text(
                comment.createdAt,
                style: const TextStyle(color: Colors.white, fontSize: 12),
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
              child: RichText(
                text: TextSpan(
                  children: textSpans,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
