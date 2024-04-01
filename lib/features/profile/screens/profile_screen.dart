import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/profile/screens/setting_screen.dart';
import 'package:golfbu_kun/features/profile/vms/profiles_vm.dart';
import 'package:golfbu_kun/features/profile/widgets/profile_info_element.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_data_model.dart';
import 'package:golfbu_kun/features/score_card/vms/score_card__my_history_vm.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_card_history_tile.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_card_view.dart';
import 'package:golfbu_kun/features/timeline/vms/timeline_vm.dart';
import 'package:golfbu_kun/features/timeline/widgets/timeline_post.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static const routeName = "profileinfo";
  static const routeURL = "/profileinfo";
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  void _onScoreCardTap(ScoreCardDataModel scoreCardData) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScoreCardView(
          scoreCardData: scoreCardData,
        ),
      ),
    );
  }

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
              body: DefaultTabController(
                length: 3,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      title: Text(data.name),
                      actions: [
                        IconButton(
                          onPressed: () {},
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
                        children: [
                          const Gap(20),
                          const CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.black,
                            child: FaIcon(
                              FontAwesomeIcons.user,
                              color: Colors.white,
                              size: 40,
                            ),
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
                          const TabBar(
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Colors.white,
                            labelPadding: EdgeInsets.symmetric(vertical: 10),
                            dividerColor: Colors.transparent,
                            tabs: [
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
                          ref.watch(timelineProvider).when(
                              loading: () {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              error: (error, stackTrace) => Center(
                                    child: Text(
                                      '投稿をロードできません $error',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                              data: (videos) {
                                return SizedBox(
                                  height: MediaQuery.of(context).size.height *
                                      videos.length *
                                      0.85,
                                  width: MediaQuery.of(context).size.width,
                                  child: TabBarView(
                                    children: [
                                      ListView.separated(
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
                                      ),
                                      ref
                                          .watch(scoreCardMyHisotryProvider)
                                          .when(
                                            data: (scoreCardsData) {
                                              final scoreCard = scoreCardsData;
                                              return ListView.builder(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 20),
                                                itemCount: scoreCard.length,
                                                itemBuilder: (context, index) {
                                                  return SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    child: Column(
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () =>
                                                              _onScoreCardTap(
                                                                  scoreCard[
                                                                      index]),
                                                          child:
                                                              ScoreCardHistoryTile(
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
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            },
                                            error: (error, stackTrace) =>
                                                Center(
                                              child: Text(
                                                '投稿をロードできません $error',
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                      const Text("hi"),
                                    ],
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
