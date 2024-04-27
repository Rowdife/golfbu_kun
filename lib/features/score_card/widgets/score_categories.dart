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
                  color: Colors.green,
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
                  color: Colors.green,
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
            const Gap(48),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
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
            const Gap(104),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
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
            const Gap(90),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Putt残距離",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(35),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Putt結果",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(30),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Putt距離感",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(20),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "T.Shotクラブ",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(5),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "T.Shot結果",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Par on残距離",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "Par onクラブ",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
                  width: 1,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Text(
                "GreenBunker",
                style: TextStyle(fontSize: 24),
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.green,
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
                  color: Colors.green,
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
                  color: Colors.green,
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
