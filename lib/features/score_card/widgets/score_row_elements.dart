import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ScoreRowElements extends StatefulWidget {
  const ScoreRowElements({
    super.key,
    required this.holeNumber,
    required this.parNumber,
  });

  final String holeNumber;
  final String parNumber;

  @override
  State<ScoreRowElements> createState() => _ScoreRowElementsState();
}

class _ScoreRowElementsState extends State<ScoreRowElements> {
  String _puttTotheHole = "";
  bool _guardBunker = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 1600,
      child: Row(
        children: [
          const Gap(30),
          SizedBox(
            width: 40,
            child: Center(
              child: Text(
                widget.holeNumber,
                style: const TextStyle(fontSize: 29),
              ),
            ),
          ),
          const Gap(50),
          SizedBox(
            width: 40,
            child: Center(
              child: Text(
                widget.parNumber,
                style: const TextStyle(fontSize: 29),
              ),
            ),
          ),
          const Gap(35),
          const SizedBox(
            width: 45,
            height: 45,
            child: Center(
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  counterText: "",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(4),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          const Gap(28),
          const SizedBox(
            width: 45,
            height: 45,
            child: Center(
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  counterText: "",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(4),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          const Gap(10),
          SizedBox(
            width: 140,
            height: 60,
            child: DropdownButtonFormField(
              iconEnabledColor: Colors.white,
              dropdownColor: Colors.grey.shade900,
              style: const TextStyle(color: Colors.white),
              onChanged: (String? value) {
                setState(() {
                  _puttTotheHole = value!;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: "pin",
                  child: Text(
                    "2.5ヤード以内",
                  ),
                ),
                DropdownMenuItem(
                  value: "short",
                  child: Text(
                    "５ヤード以内",
                  ),
                ),
                DropdownMenuItem(
                  value: "middle",
                  child: Text(
                    "10ヤード以内",
                  ),
                ),
                DropdownMenuItem(
                  value: "long",
                  child: Text(
                    "10ヤード以上",
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
              iconEnabledColor: Colors.white,
              dropdownColor: Colors.grey.shade900,
              style: const TextStyle(color: Colors.white),
              onChanged: (String? value) {
                setState(() {
                  _puttTotheHole = value!;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: "Left",
                  child: Text(
                    "左外し",
                  ),
                ),
                DropdownMenuItem(
                  value: "Right",
                  child: Text(
                    "右外し",
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
              iconEnabledColor: Colors.white,
              dropdownColor: Colors.grey.shade900,
              style: const TextStyle(color: Colors.white),
              onChanged: (String? value) {
                setState(() {
                  _puttTotheHole = value!;
                });
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
            width: 110,
            height: 60,
            child: DropdownButtonFormField(
              iconEnabledColor: Colors.white,
              dropdownColor: Colors.grey.shade900,
              style: const TextStyle(color: Colors.white),
              onChanged: (String? value) {
                setState(() {
                  _puttTotheHole = value!;
                });
              },
              items: const [
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
                  value: "miss",
                  child: Text(
                    "チーピン",
                  ),
                ),
                DropdownMenuItem(
                  value: "miss",
                  child: Text(
                    "トップ",
                  ),
                ),
                DropdownMenuItem(
                  value: "miss",
                  child: Text(
                    "天ぷら",
                  ),
                ),
                DropdownMenuItem(
                  value: "miss",
                  child: Text(
                    "ダフリ",
                  ),
                ),
              ],
            ),
          ),
          const Gap(30),
          const Text("残り"),
          const Gap(5),
          const SizedBox(
            width: 100,
            height: 45,
            child: Center(
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 3,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  counterText: "",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(4),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          const Gap(5),
          const Text("ヤード"),
          const Gap(130),
          Transform.scale(
            scale: 2,
            child: Checkbox(
                value: _guardBunker,
                onChanged: (_) {
                  setState(() {
                    _guardBunker = !_guardBunker;
                  });
                }),
          ),
          const Gap(92),
          const SizedBox(
            width: 45,
            height: 45,
            child: Center(
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  counterText: "",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(4),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          const Gap(7),
          const SizedBox(
            width: 45,
            height: 45,
            child: Center(
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  counterText: "",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(4),
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                ),
              ),
            ),
          ),
          const Gap(30),
          const SizedBox(
            width: 45,
            height: 45,
            child: Center(
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  counterText: "",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(4),
                ),
                style: TextStyle(
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
