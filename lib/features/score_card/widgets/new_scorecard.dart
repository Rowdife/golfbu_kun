import 'dart:convert';

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
import 'package:shared_preferences/shared_preferences.dart';

class NewScorecard extends ConsumerStatefulWidget {
  const NewScorecard(
    this.course, {
    this.tempScore,
    super.key,
  });
  final ScoreCardCourseModel course;
  final Map? tempScore;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewScorecardState();
}

class _NewScorecardState extends ConsumerState<NewScorecard>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
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

  final List<TextEditingController> penaltyControllers =
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

  _saveScoreByHole() {
    if (formKeys[_tabController!.index].currentState!.validate()) {
      formKeys[_tabController!.index].currentState!.save();

      ref.read(scoreCardForm.notifier).state.addAll({
        "hole${_tabController!.index + 1}": _scoreData[_tabController!.index]
      });
    }
    setState(() {});
  }

  _handleTabSelection() {
    if (formKeys[_tabController!.index].currentState!.validate()) {
      formKeys[_tabController!.index].currentState!.save();
      ref.read(scoreCardForm.notifier).state.addAll({
        "hole${_tabController!.index + 1}": _scoreData[_tabController!.index]
      });
    }
    setState(() {});
  }

  _onScoreSubmit() {
    if (formKeys[_tabController!.index].currentState!.validate()) {
      formKeys[_tabController!.index].currentState!.save();
      ref.read(scoreCardForm.notifier).state.addAll({
        "hole${_tabController!.index + 1}": _scoreData[_tabController!.index]
      });
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

  Future<void> _saveTempScorecard() async {
    final prefs = await SharedPreferences.getInstance();
    final scorecard = ref.read(scoreCardForm.notifier).state;

    String jsonData = jsonEncode(scorecard);

    prefs.setString("temporary_scorecard", jsonData);
    // String? jsonData2 = prefs.getString("temporary_scorecard");
    // if (jsonData2 != null) {
    //   print(jsonDecode(jsonData2));
    // }
  }

  Future<void> _loadTempScorecard() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString("temporary_scorecard");
    if (jsonData != null) {
      Map<String, dynamic> scorecard = jsonDecode(jsonData);
      print(scorecard);
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 18, vsync: this);
    _tabController!.addListener(() {
      if (!_tabController!.indexIsChanging) {
        _handleTabSelection();
      }
      setState(() {});
    });
    strokeControllers = List.generate(18, (index) {
      return TextEditingController(
          text: widget.course.parValues[index].toString());
    });
    ref.read(scoreCardForm.notifier).state.clear();
    ref.read(scoreCardForm.notifier).state['course'] = widget.course.toJson();
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

    if (widget.tempScore != null) {
      final tempScoreData = widget.tempScore!;
      print("printing tempScoreData at initState");
      print(tempScoreData);
      Map<int, dynamic> transformedScorecard = {};

      // 기존 Map을 순회하며 키 변환
      tempScoreData.forEach((key, value) {
        // 'hole'을 제거하고 숫자로 변환
        int newKey = int.parse(key.replaceFirst('hole', '')) - 1;
        transformedScorecard[newKey] = value;
      });
      print("transformed card");
      print(transformedScorecard);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController!.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      print("I'm inactive");
      _saveTempScorecard();
    } else if (state == AppLifecycleState.resumed) {
      _loadTempScorecard();
      print(strokeControllers[0].text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final course = widget.course;
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) {
          return;
        }
        final NavigatorState navigator = Navigator.of(context);
        final bool? shouldPop = await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  "入力中のスコアカードがあります。",
                  style: TextStyle(color: Colors.white),
                ),
                content: Text(
                  "引き続き入力しますか？",
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.grey.shade900,
                actions: [
                  TextButton(
                    onPressed: () {
                      _saveTempScorecard();
                      Navigator.of(context).pop(false);
                    },
                    child: const Text(
                      "入力中のスコアカードへ",
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _saveTempScorecard();
                      Navigator.of(context).pop(true);
                    },
                    child: const Text(
                      "保存して戻る",
                      style: TextStyle(color: Colors.greenAccent),
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();

                      Navigator.of(context).pop(true);
                      prefs.remove("temporary_scorecard");
                    },
                    child: const Text(
                      "破棄する",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              );
            }); // ダイアログで戻るか確認
        if (shouldPop ?? false) {
          navigator.pop(); // 戻るを選択した場合のみpopを明示的に呼ぶ
        }
      },
      child: Scaffold(
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
                              child: Flexible(
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
                                            text: "Score",
                                            width: 60,
                                            height: 50),
                                        Gap(10),
                                        CounterButton(
                                          onTap: () {
                                            _saveScoreByHole();
                                          },
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
                                                    _scoreData[index]
                                                        ["stroke"] = stroke;
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
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
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
                                          onTap: () {
                                            _saveScoreByHole();
                                          },
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                        dropdownColor: Colors
                                                            .grey.shade900,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                        onChanged:
                                                            (String? value) {
                                                          setState(() {
                                                            _scoreData[index][
                                                                    "teeShotClub"] =
                                                                value;
                                                          });
                                                          _saveScoreByHole();
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
                                                                    _saveScoreByHole();
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
                                                                    _saveScoreByHole();
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
                                                                    _saveScoreByHole();
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
                                                Row(
                                                  children: [
                                                    ScoreDataCategory(
                                                      text: "ParOn残距離",
                                                      width: 150,
                                                      height: 50,
                                                    ),
                                                    Gap(10),
                                                    Flexible(
                                                      child: SizedBox(
                                                        width: 100,
                                                        height: 45,
                                                        child: Center(
                                                          child: TextFormField(
                                                            controller:
                                                                parOnShotDistanceControllers[
                                                                    index],
                                                            onChanged: (value) {
                                                              setState(() {
                                                                _scoreData[index]
                                                                        [
                                                                        "parOnShotDistance"] =
                                                                    value;
                                                              });
                                                              _saveScoreByHole();
                                                            },
                                                            onSaved:
                                                                (parOnShotDistance) {
                                                              if (parOnShotDistance !=
                                                                  null) {
                                                                _scoreData[index]
                                                                        [
                                                                        "parOnShotDistance"] =
                                                                    parOnShotDistance;
                                                              }
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            textAlign: TextAlign
                                                                .center,
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
                                                                  color: Colors
                                                                      .red,
                                                                  width: 1,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid,
                                                                ),
                                                              ),
                                                            ),
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 28,
                                                            ),
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
                                                    Flexible(
                                                      child: SizedBox(
                                                        width: 130,
                                                        height: 60,
                                                        child:
                                                            DropdownButtonFormField<
                                                                String?>(
                                                          onSaved:
                                                              (parOnShotClub) {
                                                            if (parOnShotClub !=
                                                                null) {
                                                              _scoreData[index][
                                                                      "parOnShotClub"] =
                                                                  parOnShotClub;
                                                            }
                                                          },
                                                          iconEnabledColor:
                                                              Colors.white,
                                                          dropdownColor: Colors
                                                              .grey.shade900,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                          onChanged:
                                                              (String? value) {
                                                            setState(() {
                                                              _scoreData[index][
                                                                      "parOnShotClub"] =
                                                                  value;
                                                            });
                                                            _saveScoreByHole();
                                                          },
                                                          items: golfclubs,
                                                        ),
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
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Text("オーバー"),
                                                              Radio<String>(
                                                                toggleable:
                                                                    true,
                                                                value: "over",
                                                                groupValue:
                                                                    _scoreData[
                                                                            index]
                                                                        [
                                                                        "parOnShotResult"],
                                                                onChanged:
                                                                    (String?
                                                                        value) {
                                                                  setState(() {
                                                                    _scoreData[index]
                                                                            [
                                                                            "parOnShotResult"] =
                                                                        value;
                                                                  });
                                                                  _saveScoreByHole();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Column(
                                                                    children: [
                                                                      Text("左"),
                                                                      Radio<
                                                                          String>(
                                                                        toggleable:
                                                                            true,
                                                                        value:
                                                                            "left",
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
                                                                          _saveScoreByHole();
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors.green,
                                                                              width: 1,
                                                                            ),
                                                                            shape: BoxShape.circle),
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
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
                                                                                (String? value) {
                                                                              setState(() {
                                                                                _scoreData[index]["parOnShotResult"] = value;
                                                                              });
                                                                              _saveScoreByHole();
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Text("右"),
                                                                      Radio<
                                                                          String>(
                                                                        toggleable:
                                                                            true,
                                                                        value:
                                                                            "right",
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
                                                                          _saveScoreByHole();
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
                                                                toggleable:
                                                                    true,
                                                                value: "short",
                                                                groupValue:
                                                                    _scoreData[
                                                                            index]
                                                                        [
                                                                        "parOnShotResult"],
                                                                onChanged:
                                                                    (String?
                                                                        value) {
                                                                  setState(() {
                                                                    _scoreData[index]
                                                                            [
                                                                            "parOnShotResult"] =
                                                                        value;
                                                                  });
                                                                  _saveScoreByHole();
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    Flexible(
                                                      child: SizedBox(
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
                                                                _scoreData[index]
                                                                        [
                                                                        "parOnShotDistance"] =
                                                                    parOnShotDistance;
                                                              }
                                                            },
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            textAlign: TextAlign
                                                                .center,
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
                                                                  color: Colors
                                                                      .red,
                                                                  width: 1,
                                                                  style:
                                                                      BorderStyle
                                                                          .solid,
                                                                ),
                                                              ),
                                                            ),
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 28,
                                                            ),
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
                                                    Flexible(
                                                      child: SizedBox(
                                                        width: 130,
                                                        height: 60,
                                                        child:
                                                            DropdownButtonFormField<
                                                                String?>(
                                                          onSaved:
                                                              (parOnShotClub) {
                                                            if (parOnShotClub !=
                                                                null) {
                                                              _scoreData[index][
                                                                      "parOnShotClub"] =
                                                                  parOnShotClub;
                                                            }
                                                          },
                                                          iconEnabledColor:
                                                              Colors.white,
                                                          dropdownColor: Colors
                                                              .grey.shade900,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                          onChanged:
                                                              (String? value) {
                                                            setState(() {
                                                              _scoreData[index][
                                                                      "parOnShotClub"] =
                                                                  value;
                                                            });
                                                            _saveScoreByHole();
                                                          },
                                                          items: golfclubs,
                                                        ),
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
                                                    Flexible(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Text("オーバー"),
                                                              Radio<String>(
                                                                toggleable:
                                                                    true,
                                                                value: "over",
                                                                groupValue:
                                                                    _scoreData[
                                                                            index]
                                                                        [
                                                                        "parOnShotResult"],
                                                                onChanged:
                                                                    (String?
                                                                        value) {
                                                                  setState(() {
                                                                    _scoreData[index]
                                                                            [
                                                                            "parOnShotResult"] =
                                                                        value;
                                                                  });
                                                                  _saveScoreByHole();
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
                                                                      Radio<
                                                                          String>(
                                                                        toggleable:
                                                                            true,
                                                                        value:
                                                                            "left",
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
                                                                          _saveScoreByHole();
                                                                        },
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            border:
                                                                                Border.all(
                                                                              color: Colors.green,
                                                                              width: 1,
                                                                            ),
                                                                            shape: BoxShape.circle),
                                                                    child:
                                                                        SizedBox(
                                                                      width:
                                                                          100,
                                                                      height:
                                                                          100,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
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
                                                                                (String? value) {
                                                                              setState(() {
                                                                                _scoreData[index]["parOnShotResult"] = value;
                                                                              });
                                                                              _saveScoreByHole();
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    children: [
                                                                      Text("右"),
                                                                      Radio<
                                                                          String>(
                                                                        toggleable:
                                                                            true,
                                                                        value:
                                                                            "right",
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
                                                                          _saveScoreByHole();
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
                                                                toggleable:
                                                                    true,
                                                                value: "short",
                                                                groupValue:
                                                                    _scoreData[
                                                                            index]
                                                                        [
                                                                        "parOnShotResult"],
                                                                onChanged:
                                                                    (String?
                                                                        value) {
                                                                  setState(() {
                                                                    _scoreData[index]
                                                                            [
                                                                            "parOnShotResult"] =
                                                                        value;
                                                                  });
                                                                  _saveScoreByHole();
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
                                              ],
                                            ),
                                          ),
                                    Gap(10),
                                    Row(
                                      children: [
                                        ScoreDataCategory(
                                            text: "Putt",
                                            width: 60,
                                            height: 50),
                                        Gap(10),
                                        CounterButton(
                                            onTap: () {
                                              _saveScoreByHole();
                                            },
                                            isStroke: false,
                                            controller: puttControllers[index],
                                            increase: false),
                                        Flexible(
                                          child: SizedBox(
                                            width: 45,
                                            height: 45,
                                            child: Center(
                                              child: TextFormField(
                                                enabled: false,
                                                controller:
                                                    puttControllers[index],
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
                                                  if (int.tryParse(value) ==
                                                      null) {
                                                    return 'Please enter a valid number';
                                                  }
                                                  return null;
                                                },
                                                keyboardType:
                                                    TextInputType.number,
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
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
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
                                            onTap: () {
                                              _saveScoreByHole();
                                            },
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
                                              Flexible(
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
                                                            _saveScoreByHole();
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
                                                            _saveScoreByHole();
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
                                                            _saveScoreByHole();
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
                                                            _saveScoreByHole();
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
                                              Flexible(
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
                                                              _scoreData[index][
                                                                  "puttMissed"],
                                                          onChanged:
                                                              (String? value) {
                                                            setState(() {
                                                              _scoreData[index][
                                                                      "puttMissed"] =
                                                                  value;
                                                            });
                                                            _saveScoreByHole();
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
                                                              _scoreData[index][
                                                                  "puttMissed"],
                                                          onChanged:
                                                              (String? value) {
                                                            setState(() {
                                                              _scoreData[index][
                                                                      "puttMissed"] =
                                                                  value;
                                                            });
                                                            _saveScoreByHole();
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
                                                              _scoreData[index][
                                                                  "puttMissed"],
                                                          onChanged:
                                                              (String? value) {
                                                            setState(() {
                                                              _scoreData[index][
                                                                      "puttMissed"] =
                                                                  value;
                                                            });
                                                            _saveScoreByHole();
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
                                                              _scoreData[index][
                                                                  "puttMissed"],
                                                          onChanged: (value) {
                                                            setState(() {
                                                              _scoreData[index][
                                                                      "puttMissed"] =
                                                                  value;
                                                            });
                                                            _saveScoreByHole();
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
                                              Flexible(
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
                                                            _saveScoreByHole();
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
                                                            _saveScoreByHole();
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
                                                            _saveScoreByHole();
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
                                                _saveScoreByHole();
                                                setState(() {
                                                  _guardBunkers[index] =
                                                      !_guardBunkers[index];
                                                });
                                                _scoreData[index]
                                                        ["guardBunker"] =
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
                                          onTap: () {
                                            _saveScoreByHole();
                                          },
                                          isStroke: false,
                                          controller: obControllers[index],
                                          increase: false,
                                        ),
                                        Flexible(
                                          child: SizedBox(
                                            width: 45,
                                            height: 45,
                                            child: Center(
                                              child: TextFormField(
                                                enabled: false,
                                                controller:
                                                    obControllers[index],
                                                onSaved: (ob) {
                                                  if (ob != null) {
                                                    _scoreData[index]["ob"] =
                                                        ob;
                                                  }
                                                },
                                                keyboardType:
                                                    TextInputType.number,
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
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
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
                                          onTap: () {
                                            _saveScoreByHole();
                                          },
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
                                          onTap: () {
                                            _saveScoreByHole();
                                          },
                                          isStroke: false,
                                          controller: hazardControllers[index],
                                          increase: false,
                                        ),
                                        Flexible(
                                          child: SizedBox(
                                            width: 45,
                                            height: 45,
                                            child: Center(
                                              child: TextFormField(
                                                enabled: false,
                                                controller:
                                                    hazardControllers[index],
                                                onSaved: (hazard) {
                                                  if (hazard != null) {
                                                    _scoreData[index]
                                                        ["hazard"] = hazard;
                                                  }
                                                },
                                                keyboardType:
                                                    TextInputType.number,
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
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
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
                                          onTap: () {
                                            _saveScoreByHole();
                                          },
                                          isStroke: false,
                                          controller: hazardControllers[index],
                                          increase: true,
                                        ),
                                      ],
                                    ),
                                    Gap(10),
                                    Row(
                                      children: [
                                        ScoreDataCategory(
                                            text: "罰打", width: 60, height: 50),
                                        Gap(10),
                                        CounterButton(
                                          onTap: () {
                                            _saveScoreByHole();
                                          },
                                          isStroke: false,
                                          controller: penaltyControllers[index],
                                          increase: false,
                                        ),
                                        Flexible(
                                          child: SizedBox(
                                            width: 45,
                                            height: 45,
                                            child: Center(
                                              child: TextFormField(
                                                enabled: false,
                                                controller:
                                                    penaltyControllers[index],
                                                onSaved: (penalty) {
                                                  if (penalty != null) {
                                                    _scoreData[index]
                                                        ["penalty"] = penalty;
                                                  }
                                                },
                                                keyboardType:
                                                    TextInputType.number,
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
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    borderSide:
                                                        const BorderSide(
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
                                          onTap: () {
                                            _saveScoreByHole();
                                          },
                                          isStroke: false,
                                          controller: penaltyControllers[index],
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
    this.onTap,
  });

  final TextEditingController controller;
  final bool increase;
  final bool isStroke;
  final Function? onTap;
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
          if (onTap != null) {
            onTap!();
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
