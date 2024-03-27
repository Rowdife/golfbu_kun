import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ScoreCategories extends StatelessWidget {
  const ScoreCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Gap(20),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Hole",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(40),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Par",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(20),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Score",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Putt",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Putt remained",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Putt missed",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Tee shot club",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Tee shot",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Par on shot distance",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Green side bunker",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "OB",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "HZ",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Penalty",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
