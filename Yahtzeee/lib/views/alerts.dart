import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mp2/models/scorecard.dart';
import 'package:mp2/models/dice.dart';

void showScoreAlreadyRegisteredSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Score already registered for this!'),
    ),
  );
}

showCompletionAlertDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Game Over!'),
        content:
            Text('Your final score is: ${context.read<ScoreCard>().total}'),
        actions: [
          TextButton(
            child: const Text('New Game?'),
            onPressed: () {
              context.read<ScoreCard>().clear();
              context.read<Dice>().resetRolls();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
