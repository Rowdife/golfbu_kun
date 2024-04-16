import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ScoreCardDataTile extends StatelessWidget {
  const ScoreCardDataTile({
    super.key,
    required this.title,
    required this.data,
    this.subtitle,
  });
  final String title;
  final String data;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          tileColor: Colors.black54,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.green, width: 1),
          ),
          title: Text(
            "$title :",
            style: const TextStyle(color: Colors.white),
          ),
          trailing: Text(
            data,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          subtitle: subtitle == null
              ? null
              : Text(subtitle!, style: const TextStyle(color: Colors.white)),
        ),
        const Gap(10),
      ],
    );
  }
}
