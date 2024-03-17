import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:golfbu_kun/features/profile/vms/profiles_vm.dart';
import 'package:golfbu_kun/features/profile/widgets/profile_info_element.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static const routeName = "profileinfo";
  static const routeURL = "/profileinfo";
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(profileProvider).when(
        error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
        loading: () => const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
        data: (data) => Scaffold(
              appBar: AppBar(
                title: const Text("プロフィール情報"),
              ),
              body: ListView(
                children: [
                  ProfileInfoElement(
                    category: '所属大学',
                    info: data.university,
                  ),
                  ProfileInfoElement(
                    category: '名前',
                    info: data.name,
                  ),
                  ProfileInfoElement(
                    category: '役職',
                    info: data.position,
                  ),
                  ProfileInfoElement(
                    category: '性別',
                    info: data.sex,
                  ),
                ],
              ),
            ));
  }
}
