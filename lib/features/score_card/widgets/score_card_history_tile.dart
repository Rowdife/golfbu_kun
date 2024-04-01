import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

class ScoreCardHistoryTile extends ConsumerWidget {
  const ScoreCardHistoryTile({
    super.key,
    required this.courseName,
    required this.uploadDate,
    required this.uploaderName,
    required this.totalScore,
  });
  final String courseName;
  final String uploadDate;
  final String uploaderName;
  final String totalScore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          tileColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.green, width: 1),
          ),
          title: Text(
            courseName,
          ),
          subtitle: Row(
            children: [
              Text(uploadDate.toString()),
              const Gap(20),
              Text(uploaderName),
            ],
          ),
          trailing: Text(
            totalScore.toString(),
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ),
        const Gap(20),
      ],
    );
  }
}
