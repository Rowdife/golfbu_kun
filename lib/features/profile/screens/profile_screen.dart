import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/profile/models/profile_model.dart';
import 'package:golfbu_kun/features/profile/screens/setting_screen.dart';
import 'package:golfbu_kun/features/profile/vms/profile_avatar_vm.dart';
import 'package:golfbu_kun/features/profile/vms/profiles_vm.dart';
import 'package:golfbu_kun/features/profile/widgets/profile_edit_modal.dart';
import 'package:golfbu_kun/features/profile/widgets/profile_info_element.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_data_model.dart';
import 'package:golfbu_kun/features/score_card/vms/score_card__my_history_vm.dart';
import 'package:golfbu_kun/features/score_card/vms/score_card_data_vm.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_card_data_tile.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_card_history_tile.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_card_view.dart';
import 'package:golfbu_kun/features/timeline/screen/timeline_team_list_screen.dart';
import 'package:golfbu_kun/features/timeline/vms/timeline_by_user_vm.dart';
import 'package:golfbu_kun/features/timeline/vms/timeline_vm.dart';
import 'package:golfbu_kun/features/timeline/widgets/timeline_post.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  static const routeName = "profile";
  static const routeURL = "/profile";
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  ProfileModel profile = ProfileModel.empty();

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
    await ref.read(timelineByUserProvider.notifier).refresh();
    await ref.read(scoreDataProvider.notifier).fetchScoreCardDataById();

    profile = await ref.read(profileProvider.notifier).fetchProfile();
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
    _dataInitialize();
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
    final roundCount = profile.coursePlayedCount;
    final isLoading = ref.watch(profileAvatarProvider).isLoading;
    return ref.watch(profileProvider).when(
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
          data: (data) => Scaffold(
            drawer: const TimelineTeamListScreen(),
            backgroundColor: Colors.grey.shade900,
            body: RefreshIndicator(
              onRefresh: _onRefresh,
              child: DefaultTabController(
                length: 3,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
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
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "https://firebasestorage.googleapis.com/v0/b/golfbukun.appspot.com/o/avatars%2F${profile.uid}?alt=media&token=${Random().nextInt(100)}",
                                          fit: BoxFit.cover,
                                          errorWidget:
                                              (context, url, dynamic error) {
                                            return Center(
                                              child: const FaIcon(
                                                FontAwesomeIcons.user,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            );
                                          },
                                        ),
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
                                          reverse: true,
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
                                          'スコアをロードできません $error',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                              ),
                              Visibility(
                                maintainState: true,
                                visible: _tabController.index == 2,
                                child: ref.watch(scoreDataProvider).when(
                                      data: (scoreCardData) {
                                        return SizedBox(
                                          height: 3700,
                                          child: ListView(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            children: [
                                              ScoreCardDataTile(
                                                title: "登録ラウンド数",
                                                data: roundCount.toString(),
                                              ),
                                              ScoreCardDataTile(
                                                title: "平均スコア",
                                                data:
                                                    (scoreCardData.totalScore /
                                                            roundCount!)
                                                        .toStringAsFixed(1),
                                              ),
                                              ScoreCardDataTile(
                                                title: "平均パット数",
                                                data:
                                                    (scoreCardData.totalPutts /
                                                            roundCount)
                                                        .toStringAsFixed(1),
                                              ),
                                              ScoreCardDataTile(
                                                title: "1ラウンド平均ダブルボギー以上数",
                                                data: (scoreCardData
                                                            .overBogeyCount /
                                                        roundCount)
                                                    .toStringAsFixed(1),
                                              ),
                                              ScoreCardDataTile(
                                                title: "1ラウンド平均ボギー数",
                                                data:
                                                    (scoreCardData.bogeyCount /
                                                            roundCount)
                                                        .toStringAsFixed(1),
                                              ),
                                              ScoreCardDataTile(
                                                title: "1ラウンド平均パー数",
                                                data: (scoreCardData.parCount /
                                                        roundCount)
                                                    .toStringAsFixed(1),
                                              ),
                                              ScoreCardDataTile(
                                                title: "1ラウンド平均バーディー数",
                                                data:
                                                    (scoreCardData.birdieCount /
                                                            roundCount)
                                                        .toStringAsFixed(1),
                                              ),
                                              ScoreCardDataTile(
                                                title: "1ラウンド平均イーグル数",
                                                data: (scoreCardData
                                                            .underBirdieCount /
                                                        roundCount)
                                                    .toStringAsFixed(1),
                                              ),
                                              ScoreCardDataTile(
                                                title: "平均チップイン数",
                                                data: (scoreCardData
                                                            .approachChipIn /
                                                        roundCount)
                                                    .toStringAsFixed(1),
                                              ),
                                              ScoreCardDataTile(
                                                title: "Par3平均スコア",
                                                data: (scoreCardData
                                                            .averagePar3Score /
                                                        roundCount)
                                                    .toStringAsFixed(1),
                                              ),
                                              ScoreCardDataTile(
                                                title: "Par4平均スコア",
                                                data: (scoreCardData
                                                            .averagePar4Score /
                                                        roundCount)
                                                    .toStringAsFixed(1),
                                              ),
                                              ScoreCardDataTile(
                                                title: "Par5平均スコア",
                                                data: (scoreCardData
                                                            .averagePar5Score /
                                                        roundCount)
                                                    .toStringAsFixed(1),
                                              ),
                                              ScoreCardDataTile(
                                                title: "Fwキープ率",
                                                data:
                                                    "${(scoreCardData.totalFairwayFind / scoreCardData.totalFairwayTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "Fwより左のミス率",
                                                data:
                                                    "${(scoreCardData.teeShotMissedLeft / scoreCardData.totalFairwayTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "Fwより右のミス率",
                                                data:
                                                    "${(scoreCardData.teeShotMissedRight / scoreCardData.totalFairwayTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "DriverのFwキープ率",
                                                data:
                                                    "${(scoreCardData.driverFairwayFind / scoreCardData.driverFairwayTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "WoodのFwキープ率",
                                                data:
                                                    "${(scoreCardData.woodFairwayFind / scoreCardData.woodFairwayTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "UtilityのFwキープ率",
                                                data:
                                                    "${(scoreCardData.utilityFairwayFind / scoreCardData.utilityFairwayTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "IronのFwキープ率",
                                                data:
                                                    "${(scoreCardData.ironFairwayFind / scoreCardData.ironFairwayTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "平均パーオン率",
                                                data:
                                                    "${(scoreCardData.totalParOn / (roundCount * 18) * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "50ヤード内パーオン率",
                                                data:
                                                    "${(scoreCardData.greenInRegulationIn50 / scoreCardData.greenInRegulationIn50Try * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "100ヤード内パーオン率",
                                                data:
                                                    "${(scoreCardData.greenInRegulationIn100 / scoreCardData.greenInRegulationIn100Try * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "150ヤード内パーオン率",
                                                data:
                                                    "${(scoreCardData.greenInRegulationIn150 / scoreCardData.greenInRegulationIn150Try * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "200ヤード内パーオン率",
                                                data:
                                                    "${(scoreCardData.greenInRegulationIn200 / scoreCardData.greenInRegulationIn200Try * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "200ヤード以上パーオン率",
                                                data:
                                                    "${(scoreCardData.greenInRegulationOver200 / scoreCardData.greenInRegulationOver200Try * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "Woodのパーオン率",
                                                data:
                                                    "${(scoreCardData.parOnByWood / scoreCardData.parOnByWoodTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "Utilityのパーオン率",
                                                data:
                                                    "${(scoreCardData.parOnByUtility / scoreCardData.parOnByUtilityTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "Long ironのパーオン率",
                                                data:
                                                    "${(scoreCardData.parOnByLongIron / scoreCardData.parOnByLongIronTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "Middle ironのパーオン率",
                                                data:
                                                    "${(scoreCardData.parOnByMiddleIron / scoreCardData.parOnByMiddleIronTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "Short ironのパーオン率",
                                                data:
                                                    "${(scoreCardData.parOnByShortIron / scoreCardData.parOnByShortIronTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "Wedgeのパーオン率",
                                                data:
                                                    "${(scoreCardData.parOnByWedge / scoreCardData.parOnByWedgeTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "パター左に外す率",
                                                data:
                                                    "${(scoreCardData.puttMissedLeft / (scoreCardData.puttMissedLeft + scoreCardData.puttMissedRight) * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "パター右に外す率",
                                                data:
                                                    "${(scoreCardData.puttMissedRight / (scoreCardData.puttMissedLeft + scoreCardData.puttMissedRight) * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "パターのジャストタッチ率",
                                                data:
                                                    "${(scoreCardData.puttDistanceIn1m / scoreCardData.puttDistanceTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "パターのオーバー率",
                                                data:
                                                    "${(scoreCardData.puttDistanceLong / scoreCardData.puttDistanceTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "パターのショート率",
                                                data:
                                                    "${(scoreCardData.puttDistanceShort / scoreCardData.puttDistanceTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "2.5m以内パット成功率",
                                                data:
                                                    "${(scoreCardData.puttIn2and5mHoleIn / scoreCardData.puttIn2and5mTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "5m以内パット成功率",
                                                data:
                                                    "${(scoreCardData.puttIn5mHoleIn / scoreCardData.puttIn5mTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "10m以内パット成功率",
                                                data:
                                                    "${(scoreCardData.puttIn10mHoleIn / scoreCardData.puttIn10mTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "10m以上パット成功率",
                                                data:
                                                    "${(scoreCardData.puttIn10mHoleIn / scoreCardData.puttIn10mTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "1ラウンド平均アプローチセーブ数",
                                                data:
                                                    "${(scoreCardData.approachParSave / roundCount).toStringAsFixed(1)}",
                                              ),
                                              ScoreCardDataTile(
                                                title: "バンカーセーブ率",
                                                data:
                                                    "${(scoreCardData.bunkerParSave / scoreCardData.bunkerTry * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title: "平均バーディチャンス数",
                                                data:
                                                    "${scoreCardData.birdieChanceCount / roundCount}",
                                              ),
                                              ScoreCardDataTile(
                                                title: "平均バーディチャンス成功数",
                                                data:
                                                    "${scoreCardData.birdieChanceSuccess / roundCount}",
                                              ),
                                              ScoreCardDataTile(
                                                title: "平均バーディチャンス成功率",
                                                data:
                                                    "${(scoreCardData.birdieChanceSuccess / scoreCardData.birdieChanceCount * 100).toStringAsFixed(1)}%",
                                              ),
                                              ScoreCardDataTile(
                                                title:
                                                    "1ラウンドあたり平均100ヤード以内パーオン失敗数",
                                                data: (((scoreCardData
                                                                    .greenInRegulationIn50Try +
                                                                scoreCardData
                                                                    .greenInRegulationIn100Try) -
                                                            scoreCardData
                                                                .greenInRegulationIn50 -
                                                            scoreCardData
                                                                .greenInRegulationIn100) /
                                                        roundCount)
                                                    .toStringAsFixed(1),
                                              ),
                                              ScoreCardDataTile(
                                                title: "1ラウンドあたり平均3putt以上数",
                                                data: (scoreCardData
                                                            .missedOverThreePutts /
                                                        roundCount)
                                                    .toStringAsFixed(1),
                                              ),
                                              ScoreCardDataTile(
                                                title:
                                                    "1ラウンド平均グリーンサイドバンカーに入れた数",
                                                data: (scoreCardData
                                                            .missedIntoBunker /
                                                        roundCount)
                                                    .toStringAsFixed(1),
                                              ),
                                              ScoreCardDataTile(
                                                title: "1ラウンド平均OB数",
                                                data: (scoreCardData
                                                            .missedIntoOB /
                                                        roundCount)
                                                    .toStringAsFixed(1),
                                              ),
                                              ScoreCardDataTile(
                                                title: "1ラウンド平均Hazard数",
                                                data: (scoreCardData
                                                            .missedIntoWater /
                                                        roundCount)
                                                    .toStringAsFixed(1),
                                              ),
                                              ScoreCardDataTile(
                                                title: "1ラウンド平均Penalty数",
                                                data: (scoreCardData
                                                            .missedGetPenalty /
                                                        roundCount)
                                                    .toStringAsFixed(1),
                                              ),
                                            ],
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
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
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
