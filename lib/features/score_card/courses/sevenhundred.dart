import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_categories.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_int_with_underline.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_row_elements.dart';

class Sevenhundred extends ConsumerStatefulWidget {
  const Sevenhundred({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SevenhundredState();
}

class _SevenhundredState extends ConsumerState<Sevenhundred> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<DropdownMenuEntry<dynamic>> toTheHole = [
    const DropdownMenuEntry(value: "pin", label: "2.5ヤード以内"),
    const DropdownMenuEntry(value: "short", label: "５ヤード以内"),
    const DropdownMenuEntry(value: "middle", label: "10ヤード以内"),
    const DropdownMenuEntry(value: "long", label: "10ヤード以上")
  ];
  String isSelectedValue = 'あ';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("セブンハンドレッドクラブ"),
      ),
      body: SafeArea(
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
                    Form(
                      key: formKey,
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ScoreCategories(),
                          Gap(10),
                          ScoreRowElements(
                            holeNumber: '1',
                            parNumber: "4",
                          ),
                          ScoreRowElements(
                            holeNumber: '2',
                            parNumber: "4",
                          ),
                          ScoreRowElements(
                            holeNumber: '3',
                            parNumber: "5",
                          ),
                          ScoreRowElements(
                            holeNumber: '4',
                            parNumber: "3",
                          ),
                          ScoreRowElements(
                            holeNumber: '5',
                            parNumber: "4",
                          ),
                          ScoreRowElements(
                            holeNumber: '6',
                            parNumber: "4",
                          ),
                          ScoreRowElements(
                            holeNumber: '7',
                            parNumber: "5",
                          ),
                          ScoreRowElements(
                            holeNumber: '8',
                            parNumber: "3",
                          ),
                          ScoreRowElements(
                            holeNumber: '9',
                            parNumber: "4",
                          ),
                          ScoreRowElements(
                            holeNumber: '10',
                            parNumber: "4",
                          ),
                          ScoreRowElements(
                            holeNumber: '11',
                            parNumber: "4",
                          ),
                          ScoreRowElements(
                            holeNumber: '12',
                            parNumber: "4",
                          ),
                          ScoreRowElements(
                            holeNumber: '13',
                            parNumber: "3",
                          ),
                          ScoreRowElements(
                            holeNumber: '14',
                            parNumber: "5",
                          ),
                          ScoreRowElements(
                            holeNumber: '15',
                            parNumber: "4",
                          ),
                          ScoreRowElements(
                            holeNumber: '16',
                            parNumber: "4",
                          ),
                          ScoreRowElements(
                            holeNumber: '17',
                            parNumber: "3",
                          ),
                          ScoreRowElements(
                            holeNumber: '18',
                            parNumber: "5",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
