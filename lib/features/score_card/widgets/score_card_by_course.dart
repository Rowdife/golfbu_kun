import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:golfbu_kun/features/authentication/widgets/auth_button.dart';
import 'package:golfbu_kun/features/score_card/models/scroe_card_courses_model.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_categories.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_int_with_underline.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_row_elements.dart';

class ScoreCardByCourse extends ConsumerStatefulWidget {
  const ScoreCardByCourse(this.course, {Key? key}) : super(key: key);
  final ScoreCardcourseModel course;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScoreCardByCourseState();
}

class _ScoreCardByCourseState extends ConsumerState<ScoreCardByCourse> {
  List<GlobalKey<FormState>> formKeys = List.generate(
    18,
    (index) => GlobalKey<FormState>(),
  );
  String? selectedWeather = "晴れ"; // Added
  int? maxWindPerSecond = 1; // Added
  String? selectedTemperature = "ちょうどいい"; // Added

  void _onPreviewTap(BuildContext context) {
    for (GlobalKey<FormState> formkey in formKeys) {
      if (formkey.currentState!.validate()) {
        formkey.currentState!.save();
      } else {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.courseName),
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Gap(20),
                              Text(
                                "ScoreとPutt以外は任意ですが、\n入力した方が詳細なスコア分析ができます。\n記憶にないホールは空欄でも大丈夫です",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue),
                              ),
                            ],
                          ),
                          const Gap(20),
                          if (widget.course.description != null)
                            Row(
                              children: [
                                const Gap(20),
                                Text("追加説明: ${widget.course.description!}"),
                              ],
                            ),
                          const Gap(20),
                          Row(
                            children: [
                              const Gap(20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("天気",
                                      style: TextStyle(fontSize: 20)),
                                  DropdownButton(
                                    value: selectedWeather,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedWeather = value;
                                      });
                                    },
                                    items: const [
                                      DropdownMenuItem(
                                        value: '晴れ',
                                        child: Text(
                                          '晴れ',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: '雨',
                                        child: Text(
                                          '雨',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: '強風',
                                        child: Text(
                                          '強風',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                    dropdownColor: Colors.grey.shade900,
                                  ),
                                ],
                              ),
                              const Gap(50),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("最大風速",
                                      style: TextStyle(fontSize: 20)),
                                  DropdownButton<int>(
                                    value: maxWindPerSecond,
                                    onChanged: (value) {
                                      setState(() {
                                        maxWindPerSecond = value;
                                      });
                                    },
                                    items: [
                                      for (int i = 1; i <= 9; i++)
                                        DropdownMenuItem(
                                          value: i,
                                          child: Text(
                                            '$i m/s',
                                            style:
                                                const TextStyle(fontSize: 20),
                                          ),
                                        ),
                                      const DropdownMenuItem(
                                        value: 10,
                                        child: Text(
                                          '10 m/s 以上',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                    dropdownColor: Colors.grey.shade900,
                                  ),
                                ],
                              ),
                              const Gap(20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("気温",
                                      style: TextStyle(fontSize: 20)),
                                  DropdownButton(
                                    value: selectedTemperature,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedTemperature = value;
                                      });
                                    },
                                    items: const [
                                      DropdownMenuItem(
                                        value: '寒い',
                                        child: Text(
                                          '寒い',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: 'ちょうどいい',
                                        child: Text(
                                          'ちょうどいい',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      DropdownMenuItem(
                                        value: '暑い',
                                        child: Text(
                                          '暑い',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    ],
                                    dropdownColor: Colors.grey.shade900,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Gap(20),
                          const ScoreCategories(),
                          const Gap(10),
                          for (int i = 0;
                              i <= widget.course.parValues.length - 1;
                              i++)
                            Column(
                              children: [
                                Form(
                                  key: formKeys[i],
                                  child: ScoreRowElements(
                                    holeNumber: i,
                                    parNumber: widget.course.parValues[i],
                                  ),
                                ),
                                const Gap(20),
                              ],
                            ),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: GestureDetector(
                                onTap: () => _onPreviewTap(context),
                                child: const AuthButton(
                                    color: Colors.blue, text: "入力完了")),
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
