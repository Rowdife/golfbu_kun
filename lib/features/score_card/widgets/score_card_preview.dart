import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:golfbu_kun/features/score_card/models/score_card_model.dart';

class ScoreCardPreview extends ConsumerStatefulWidget {
  const ScoreCardPreview({super.key, required this.scorecard});
  final ScoreCardModel scorecard;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ScoreCardPreviewState();
}

class _ScoreCardPreviewState extends ConsumerState<ScoreCardPreview> {
  @override
  Widget build(BuildContext context) {
    print(widget.scorecard.scorecard['hole1']);
    return Scaffold(
      appBar: AppBar(
        title: const Text("スコアカード"),
      ),
    );
  }
}
