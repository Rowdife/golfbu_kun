import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:golfbu_kun/features/score_card/vms/score_card_courses_vm.dart';

class ScoreRowElements extends ConsumerStatefulWidget {
  const ScoreRowElements({
    super.key,
    required this.holeNumber,
    required this.parNumber,
  });

  final int holeNumber;
  final int parNumber;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScoreRowElementsState();
}

class _ScoreRowElementsState extends ConsumerState<ScoreRowElements> {
  final TextEditingController strokeController =
      TextEditingController(text: "4");
  final TextEditingController puttController = TextEditingController(text: "2");

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

  bool _guardBunker = false;
  final Map<String, dynamic> _scoreData = {
    "stroke": 0,
    "putt": 0,
    "puttRemained": "",
    "puttMissed": "",
    "puttDistance": "",
    "teeShotClub": "",
    "teeShotResult": "",
    "parOnShotDistance": "",
    "parOnShotClub": "",
    "guardBunker": false,
    "ob": "",
    "hazard": "",
    "penalty": "",
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.holeNumber % 2 == 0
          ? Colors.grey.shade900
          : Colors.grey.shade800,
      width: 2000,
      height: 80,
      child: Row(
        children: [
          const Gap(30),
          SizedBox(
            width: 40,
            child: Center(
              child: Text(
                "${widget.holeNumber + 1}",
                style: const TextStyle(fontSize: 29),
              ),
            ),
          ),
          const Gap(50),
          SizedBox(
            width: 40,
            child: Center(
              child: Text(
                "${widget.parNumber}",
                style: const TextStyle(fontSize: 29),
              ),
            ),
          ),
          const Gap(15),
          Container(
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
                int currentValue = int.parse(strokeController.text);
                strokeController.text = (currentValue - 1).toString();
              },
              icon: Icon(
                Icons.remove,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
          SizedBox(
            width: 45,
            height: 45,
            child: Center(
              child: SizedBox(
                height: 100,
                child: TextFormField(
                  enabled: false,
                  controller: strokeController,
                  onSaved: (stroke) {
                    if (stroke != null) {
                      _scoreData["stroke"] = stroke;
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "入力必須";
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 2,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    counterText: "",
                    border: const OutlineInputBorder(),
                    contentPadding: const EdgeInsets.all(4),
                    errorStyle: const TextStyle(fontSize: 0.01),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
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
          Container(
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
              padding: EdgeInsets.zero,
              onPressed: () {
                int currentValue = int.parse(strokeController.text);
                strokeController.text = (currentValue + 1).toString();
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
          Gap(20),
          Container(
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
                int currentValue = int.parse(puttController.text);
                puttController.text = (currentValue - 1).toString();
              },
              icon: Icon(
                Icons.remove,
                color: Colors.white,
                size: 34,
              ),
            ),
          ),
          SizedBox(
            width: 45,
            height: 45,
            child: Center(
              child: TextFormField(
                enabled: false,
                controller: puttController,
                onSaved: (putt) {
                  if (putt != null) {
                    _scoreData["putt"] = putt;
                  }
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
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
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.all(4),
                  errorStyle: const TextStyle(fontSize: 0.01),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
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
          Container(
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
                  int currentValue = int.parse(puttController.text);
                  puttController.text = (currentValue + 1).toString();
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 34,
                )),
          ),
          const Gap(20),
          SizedBox(
            width: 160,
            height: 60,
            child: DropdownButtonFormField<String?>(
              onSaved: (puttRemained) {
                if (puttRemained != null) {
                  _scoreData["puttRemained"] = puttRemained;
                }
              },
              iconEnabledColor: Colors.white,
              dropdownColor: Colors.grey.shade900,
              style: const TextStyle(color: Colors.white),
              onChanged: (String? value) {
                setState(() {});
              },
              items: const [
                DropdownMenuItem(value: null, child: Text("選択なし")),
                DropdownMenuItem(
                  // Change the type of DropdownMenuItem to int
                  value: "pin", // Change the value type to int
                  child: Text(
                    "1ピン以内(2.5m)",
                  ),
                ),
                DropdownMenuItem(
                  // Change the type of DropdownMenuItem to int
                  value: "short", // Change the value type to int
                  child: Text(
                    "５m以内",
                  ),
                ),
                DropdownMenuItem(
                  // Change the type of DropdownMenuItem to int
                  value: "middle", // Change the value type to int
                  child: Text(
                    "10m以内",
                  ),
                ),
                DropdownMenuItem(
                  // Change the type of DropdownMenuItem to int
                  value: "long", // Change the value type to int
                  child: Text(
                    "10m以上",
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),
          SizedBox(
            width: 120,
            height: 60,
            child: DropdownButtonFormField<String?>(
              onSaved: (puttMissed) {
                if (puttMissed != null) {
                  _scoreData["puttMissed"] = puttMissed;
                }
              },
              iconEnabledColor: Colors.white,
              dropdownColor: Colors.grey.shade900,
              style: const TextStyle(color: Colors.white),
              onChanged: (String? value) {
                setState(() {});
              },
              items: const [
                DropdownMenuItem(value: null, child: Text("選択なし")),
                DropdownMenuItem(
                  value: "nomiss",
                  child: Text(
                    "カップイン",
                  ),
                ),
                DropdownMenuItem(
                  value: "left",
                  child: Text(
                    "左外し←",
                  ),
                ),
                DropdownMenuItem(
                  value: "right",
                  child: Text(
                    "右外し→",
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),
          SizedBox(
            width: 130,
            height: 60,
            child: DropdownButtonFormField<String?>(
              onSaved: (putt) {
                if (putt != null) {
                  _scoreData["puttDistance"] = putt;
                }
              },
              iconEnabledColor: Colors.white,
              dropdownColor: Colors.grey.shade900,
              style: const TextStyle(color: Colors.white),
              onChanged: (String? value) {
                setState(() {});
              },
              items: const [
                DropdownMenuItem(value: null, child: Text("選択なし")),
                DropdownMenuItem(
                  value: "nomiss",
                  child: Text(
                    "半径1m以内",
                  ),
                ),
                DropdownMenuItem(
                  value: "short",
                  child: Text(
                    "ショート",
                  ),
                ),
                DropdownMenuItem(
                  value: "long",
                  child: Text(
                    "ロング",
                  ),
                ),
              ],
            ),
          ),
          const Gap(20),
          SizedBox(
            width: 130,
            height: 60,
            child: DropdownButtonFormField<String?>(
              onSaved: (teeShotClub) {
                if (teeShotClub != null) {
                  _scoreData["teeShotClub"] = teeShotClub;
                }
              },
              iconEnabledColor: Colors.white,
              dropdownColor: Colors.grey.shade900,
              style: const TextStyle(color: Colors.white),
              onChanged: (String? value) {
                setState(() {});
              },
              items: golfclubs,
            ),
          ),
          const Gap(20),
          SizedBox(
            width: 130,
            height: 60,
            child: DropdownButtonFormField<String?>(
              onSaved: (teeShotResult) {
                if (teeShotResult != null) {
                  _scoreData["teeShotResult"] = teeShotResult;
                }
              },
              iconEnabledColor: Colors.white,
              dropdownColor: Colors.grey.shade900,
              style: const TextStyle(color: Colors.white),
              onChanged: (String? value) {
                setState(() {});
              },
              items: widget.parNumber != 3
                  ? const [
                      DropdownMenuItem(value: null, child: Text("選択なし")),
                      DropdownMenuItem(
                        value: "fw",
                        child: Text(
                          "Fairway",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "left",
                        child: Text(
                          "左←",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "right",
                        child: Text(
                          "右→",
                        ),
                      ),
                    ]
                  : [
                      DropdownMenuItem(value: null, child: Text("選択なし")),
                      const DropdownMenuItem(
                        value: "greenOn",
                        child: Text(
                          "on green",
                        ),
                      ),
                      const DropdownMenuItem(
                        value: "greenShort",
                        child: Text(
                          "ショート↓",
                        ),
                      ),
                      const DropdownMenuItem(
                        value: "greenOver",
                        child: Text(
                          "オーバー↑",
                        ),
                      ),
                      const DropdownMenuItem(
                        value: "greenLeft",
                        child: Text(
                          "グリーン左←",
                        ),
                      ),
                      const DropdownMenuItem(
                        value: "greenRight",
                        child: Text(
                          "グリーン右→",
                        ),
                      ),
                    ],
            ),
          ),
          const Gap(10),
          const Text("残り"),
          const Gap(5),
          SizedBox(
            width: 100,
            height: 45,
            child: Center(
              child: TextFormField(
                onSaved: (parOnShotDistance) {
                  if (parOnShotDistance != null) {
                    _scoreData["parOnShotDistance"] = parOnShotDistance;
                  }
                },
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 3,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  counterText: "",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(4),
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          const Gap(5),
          const Text("ヤード"),
          const Gap(10),
          SizedBox(
            width: 130,
            height: 60,
            child: widget.parNumber == 3
                ? const Center(
                    child: Text("Par3は入力不要"),
                  )
                : DropdownButtonFormField<String?>(
                    onSaved: (parOnShotClub) {
                      if (parOnShotClub != null) {
                        _scoreData["parOnShotClub"] = parOnShotClub;
                      }
                    },
                    iconEnabledColor: Colors.white,
                    dropdownColor: Colors.grey.shade900,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (String? value) {
                      setState(() {});
                    },
                    items: golfclubs,
                  ),
          ),
          const Gap(65),
          Transform.scale(
            scale: 2,
            child: Checkbox(
                value: _guardBunker,
                onChanged: (_) {
                  setState(() {
                    _guardBunker = !_guardBunker;
                  });
                  _scoreData["guardBunker"] = _guardBunker;
                }),
          ),
          const Gap(65),
          SizedBox(
            width: 45,
            height: 45,
            child: Center(
              child: TextFormField(
                onSaved: (ob) {
                  if (ob != null) {
                    _scoreData["ob"] = ob;
                  }
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  counterText: "",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(4),
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          const Gap(7),
          SizedBox(
            width: 45,
            height: 45,
            child: Center(
              child: TextFormField(
                onSaved: (hazard) {
                  if (hazard != null) {
                    _scoreData["hazard"] = hazard;
                  }
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  counterText: "",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(4),
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          const Gap(30),
          SizedBox(
            width: 45,
            height: 45,
            child: Center(
              child: TextFormField(
                onSaved: (penalty) {
                  if (penalty != null) {
                    _scoreData["penalty"] = penalty;
                  }
                  final scorecard = ref.read(scoreCardForm.notifier).state;
                  scorecard
                      .addAll({"hole${widget.holeNumber + 1}": _scoreData});
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                decoration: const InputDecoration(
                  fillColor: Colors.white,
                  counterText: "",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(4),
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
