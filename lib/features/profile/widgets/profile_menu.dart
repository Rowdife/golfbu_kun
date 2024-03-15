import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.icon,
    required this.text,
  });
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Gap(20),
        Row(
          children: [
            const Gap(10),
            FaIcon(
              icon,
              color: Colors.white,
            ),
            const Gap(10),
            Text(text),
          ],
        ),
        const Gap(20),
        const Divider(),
      ],
    );
  }
}
