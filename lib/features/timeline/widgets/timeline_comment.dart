import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class TimelineComment extends ConsumerWidget {
  const TimelineComment({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        ListTile(
          tileColor: Colors.grey.shade900,
          leading: const CircleAvatar(
            backgroundColor: Colors.black,
            child: FaIcon(
              FontAwesomeIcons.user,
              color: Colors.white,
            ),
          ),
          title: const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              "4年 パク・シヒョン",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          subtitle: const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              "もうちょっと下半身のターンのタイミングを早くしてもいいかも",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
