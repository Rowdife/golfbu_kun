import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/timeline/vms/timeline_team_list_vm.dart';

class TimelineTeamListScreen extends ConsumerWidget {
  const TimelineTeamListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Drawer(
        backgroundColor: Colors.grey.shade900,
        child: Column(
          children: [
            const Gap(20),
            const Text(
              "部員リスト",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
            ref.watch(timelineTeamListProvider).when(
                  data: (profiles) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: profiles.length,
                        itemBuilder: (context, index) {
                          final profile = profiles[index];
                          return ListTile(
                            onTap: () {
                              context.push('/profileinfo/${profile.uid}');
                            },
                            title: Text(profile.name),
                            subtitle: Text(profile.position),
                            leading: CircleAvatar(
                              backgroundColor: Colors.black,
                              child: ClipOval(
                                child: Image.network(
                                    "https://firebasestorage.googleapis.com/v0/b/golfbukun.appspot.com/o/avatars%2F${profile.uid}?alt=media&token=${Random().nextInt(100)}",
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                  return const FaIcon(
                                    FontAwesomeIcons.user,
                                    color: Colors.white,
                                    size: 20,
                                  );
                                }),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  loading: () {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  error: (error, stackTrace) => Center(
                    child: Text(
                      'ロードできません $error',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
