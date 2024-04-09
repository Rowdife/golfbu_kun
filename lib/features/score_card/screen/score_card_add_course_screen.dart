import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/profile/models/profile_model.dart';
import 'package:golfbu_kun/features/profile/vms/profiles_vm.dart';
import 'package:golfbu_kun/features/score_card/vms/score_card_courses_vm.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_course_model.dart';

List<String> prefectures = [
  '北海道',
  '青森県',
  '岩手県',
  '宮城県',
  '秋田県',
  '山形県',
  '福島県',
  '茨城県',
  '栃木県',
  '群馬県',
  '埼玉県',
  '千葉県',
  '東京都',
  '神奈川県',
  '新潟県',
  '富山県',
  '石川県',
  '福井県',
  '山梨県',
  '長野県',
  '岐阜県',
  '静岡県',
  '愛知県',
  '三重県',
  '滋賀県',
  '京都府',
  '大阪府',
  '兵庫県',
  '奈良県',
  '和歌山県',
  '鳥取県',
  '島根県',
  '岡山県',
  '広島県',
  '山口県',
  '徳島県',
  '香川県',
  '愛媛県',
  '高知県',
  '福岡県',
  '佐賀県',
  '長崎県',
  '熊本県',
  '大分県',
  '宮崎県',
  '鹿児島県',
  '沖縄県',
];

enum ParValue { par3, par4, par5 }

class ScoreCardAddcourseScreen extends ConsumerStatefulWidget {
  const ScoreCardAddcourseScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScoreCardAddcourseScreenState();
}

class _ScoreCardAddcourseScreenState
    extends ConsumerState<ScoreCardAddcourseScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedPrefecture = prefectures[12];
  String courseName = '';
  String courseNameByHiragana = '';
  String? description;
  List<int> holeParValues = List.generate(18, (index) => 4);

  void _onSavePressed(BuildContext context, ProfileModel profile) async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        await ref
            .read(scoreCardCourseProvider.notifier)
            .addNewCourse(ScoreCardCourseModel(
              courseName: courseName,
              courseNameByHiragana: courseNameByHiragana,
              prefecture: selectedPrefecture!,
              uploaderName: profile.name,
              uploaderUniversity: profile.university,
              uploaderUid: profile.uid,
              description: description,
              createdAt: DateTime.now().millisecondsSinceEpoch,
              parValues: holeParValues,
            ));
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("アップロード完了"),
            content: const Text("コースのアップロードが完了しました"),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                  context.pop();
                  context.pop();
                },
                child: const Text("OK"),
              ),
            ],
          ),
        );
      }

      // Save the form data to the database
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Course'),
      ),
      body: ref.watch(profileProvider).when(
            data: (profile) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView(
                  children: [
                    const Gap(10),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'コース名',
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return "名前を入力してください";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                courseName = value;
                              }
                            },
                          ),
                          const Gap(10),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'コース名ひらがなで',
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return "名前を入力してください";
                              }
                              return null;
                            },
                            onSaved: (value) {
                              if (value != null) {
                                courseNameByHiragana = value;
                              }
                            },
                          ),
                          const Gap(10),
                          // Add DropdownButton for selecting prefecture
                          DropdownButtonFormField(
                            decoration: InputDecoration(
                              labelText: '都道府県',
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                            value: selectedPrefecture,
                            onChanged: (newValue) {
                              setState(() {
                                selectedPrefecture = newValue;
                              });
                            },
                            items: prefectures.map((prefecture) {
                              return DropdownMenuItem<String>(
                                value: prefecture,
                                child: Text(
                                  prefecture,
                                  style: const TextStyle(
                                    color:
                                        Colors.white, // Set text color to white
                                  ),
                                ),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value != null && value.isEmpty) {
                                return "名前を入力してください";
                              }
                              return null;
                            },
                            dropdownColor: Colors.grey
                                .shade800, // Set background color to grey.shade800
                          ),
                          const Gap(10),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: '追加説明（任意）',
                              labelStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                              hintText: "関東学生Aブロックリーグ戦会場など",
                              hintStyle: TextStyle(
                                color: Colors.grey.withOpacity(0.4),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                            ),
                            onSaved: (value) {
                              setState(() {
                                description = value;
                              });
                            },
                          ),
                          const Gap(10),
                        ],
                      ),
                    ),
                    Center(
                      child: Column(
                        children: List.generate(
                          18,
                          (index) {
                            int holeNumber = index + 1;
                            return Row(
                              children: [
                                Text(
                                  'Hole $holeNumber',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Radio<int>(
                                        value: 3,
                                        groupValue:
                                            holeParValues[holeNumber - 1],
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              holeParValues[holeNumber - 1] =
                                                  value;
                                            });
                                          }
                                        },
                                      ),
                                      const Text('Par3'),
                                      Radio<int>(
                                        value: 4,
                                        groupValue:
                                            holeParValues[holeNumber - 1],
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              holeParValues[holeNumber - 1] =
                                                  value;
                                            });
                                          }
                                        },
                                      ),
                                      const Text('Par4'),
                                      Radio<int>(
                                        value: 5,
                                        groupValue:
                                            holeParValues[holeNumber - 1],
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              holeParValues[holeNumber - 1] =
                                                  value;
                                            });
                                          }
                                        },
                                      ),
                                      const Text('Par5'),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _onSavePressed(context, profile),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Text('Error: $error'),
            ),
          ),
    );
  }
}
