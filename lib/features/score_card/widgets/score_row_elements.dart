import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:golfbu_kun/features/score_card/courses/vms/score_card_vm.dart';

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
  final String _puttTotheHole = "";

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
          const Gap(35),
          SizedBox(
            width: 45,
            height: 45,
            child: Center(
              child: SizedBox(
                height: 100,
                child: TextFormField(
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
          ),
          const Gap(28),
          SizedBox(
            width: 45,
            height: 45,
            child: Center(
              child: TextFormField(
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
          const Gap(20),
          SizedBox(
            width: 160,
            height: 60,
            child: DropdownButtonFormField(
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
          const Gap(40),
          SizedBox(
            width: 120,
            height: 60,
            child: DropdownButtonFormField(
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
                DropdownMenuItem(
                  value: "nomiss",
                  child: Text(
                    "ワンパット",
                  ),
                ),
                DropdownMenuItem(
                  value: "left",
                  child: Text(
                    "左外し",
                  ),
                ),
                DropdownMenuItem(
                  value: "right",
                  child: Text(
                    "右外し",
                  ),
                ),
              ],
            ),
          ),
          const Gap(40),
          SizedBox(
            width: 130,
            height: 60,
            child: DropdownButtonFormField(
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
          const Gap(30),
          SizedBox(
            width: 120,
            height: 60,
            child: DropdownButtonFormField(
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
              items: const [
                DropdownMenuItem(
                  value: "1w",
                  child: Text(
                    "1w",
                  ),
                ),
                DropdownMenuItem(
                  value: "3w",
                  child: Text(
                    "3w",
                  ),
                ),
                DropdownMenuItem(
                  value: "5w",
                  child: Text(
                    "1w",
                  ),
                ),
                DropdownMenuItem(
                  value: "2i",
                  child: Text(
                    "2i",
                  ),
                ),
                DropdownMenuItem(
                  value: "3i",
                  child: Text(
                    "3i",
                  ),
                ),
                DropdownMenuItem(
                  value: "4i",
                  child: Text(
                    "4i",
                  ),
                ),
                DropdownMenuItem(
                  value: "5i",
                  child: Text(
                    "5i",
                  ),
                ),
                DropdownMenuItem(
                  value: "6i",
                  child: Text(
                    "6i",
                  ),
                ),
                DropdownMenuItem(
                  value: "7i",
                  child: Text(
                    "7i",
                  ),
                ),
                DropdownMenuItem(
                  value: "8i",
                  child: Text(
                    "8i",
                  ),
                ),
                DropdownMenuItem(
                  value: "9i",
                  child: Text(
                    "9i",
                  ),
                ),
                DropdownMenuItem(
                  value: "pw",
                  child: Text(
                    "PW",
                  ),
                ),
                DropdownMenuItem(
                  value: "sw",
                  child: Text(
                    "SW",
                  ),
                ),
                DropdownMenuItem(
                  value: "lw",
                  child: Text(
                    "LW",
                  ),
                ),
                DropdownMenuItem(
                  value: "pt",
                  child: Text(
                    "pt",
                  ),
                ),
              ],
            ),
          ),
          const Gap(30),
          SizedBox(
            width: 120,
            height: 60,
            child: DropdownButtonFormField(
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
                      DropdownMenuItem(
                        value: "fw",
                        child: Text(
                          "Fairway",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "left",
                        child: Text(
                          "左",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "right",
                        child: Text(
                          "右",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "chipping",
                        child: Text(
                          "チーピン",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "top",
                        child: Text(
                          "トップ",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "tenpura",
                        child: Text(
                          "天ぷら",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "duff",
                        child: Text(
                          "ダフリ",
                        ),
                      ),
                    ]
                  : [
                      const DropdownMenuItem(
                        value: "greenOn",
                        child: Text(
                          "on green",
                        ),
                      ),
                      const DropdownMenuItem(
                        value: "greenShort",
                        child: Text(
                          "ショート",
                        ),
                      ),
                      const DropdownMenuItem(
                        value: "greenOver",
                        child: Text(
                          "オーバー",
                        ),
                      ),
                      const DropdownMenuItem(
                        value: "greenLeft",
                        child: Text(
                          "グリーン左",
                        ),
                      ),
                      const DropdownMenuItem(
                        value: "greenRight",
                        child: Text(
                          "グリーン右",
                        ),
                      ),
                    ],
            ),
          ),
          const Gap(30),
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
          const Gap(30),
          SizedBox(
            width: 120,
            height: 60,
            child: widget.parNumber == 3
                ? const Center(
                    child: Text("Par3は入力不要"),
                  )
                : DropdownButtonFormField(
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
                    items: const [
                      DropdownMenuItem(
                        value: "1w",
                        child: Text(
                          "1w",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "3w",
                        child: Text(
                          "3w",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "5w",
                        child: Text(
                          "1w",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "2i",
                        child: Text(
                          "2i",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "3i",
                        child: Text(
                          "3i",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "4i",
                        child: Text(
                          "4i",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "5i",
                        child: Text(
                          "5i",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "6i",
                        child: Text(
                          "6i",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "7i",
                        child: Text(
                          "7i",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "8i",
                        child: Text(
                          "8i",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "9i",
                        child: Text(
                          "9i",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "pw",
                        child: Text(
                          "PW",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "sw",
                        child: Text(
                          "SW",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "lw",
                        child: Text(
                          "LW",
                        ),
                      ),
                      DropdownMenuItem(
                        value: "pt",
                        child: Text(
                          "pt",
                        ),
                      ),
                    ],
                  ),
          ),
          const Gap(130),
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
          const Gap(92),
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
