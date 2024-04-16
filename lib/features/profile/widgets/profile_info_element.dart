import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileInfoElement extends StatelessWidget {
  const ProfileInfoElement({
    super.key,
    required this.category,
    required this.info,
  });

  final String category;
  final String info;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        title: Row(
          children: [
            Text(
              "$category:",
              style: const TextStyle(color: Colors.white),
            ),
            const Gap(10),
            Text(
              info,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
