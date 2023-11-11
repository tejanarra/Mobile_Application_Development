import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mp2/models/scorecard.dart';
import 'package:mp2/models/dice.dart';
import 'package:mp2/views/alerts.dart';

class ScoreCardView extends StatelessWidget {
  const ScoreCardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var scoreCard = context.watch<ScoreCard>();
    const categories = ScoreCategory.values;

    return Column(
      children: [
        for (int i = 0; i < categories.length; i += 2)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _scoreCardItem(context, categories[i], scoreCard[categories[i]]),
              if (i + 1 < categories.length)
                _scoreCardItem(
                    context, categories[i + 1], scoreCard[categories[i + 1]])
              else
                const SizedBox.shrink(),
            ],
          ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Your Score: ${scoreCard.total}'),
        ),
      ],
    );
  }

  Widget _scoreCardItem(
      BuildContext context, ScoreCategory category, int? score) {
    var dice = context.watch<Dice>();
    var scoreCard = context.watch<ScoreCard>();

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            if (scoreCard[category] == null && dice.rollsLeft != 3) {
              context.read<ScoreCard>().registerScore(category, dice.values);
              dice.resetRolls();
              if (context.read<ScoreCard>().completed) {
                showCompletionAlertDialog(context);
              }
            } else {
              showScoreAlreadyRegisteredSnackBar(context);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category.name),
              score != null
                  ? Text(score.toString())
                  : const Icon(
                      Icons.radio_button_off_sharp,
                      size: 15,
                    )
            ],
          ),
        ),
      ),
    );
  }
}
