import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/profile/screens/setting_screen.dart';
import 'package:golfbu_kun/features/profile/vms/profile_avatar_vm.dart';
import 'package:golfbu_kun/features/profile/vms/profiles_vm.dart';
import 'package:golfbu_kun/features/profile/widgets/profile_edit_modal.dart';
import 'package:golfbu_kun/features/profile/widgets/profile_info_element.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_data_model.dart';
import 'package:golfbu_kun/features/score_card/vms/score_card__my_history_vm.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_card_history_tile.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_card_view.dart';
import 'package:golfbu_kun/features/timeline/vms/timeline_by_user_vm.dart';
import 'package:golfbu_kun/features/timeline/vms/timeline_vm.dart';
import 'package:golfbu_kun/features/timeline/widgets/timeline_post.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static const routeName = "profileinfo";
  static const routeURL = "/profileinfo";
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  void _onScoreCardTap(ScoreCardDataModel scoreCardData) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScoreCardView(
          scoreCardData: scoreCardData,
        ),
      ),
    );
  }

  void _dataInitialize() async {
    await ref.read(profileProvider.notifier).fetchProfile();
    await ref.read(scoreCardMyHisotryProvider.notifier).fetchMyScoreCardsData();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  Future<void> _onAvatarTap() async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 100,
      maxWidth: 100,
    );

    if (xfile != null) {
      final file = File(xfile.path);
      await ref.read(profileAvatarProvider.notifier).updateAvatar(file);
    }
  }

  Future<void> _onRefresh() async {
    await ref.read(profileProvider.notifier).fetchProfile();
    await ref.read(timelineByUserProvider.notifier).refresh();
    await ref.read(scoreCardMyHisotryProvider.notifier).fetchMyScoreCardsData();
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _dataInitialize();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(profileAvatarProvider).isLoading;
    return ref.watch(profileProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => Scaffold(
            body: RefreshIndicator(
              onRefresh: _onRefresh,
              child: DefaultTabController(
                length: 3,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title: Text(data.name),
                      actions: [
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return const ProfileEditModal();
                              },
                            );
                          },
                          icon: const FaIcon(FontAwesomeIcons.pen),
                          iconSize: 20,
                        ),
                        IconButton(
                          onPressed: () {
                            context.pushNamed(SettingScreen.routeName);
                          },
                          icon: const FaIcon(FontAwesomeIcons.gear),
                          iconSize: 20,
                        ),
                      ],
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Gap(20),
                          Stack(
                            children: [
                              isLoading
                                  ? Container(
                                      width: 100,
                                      height: 100,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.black,
                                      child: ClipOval(
                                        child: Image.network(
                                            "https://firebasestorage.googleapis.com/v0/b/golfbukun.appspot.com/o/avatars%2F${data.uid}?alt=media&token=${Random().nextInt(100)}",
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover, errorBuilder:
                                                (context, error, stackTrace) {
                                          return const FaIcon(
                                            FontAwesomeIcons.user,
                                            color: Colors.white,
                                            size: 50,
                                          );
                                        }),
                                      ),
                                    ),
                              Positioned(
                                bottom: -10,
                                right: -10,
                                child: IconButton(
                                  onPressed: isLoading ? null : _onAvatarTap,
                                  icon: const FaIcon(
                                    FontAwesomeIcons.camera,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Gap(10),
                          Text(
                            data.name,
                            style: const TextStyle(fontSize: 24),
                          ),
                          const Gap(30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Column(
                                    children: [
                                      const Text("所属大学",
                                          style: TextStyle(fontSize: 14)),
                                      Text(
                                        data.university,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  const Gap(20),
                                  Column(
                                    children: [
                                      const Text(
                                        "役職",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        data.position,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Column(
                                    children: [
                                      const Text("学年",
                                          style: TextStyle(fontSize: 14)),
                                      Text(
                                        data.grade,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                  const Gap(20),
                                  Column(
                                    children: [
                                      const Text(
                                        "性別",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        data.sex,
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Gap(20),
                          TabBar(
                            controller: _tabController,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Colors.white,
                            labelPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                            dividerColor: Colors.transparent,
                            tabs: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: FaIcon(
                                  FontAwesomeIcons.golfBallTee,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: FaIcon(
                                  FontAwesomeIcons.chartBar,
                                  color: Colors.white,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: FaIcon(
                                  FontAwesomeIcons.magnifyingGlassChart,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const Gap(20),
                          IndexedStack(
                            index: _tabController.index,
                            children: [
                              Visibility(
                                maintainState: true,
                                visible: _tabController.index == 0,
                                child: ref.watch(timelineByUserProvider).when(
                                      loading: () {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      error: (error, stackTrace) => Center(
                                        child: Text(
                                          '投稿をロードできません $error',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                      data: (videos) {
                                        return ListView.separated(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: videos.length,
                                          separatorBuilder: (context, index) =>
                                              const Divider(
                                            height: 5,
                                            thickness: 0,
                                            color: Colors.transparent,
                                          ),
                                          itemBuilder: (context, index) {
                                            final videoData = videos[index];
                                            return TimelinePost(
                                              videoData: videoData,
                                              index: index,
                                              keyValue:
                                                  ValueKey(videoData.createdAt),
                                            );
                                          },
                                        );
                                      },
                                    ),
                              ),
                              Visibility(
                                maintainState: true,
                                visible: _tabController.index == 1,
                                child: ref
                                    .watch(scoreCardMyHisotryProvider)
                                    .when(
                                      data: (scoreCardsData) {
                                        final scoreCard = scoreCardsData;
                                        return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20),
                                          itemCount: scoreCard.length,
                                          itemBuilder: (context, index) {
                                            return SingleChildScrollView(
                                              scrollDirection: Axis.vertical,
                                              child: Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () =>
                                                        _onScoreCardTap(
                                                            scoreCard[index]),
                                                    child: ScoreCardHistoryTile(
                                                      courseName:
                                                          scoreCard[index]
                                                              .courseName,
                                                      uploaderName:
                                                          scoreCard[index]
                                                              .uploaderName,
                                                      uploadDate:
                                                          scoreCard[index]
                                                              .uploadDate
                                                              .toString(),
                                                      totalScore:
                                                          scoreCard[index]
                                                              .totalScore
                                                              .toString(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      loading: () {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                      error: (error, stackTrace) => Center(
                                        child: Text(
                                          '投稿をロードできません $error',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                              ),
                              Visibility(
                                maintainState: true,
                                visible: _tabController.index == 2,
                                child: const Text("個人のスコアデータ平均を導入予定"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
  }
}
