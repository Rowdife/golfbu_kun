import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NavTap extends ConsumerWidget {
  const NavTap({
    super.key,
    required this.tapName,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });
  final String tapName;
  final IconData icon;
  final Function onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Container(
          child: Column(
            children: [
              FaIcon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
              Text(
                tapName,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
