import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class TimelineComment extends ConsumerWidget {
  const TimelineComment({
    super.key,
    required this.grade,
    required this.name,
    required this.createdAt,
    required this.text,
  });

  final String grade, name, createdAt, text;

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
              const Gap(15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$grade $name",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    createdAt,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
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
                text,
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
