import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_course_model.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_model.dart';
import 'package:golfbu_kun/features/score_card/vms/score_card_courses_vm.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_button.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_card_preview.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_categories.dart';
import 'package:golfbu_kun/features/score_card/widgets/score_submit_button.dart';

class NewScorecard extends ConsumerStatefulWidget {
  const NewScorecard(this.course, {super.key});
  final ScoreCardCourseModel course;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewScorecardState();
}

class _NewScorecardState extends ConsumerState<NewScorecard>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  List<GlobalKey<FormState>> formKeys = List.generate(
    18,
    (index) => GlobalKey<FormState>(),
  );

  late final List<TextEditingController> strokeControllers;

  final List<TextEditingController> puttControllers =
      List.generate(18, (index) {
    return TextEditingController(text: "2");
  });

  final List<TextEditingController> obControllers = List.generate(18, (index) {
    return TextEditingController(text: "0");
  });

  final List<TextEditingController> hazardControllers =
      List.generate(18, (index) {
    return TextEditingController(text: "0");
  });

  final List<TextEditingController> parOnShotDistanceControllers =
      List.generate(18, (index) {
    return TextEditingController();
  });

  int totalParValueOfCoures = 72;
  int totalStroke = 0;

  List<bool> _guardBunkers = List.generate(18, (index) => false);

  List<DropdownMenuItem<String>> golfclubs = [
    DropdownMenuItem(value: null, child: Text("選択なし")),
    const DropdownMenuItem(
      value: "driver",
      child: Text(
        "driver",
      ),
    ),
    const DropdownMenuItem(
      value: "wood",
      child: Text(
        "wood",
      ),
    ),
    const DropdownMenuItem(
      value: "ut",
      child: Text(
        "ut",
      ),
    ),
    const DropdownMenuItem(
      value: "longiron",
      child: Text(
        "long iron",
      ),
    ),
    const DropdownMenuItem(
      value: "middleiron",
      child: Text(
        "middle iron",
      ),
    ),
    const DropdownMenuItem(
      value: "shortiron",
      child: Text(
        "short iron",
      ),
    ),
    const DropdownMenuItem(
      value: "wedge",
      child: Text(
        "wedge",
      ),
    ),
    const DropdownMenuItem(
      value: "putter",
      child: Text(
        "putter",
      ),
    ),
  ];

  final List<Map<String, dynamic>> _scoreData = List.generate(
      18,
      (index) => {
            "stroke": 0,
            "putt": 0,
            "puttRemained": "",
            "puttMissed": "",
            "puttDistance": "",
            "teeShotClub": "",
            "teeShotResult": "",
            "parOnShotDistance": "",
            "parOnShotClub": "",
            // 新スコアカードの追加項目, over, left, onGreen, right, short
            "parOnShotResult": "",
            "guardBunker": false,
            "ob": "",
            "hazard": "",
            "penalty": "",
          });

  _handleSelection() {
    if (_tabController!.indexIsChanging) {
      if (formKeys[_tabController!.previousIndex].currentState!.validate()) {
        formKeys[_tabController!.previousIndex].currentState!.save();
        ref.read(scoreCardForm.notifier).state.addAll({
          "hole${_tabController!.previousIndex + 1}":
              _scoreData[_tabController!.previousIndex]
        });
      }
      setState(() {});
    }
  }

  _onScoreSubmit() {
    if (formKeys[_tabController!.index].currentState!.validate()) {
      formKeys[_tabController!.index].currentState!.save();
      ref.read(scoreCardForm.notifier).state.addAll({
        "hole${_tabController!.index + 1}": _scoreData[_tabController!.index]
      });
      print(ref.read(scoreCardForm.notifier).state);
    }
    List unenteredHoles = [];
    final scoredata = ref.read(scoreCardForm.notifier).state;
    for (int i = 0; i < 18; i++) {
      if (scoredata["hole${i + 1}"] == null) {
        unenteredHoles.add(i + 1);
      }
    }
    if (unenteredHoles.isEmpty) {
      final ScoreCardModel scorecard =
          ScoreCardModel(scorecard: ref.read(scoreCardForm.notifier).state);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ScoreCardPreview(
            scorecard: scorecard,
            course: widget.course,
            weather: "晴れ",
            wind: 1,
            temperature: "fd",
            date: "2024-05-05",
          ),
        ),
      );
    } else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("未入力のホールがあります"),
              content: Text("ホール${unenteredHoles.join(",")}が未入力です"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "OK",
                    style: TextStyle(color: Colors.greenAccent),
                  ),
                )
              ],
            );
          });
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 18, vsync: this);
    _tabController!.addListener(_handleSelection);
    strokeControllers = List.generate(18, (index) {
      return TextEditingController(
          text: widget.course.parValues[index].toString());
    });
    ref.read(scoreCardForm.notifier).state.clear();
    strokeControllers.forEach((controller) {
      controller.addListener(() {
        int total = 0;
        strokeControllers.forEach((controller) {
          total += int.parse(controller.text);
        });
        setState(() {
          totalStroke = total - totalParValueOfCoures;
        });
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    return Scaffold(
      appBar: AppBar(
        title: Text(course.courseName),
      ),
      body: DefaultTabController(
        length: 18,
        child: SingleChildScrollView(
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: Colors.green,
                  indicatorColor: Colors.green,
                  dividerHeight: 0.5,
                  tabs: List.generate(
                    18,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        "Hole${index + 1}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                IndexedStack(
                  index: _tabController!.index,
                  children: List.generate(18, (index) {
                    return Visibility(
                      visible: _tabController!.index == index,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(children: [
                          Form(
                            key: formKeys[index],
                            child: Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      ScoreDataCategory(
                                        text: "${index + 1}H",
                                        width: 60,
                                        height: 50,
                                      ),
                                      Gap(10),
                                      ScoreDataCategory(
                                        text:
                                            "par${course.parValues[index].toString()}",
                                        width: 60,
                                        height: 50,
                                      ),
                                      Gap(10),
                                      ScoreDataCategory(
                                        text: "STATUS",
                                        width: 90,
                                        height: 50,
                                      ),
                                      Gap(10),
                                      ScoreDataCategory(
                                          text: totalStroke > 0
                                              ? "+$totalStroke"
                                              : "$totalStroke",
                                          width: 60,
                                          height: 50)
                                    ],
                                  ),
                                  Gap(10),
                                  Row(
                                    children: [
                                      ScoreDataCategory(
                                          text: "Score", width: 60, height: 50),
                                      Gap(10),
                                      CounterButton(
                                        isStroke: true,
                                        increase: false,
                                        controller: strokeControllers[index],
                                      ),
                                      SizedBox(
                                        width: 45,
                                        height: 45,
                                        child: Center(
                                          child: SizedBox(
                                            height: 100,
                                            child: TextFormField(
                                              enabled: false,
                                              controller:
                                                  strokeControllers[index],
                                              onSaved: (stroke) {
                                                if (stroke != null) {
                                                  _scoreData[index]["stroke"] =
                                                      stroke;
                                                }
                                              },
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return "入力必須";
                                                }
                                                if (int.tryParse(value) ==
                                                    null) {
                                                  return 'Please enter a valid number';
                                                }
                                                return null;
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              textAlign: TextAlign.center,
                                              maxLength: 2,
                                              decoration: InputDecoration(
                                                fillColor: Colors.white,
                                                counterText: "",
                                                border:
                                                    const OutlineInputBorder(),
                                                contentPadding:
                                                    const EdgeInsets.all(4),
                                                errorStyle: const TextStyle(
                                                    fontSize: 0.01),
                                                errorBorder: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                    color: Colors.red,
                                                    width: 1,
                                                    style: BorderStyle.solid,
                                                  ),
                                                ),
                                              ),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 28,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      CounterButton(
                                        isStroke: true,
                                        controller: strokeControllers[index],
                                        increase: true,
                                      ),
                                    ],
                                  ),
                                  Gap(10),
                                  widget.course.parValues[index] != 3
                                      ? ExpansionTileTheme(
                                          data: ExpansionTileThemeData(
                                            textColor: Colors.white,
                                            collapsedTextColor: Colors.white,
                                            iconColor: Colors.white,
                                            collapsedIconColor: Colors.white,
                                          ),
                                          child: ExpansionTile(
                                            title: Text(
                                              "ショット詳細入力",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            children: [
                                              Row(
                                                children: [
                                                  ScoreDataCategory(
                                                      text: "T.Shotクラブ",
                                                      width: 150,
                                                      height: 50),
                                                  Gap(10),
                                                  SizedBox(
                                                    width: 130,
                                                    height: 60,
                                                    child:
                                                        DropdownButtonFormField<
                                                            String?>(
                                                      onSaved: (teeShotClub) {
                                                        if (teeShotClub !=
                                                            null) {
                                                          _scoreData[index][
                                                                  "teeShotClub"] =
                                                              teeShotClub;
                                                        }
                                                      },
                                                      iconEnabledColor:
                                                          Colors.white,
                                                      dropdownColor:
                                                          Colors.grey.shade900,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                      onChanged:
                                                          (String? value) {
                                                        setState(() {});
                                                      },
                                                      items: golfclubs,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Gap(10),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Expanded(
                                                  child: Row(
                                                    children: [
                                                      ScoreDataCategory(
                                                        text: "T.Shot結果",
                                                        width: 150,
                                                        height: 50,
                                                      ),
                                                      Gap(10),
                                                      Expanded(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                          children: [
                                                            Column(
                                                              children: [
                                                                Text("左"),
                                                                Radio<String>(
                                                                  toggleable:
                                                                      true,
                                                                  value: "left",
                                                                  groupValue: _scoreData[
                                                                          index]
                                                                      [
                                                                      "teeShotResult"],
                                                                  onChanged:
                                                                      (String?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      _scoreData[index]
                                                                              [
                                                                              "teeShotResult"] =
                                                                          value;
                                                                    });
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                Text("Fairway"),
                                                                Radio<String>(
                                                                  toggleable:
                                                                      true,
                                                                  value: "fw",
                                                                  groupValue: _scoreData[
                                                                          index]
                                                                      [
                                                                      "teeShotResult"],
                                                                  onChanged:
                                                                      (String?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      _scoreData[index]
                                                                              [
                                                                              "teeShotResult"] =
                                                                          value;
                                                                    });
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                            Column(
                                                              children: [
                                                                Text("右"),
                                                                Radio<String>(
                                                                  toggleable:
                                                                      true,
                                                                  value:
                                                                      "right",
                                                                  groupValue: _scoreData[
                                                                          index]
                                                                      [
                                                                      "teeShotResult"],
                                                                  onChanged:
                                                                      (String?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      _scoreData[index]
                                                                              [
                                                                              "teeShotResult"] =
                                                                          value;
                                                                    });
                                                                  },
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
                                              Row(
                                                children: [
                                                  ScoreDataCategory(
                                                    text: "ParOn残距離",
                                                    width: 150,
                                                    height: 50,
                                                  ),
                                                  Gap(10),
                                                  SizedBox(
                                                    width: 100,
                                                    height: 45,
                                                    child: Center(
                                                      child: TextFormField(
                                                        controller:
                                                            parOnShotDistanceControllers[
                                                                index],
                                                        onSaved:
                                                            (parOnShotDistance) {
                                                          if (parOnShotDistance !=
                                                              null) {
                                                            _scoreData[index][
                                                                    "parOnShotDistance"] =
                                                                parOnShotDistance;
                                                          }
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLength: 3,
                                                        decoration:
                                                            InputDecoration(
                                                          fillColor:
                                                              Colors.white,
                                                          counterText: "",
                                                          border:
                                                              const OutlineInputBorder(),
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          errorStyle:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      0.01),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide:
                                                                const BorderSide(
                                                              color: Colors.red,
                                                              width: 1,
                                                              style: BorderStyle
                                                                  .solid,
                                                            ),
                                                          ),
                                                        ),
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 28,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Gap(10),
                                                  Text("ヤード"),
                                                ],
                                              ),
                                              Gap(10),
                                              Row(
                                                children: [
                                                  ScoreDataCategory(
                                                    text: "ParOnクラブ",
                                                    width: 150,
                                                    height: 50,
                                                  ),
                                                  Gap(10),
                                                  SizedBox(
                                                    width: 130,
                                                    height: 60,
                                                    child:
                                                        DropdownButtonFormField<
                                                            String?>(
                                                      onSaved: (parOnShotClub) {
                                                        if (parOnShotClub !=
                                                            null) {
                                                          _scoreData[index][
                                                                  "parOnShotClub"] =
                                                              parOnShotClub;
                                                        }
                                                      },
                                                      iconEnabledColor:
                                                          Colors.white,
                                                      dropdownColor:
                                                          Colors.grey.shade900,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                      onChanged:
                                                          (String? value) {
                                                        setState(() {});
                                                      },
                                                      items: golfclubs,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Gap(10),
                                              Row(
                                                children: [
                                                  ScoreDataCategory(
                                                    text: "parOn結果",
                                                    width: 120,
                                                    height: 50,
                                                  ),
                                                  Gap(10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text("オーバー"),
                                                          Radio<String>(
                                                            toggleable: true,
                                                            value: "over",
                                                            groupValue: _scoreData[
                                                                    index][
                                                                "parOnShotResult"],
                                                            onChanged: (String?
                                                                value) {
                                                              setState(() {
                                                                _scoreData[index]
                                                                        [
                                                                        "parOnShotResult"] =
                                                                    value;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Text("左"),
                                                                  Radio<String>(
                                                                    toggleable:
                                                                        true,
                                                                    value:
                                                                        "left",
                                                                    groupValue:
                                                                        _scoreData[index]
                                                                            [
                                                                            "parOnShotResult"],
                                                                    onChanged:
                                                                        (String?
                                                                            value) {
                                                                      setState(
                                                                          () {
                                                                        _scoreData[index]["parOnShotResult"] =
                                                                            value;
                                                                      });
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        border: Border
                                                                            .all(
                                                                          color:
                                                                              Colors.green,
                                                                          width:
                                                                              1,
                                                                        ),
                                                                        shape: BoxShape
                                                                            .circle),
                                                                child: SizedBox(
                                                                  width: 100,
                                                                  height: 100,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                          "グリーン"),
                                                                      Radio<
                                                                          String>(
                                                                        value:
                                                                            "onGreen",
                                                                        groupValue:
                                                                            _scoreData[index]["parOnShotResult"],
                                                                        onChanged:
                                                                            (String?
                                                                                value) {
                                                                          setState(
                                                                              () {
                                                                            _scoreData[index]["parOnShotResult"] =
                                                                                value;
                                                                          });
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Column(
                                                                children: [
                                                                  Text("右"),
                                                                  Radio<String>(
                                                                    toggleable:
                                                                        true,
                                                                    value:
                                                                        "right",
                                                                    groupValue:
                                                                        _scoreData[index]
                                                                            [
                                                                            "parOnShotResult"],
                                                                    onChanged:
                                                                        (String?
                                                                            value) {
                                                                      setState(
                                                                          () {
                                                                        _scoreData[index]["parOnShotResult"] =
                                                                            value;
                                                                      });
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text("ショート"),
                                                          Radio<String>(
                                                            toggleable: true,
                                                            value: "short",
                                                            groupValue: _scoreData[
                                                                    index][
                                                                "parOnShotResult"],
                                                            onChanged: (String?
                                                                value) {
                                                              setState(() {
                                                                _scoreData[index]
                                                                        [
                                                                        "parOnShotResult"] =
                                                                    value;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Gap(10),
                                            ],
                                          ),
                                        )
                                      : ExpansionTileTheme(
                                          data: ExpansionTileThemeData(
                                            textColor: Colors.white,
                                            collapsedTextColor: Colors.white,
                                            iconColor: Colors.white,
                                            collapsedIconColor: Colors.white,
                                          ),
                                          child: ExpansionTile(
                                            title: Text(
                                              "ショット詳細入力",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            children: [
                                              Row(
                                                children: [
                                                  ScoreDataCategory(
                                                    text: "ParOn残距離",
                                                    width: 150,
                                                    height: 50,
                                                  ),
                                                  Gap(10),
                                                  SizedBox(
                                                    width: 100,
                                                    height: 45,
                                                    child: Center(
                                                      child: TextFormField(
                                                        controller:
                                                            parOnShotDistanceControllers[
                                                                index],
                                                        onSaved:
                                                            (parOnShotDistance) {
                                                          if (parOnShotDistance !=
                                                              null) {
                                                            _scoreData[index][
                                                                    "parOnShotDistance"] =
                                                                parOnShotDistance;
                                                          }
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        textAlign:
                                                            TextAlign.center,
                                                        maxLength: 3,
                                                        decoration:
                                                            InputDecoration(
                                                          fillColor:
                                                              Colors.white,
                                                          counterText: "",
                                                          border:
                                                              const OutlineInputBorder(),
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .all(4),
                                                          errorStyle:
                                                              const TextStyle(
                                                                  fontSize:
                                                                      0.01),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            borderSide:
                                                                const BorderSide(
                                                              color: Colors.red,
                                                              width: 1,
                                                              style: BorderStyle
                                                                  .solid,
                                                            ),
                                                          ),
                                                        ),
                                                        style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 28,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Gap(10),
                                                  Text("ヤード"),
                                                ],
                                              ),
                                              Gap(10),
                                              Row(
                                                children: [
                                                  ScoreDataCategory(
                                                    text: "ParOnクラブ",
                                                    width: 150,
                                                    height: 50,
                                                  ),
                                                  Gap(10),
                                                  SizedBox(
                                                    width: 130,
                                                    height: 60,
                                                    child:
                                                        DropdownButtonFormField<
                                                            String?>(
                                                      onSaved: (parOnShotClub) {
                                                        if (parOnShotClub !=
                                                            null) {
                                                          _scoreData[index][
                                                                  "parOnShotClub"] =
                                                              parOnShotClub;
                                                        }
                                                      },
                                                      iconEnabledColor:
                                                          Colors.white,
                                                      dropdownColor:
                                                          Colors.grey.shade900,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                      onChanged:
                                                          (String? value) {
                                                        setState(() {});
                                                      },
                                                      items: golfclubs,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Gap(10),
                                              Row(
                                                children: [
                                                  ScoreDataCategory(
                                                    text: "parOn結果",
                                                    width: 120,
                                                    height: 50,
                                                  ),
                                                  Gap(10),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text("オーバー"),
                                                          Radio<String>(
                                                            toggleable: true,
                                                            value: "over",
                                                            groupValue: _scoreData[
                                                                    index][
                                                                "parOnShotResult"],
                                                            onChanged: (String?
                                                                value) {
                                                              setState(() {
                                                                _scoreData[index]
                                                                        [
                                                                        "parOnShotResult"] =
                                                                    value;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  Text("左"),
                                                                  Radio<String>(
                                                                    toggleable:
                                                                        true,
                                                                    value:
                                                                        "left",
                                                                    groupValue:
                                                                        _scoreData[index]
                                                                            [
                                                                            "parOnShotResult"],
                                                                    onChanged:
                                                                        (String?
                                                                            value) {
                                                                      setState(
                                                                          () {
                                                                        _scoreData[index]["parOnShotResult"] =
                                                                            value;
                                                                      });
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                        border: Border
                                                                            .all(
                                                                          color:
                                                                              Colors.green,
                                                                          width:
                                                                              1,
                                                                        ),
                                                                        shape: BoxShape
                                                                            .circle),
                                                                child: SizedBox(
                                                                  width: 100,
                                                                  height: 100,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Text(
                                                                          "グリーン"),
                                                                      Radio<
                                                                          String>(
                                                                        value:
                                                                            "onGreen",
                                                                        groupValue:
                                                                            _scoreData[index]["parOnShotResult"],
                                                                        onChanged:
                                                                            (String?
                                                                                value) {
                                                                          setState(
                                                                              () {
                                                                            _scoreData[index]["parOnShotResult"] =
                                                                                value;
                                                                          });
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                              Column(
                                                                children: [
                                                                  Text("右"),
                                                                  Radio<String>(
                                                                    toggleable:
                                                                        true,
                                                                    value:
                                                                        "right",
                                                                    groupValue:
                                                                        _scoreData[index]
                                                                            [
                                                                            "parOnShotResult"],
                                                                    onChanged:
                                                                        (String?
                                                                            value) {
                                                                      setState(
                                                                          () {
                                                                        _scoreData[index]["parOnShotResult"] =
                                                                            value;
                                                                      });
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          Text("ショート"),
                                                          Radio<String>(
                                                            toggleable: true,
                                                            value: "short",
                                                            groupValue: _scoreData[
                                                                    index][
                                                                "parOnShotResult"],
                                                            onChanged: (String?
                                                                value) {
                                                              setState(() {
                                                                _scoreData[index]
                                                                        [
                                                                        "parOnShotResult"] =
                                                                    value;
                                                              });
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Gap(10),
                                            ],
                                          ),
                                        ),
                                  Gap(10),
                                  Row(
                                    children: [
                                      ScoreDataCategory(
                                          text: "Putt", width: 60, height: 50),
                                      Gap(10),
                                      CounterButton(
                                          isStroke: false,
                                          controller: puttControllers[index],
                                          increase: false),
                                      SizedBox(
                                        width: 45,
                                        height: 45,
                                        child: Center(
                                          child: TextFormField(
                                            enabled: false,
                                            controller: puttControllers[index],
                                            onSaved: (putt) {
                                              if (putt != null) {
                                                _scoreData[index]["putt"] =
                                                    putt;
                                              }
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "入力必須";
                                              }
                                              if (int.tryParse(value) == null) {
                                                return 'Please enter a valid number';
                                              }
                                              return null;
                                            },
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            maxLength: 1,
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              counterText: "",
                                              border:
                                                  const OutlineInputBorder(),
                                              contentPadding:
                                                  const EdgeInsets.all(4),
                                              errorStyle: const TextStyle(
                                                  fontSize: 0.01),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width: 1,
                                                  style: BorderStyle.solid,
                                                ),
                                              ),
                                            ),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 28,
                                            ),
                                          ),
                                        ),
                                      ),
                                      CounterButton(
                                          isStroke: false,
                                          controller: puttControllers[index],
                                          increase: true),
                                    ],
                                  ),
                                  Gap(10),
                                  ExpansionTileTheme(
                                    data: ExpansionTileThemeData(
                                      textColor: Colors.white,
                                      collapsedTextColor: Colors.white,
                                      iconColor: Colors.white,
                                      collapsedIconColor: Colors.white,
                                    ),
                                    child: ExpansionTile(
                                      title: Text(
                                        "初打パット詳細入力",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      children: [
                                        Gap(10),
                                        Row(
                                          children: [
                                            ScoreDataCategory(
                                              text: "Putt残距離",
                                              width: 120,
                                              height: 50,
                                            ),
                                            Gap(10),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text("1pin以内"),
                                                      Radio<String>(
                                                        toggleable: true,
                                                        value: "pin",
                                                        groupValue: _scoreData[
                                                                index]
                                                            ["puttRemained"],
                                                        onChanged: (String?
                                                            puttRemained) {
                                                          setState(() {
                                                            _scoreData[index][
                                                                    "puttRemained"] =
                                                                puttRemained;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("5m以内"),
                                                      Radio<String>(
                                                        toggleable: true,
                                                        value: "short",
                                                        groupValue: _scoreData[
                                                                index]
                                                            ["puttRemained"],
                                                        onChanged: (String?
                                                            puttRemained) {
                                                          setState(() {
                                                            _scoreData[index][
                                                                    "puttRemained"] =
                                                                puttRemained;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("10m以内"),
                                                      Radio<String>(
                                                        toggleable: true,
                                                        value: "middle",
                                                        groupValue: _scoreData[
                                                                index]
                                                            ["puttRemained"],
                                                        onChanged: (String?
                                                            puttRemained) {
                                                          setState(() {
                                                            _scoreData[index][
                                                                    "puttRemained"] =
                                                                puttRemained;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("10m以上"),
                                                      Radio<String>(
                                                        toggleable: true,
                                                        value: "long",
                                                        groupValue: _scoreData[
                                                                index]
                                                            ["puttRemained"],
                                                        onChanged: (String?
                                                            puttRemained) {
                                                          setState(() {
                                                            _scoreData[index][
                                                                    "puttRemained"] =
                                                                puttRemained;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Gap(10),
                                        Row(
                                          children: [
                                            ScoreDataCategory(
                                                text: "Putt結果",
                                                width: 120,
                                                height: 50),
                                            Gap(10),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text("左"),
                                                      Radio<String>(
                                                        toggleable: true,
                                                        value: "left",
                                                        groupValue:
                                                            _scoreData[index]
                                                                ["puttMissed"],
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            _scoreData[index][
                                                                    "puttMissed"] =
                                                                value;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("ワンパット"),
                                                      Radio<String>(
                                                        toggleable: true,
                                                        value: "nomiss",
                                                        groupValue:
                                                            _scoreData[index]
                                                                ["puttMissed"],
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            _scoreData[index][
                                                                    "puttMissed"] =
                                                                value;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("右"),
                                                      Radio<String>(
                                                        toggleable: true,
                                                        value: "right",
                                                        groupValue:
                                                            _scoreData[index]
                                                                ["puttMissed"],
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            _scoreData[index][
                                                                    "puttMissed"] =
                                                                value;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("選択なし"),
                                                      Radio(
                                                        value: null,
                                                        groupValue:
                                                            _scoreData[index]
                                                                ["puttMissed"],
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _scoreData[index][
                                                                    "puttMissed"] =
                                                                value;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Gap(10),
                                        Row(
                                          children: [
                                            ScoreDataCategory(
                                                text: "Putt距離感",
                                                width: 120,
                                                height: 50),
                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text("ショート"),
                                                      Radio<String>(
                                                        toggleable: true,
                                                        value: "short",
                                                        groupValue: _scoreData[
                                                                index]
                                                            ["puttDistance"],
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            _scoreData[index][
                                                                    "puttDistance"] =
                                                                value;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("半径1m以内"),
                                                      Radio<String>(
                                                        toggleable: true,
                                                        value: "nomiss",
                                                        groupValue: _scoreData[
                                                                index]
                                                            ["puttDistance"],
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            _scoreData[index][
                                                                    "puttDistance"] =
                                                                value;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("ロング"),
                                                      Radio<String>(
                                                        toggleable: true,
                                                        value: "long",
                                                        groupValue: _scoreData[
                                                                index]
                                                            ["puttDistance"],
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            _scoreData[index][
                                                                    "puttDistance"] =
                                                                value;
                                                          });
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Gap(10),
                                      ],
                                    ),
                                  ),
                                  Gap(10),
                                  Row(
                                    children: [
                                      ScoreDataCategory(
                                        text: "Green Side Bunker",
                                        width: 200,
                                        height: 50,
                                      ),
                                      Gap(10),
                                      Transform.scale(
                                        scale: 2,
                                        child: Checkbox.adaptive(
                                            activeColor: Colors.green,
                                            value: _guardBunkers[index],
                                            onChanged: (_) {
                                              setState(() {
                                                _guardBunkers[index] =
                                                    !_guardBunkers[index];
                                              });
                                              _scoreData[index]["guardBunker"] =
                                                  _guardBunkers[index];
                                            }),
                                      ),
                                    ],
                                  ),
                                  Gap(10),
                                  Row(
                                    children: [
                                      ScoreDataCategory(
                                          text: "OB", width: 60, height: 50),
                                      Gap(10),
                                      CounterButton(
                                        isStroke: false,
                                        controller: obControllers[index],
                                        increase: false,
                                      ),
                                      SizedBox(
                                        width: 45,
                                        height: 45,
                                        child: Center(
                                          child: TextFormField(
                                            enabled: false,
                                            controller: obControllers[index],
                                            onSaved: (ob) {
                                              if (ob != null) {
                                                _scoreData[index]["ob"] = ob;
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            maxLength: 1,
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              counterText: "",
                                              border:
                                                  const OutlineInputBorder(),
                                              contentPadding:
                                                  const EdgeInsets.all(4),
                                              errorStyle: const TextStyle(
                                                  fontSize: 0.01),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width: 1,
                                                  style: BorderStyle.solid,
                                                ),
                                              ),
                                            ),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 28,
                                            ),
                                          ),
                                        ),
                                      ),
                                      CounterButton(
                                        isStroke: false,
                                        controller: obControllers[index],
                                        increase: true,
                                      ),
                                    ],
                                  ),
                                  Gap(10),
                                  Row(
                                    children: [
                                      ScoreDataCategory(
                                          text: "池", width: 60, height: 50),
                                      Gap(10),
                                      CounterButton(
                                        isStroke: false,
                                        controller: hazardControllers[index],
                                        increase: false,
                                      ),
                                      SizedBox(
                                        width: 45,
                                        height: 45,
                                        child: Center(
                                          child: TextFormField(
                                            enabled: false,
                                            controller:
                                                hazardControllers[index],
                                            onSaved: (hazard) {
                                              if (hazard != null) {
                                                _scoreData[index]["hazard"] =
                                                    hazard;
                                              }
                                            },
                                            keyboardType: TextInputType.number,
                                            textAlign: TextAlign.center,
                                            maxLength: 1,
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              counterText: "",
                                              border:
                                                  const OutlineInputBorder(),
                                              contentPadding:
                                                  const EdgeInsets.all(4),
                                              errorStyle: const TextStyle(
                                                  fontSize: 0.01),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: const BorderSide(
                                                  color: Colors.red,
                                                  width: 1,
                                                  style: BorderStyle.solid,
                                                ),
                                              ),
                                            ),
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 28,
                                            ),
                                          ),
                                        ),
                                      ),
                                      CounterButton(
                                        isStroke: false,
                                        controller: hazardControllers[index],
                                        increase: true,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SafeArea(
            child: GestureDetector(
              onTap: _onScoreSubmit,
              child: ScoreSubmitButton(color: Colors.green, text: "スコアを確認する"),
            ),
          ),
        ],
      ),
    );
  }
}

class CounterButton extends StatelessWidget {
  const CounterButton({
    super.key,
    required this.controller,
    required this.increase,
    required this.isStroke,
  });

  final TextEditingController controller;
  final bool increase;
  final bool isStroke;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: Colors.green,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: IconButton(
        onPressed: () {
          int currentValue = int.parse(controller.text);
          if (increase) {
            controller.text = (currentValue + 1).toString();
          } else {
            if (isStroke && currentValue == 1) return;
            if (!isStroke && currentValue == 0) return;

            controller.text = (currentValue - 1).toString();
          }
        },
        icon: increase
            ? Icon(
                Icons.add,
                color: Colors.white,
                size: 34,
              )
            : Icon(
                Icons.remove,
                color: Colors.white,
                size: 34,
              ),
      ),
    );
  }
}

class ScoreDataCategory extends StatelessWidget {
  const ScoreDataCategory({
    super.key,
    required this.text,
    required this.width,
    required this.height,
  });

  final String text;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: Colors.green,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
