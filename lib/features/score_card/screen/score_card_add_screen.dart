import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_course_model.dart';
import 'package:golfbu_kun/features/score_card/widgets/new_scorecard.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_card_by_course.dart';
import 'package:golfbu_kun/features/score_card/vms/score_card_courses_vm.dart';
import 'package:golfbu_kun/features/score_card/screen/score_card_add_course_screen.dart';

class ScoreCardAddScreen extends ConsumerStatefulWidget {
  static const routeName = "addscore";
  static const routeUrl = "/addscore";
  const ScoreCardAddScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScoreCardAddScreenState();
}

class _ScoreCardAddScreenState extends ConsumerState<ScoreCardAddScreen> {
  void _onCourseTap(BuildContext context, ScoreCardCourseModel course) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewScorecard(course),
      ),
    );
  }

  void _addNewCourse(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ScoreCardAddcourseScreen(),
      ),
    );
  }

  void _fetchCourses() {
    ref.read(scoreCardCourseProvider.notifier).fetchCourses();
  }

  @override
  void initState() {
    _fetchCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text("スコアを登録"),
      ),
      body: ref.watch(scoreCardCourseProvider).when(
            data: (courses) {
              return Center(
                child: Container(
                  color: Colors.black54,
                  width: size.width * 0.8,
                  height: size.height * 0.8,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: courses.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () =>
                                  _onCourseTap(context, courses[index]),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    courses[index].courseName,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  if (courses[index].description != null)
                                    Text(
                                      courses[index].description!,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    )
                                ],
                              ),
                              trailing: const FaIcon(
                                FontAwesomeIcons.chevronRight,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _addNewCourse(context),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.plus,
                              color: Colors.white,
                            ),
                            Gap(10),
                            Text(
                              "新しいコースを追加",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const Gap(30)
                    ],
                  ),
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text(error.toString())),
          ),
    );
  }
}
