import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ScoreInt extends StatelessWidget {
  const ScoreInt({
    super.key,
    required this.number,
  });

  final String number;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(10),
        Text(
          number,
          style: const TextStyle(fontSize: 29),
        ),
        const Divider(
          color: Colors.white,
          height: 10,
          thickness: 1,
        ),
      ],
    );
  }
}
