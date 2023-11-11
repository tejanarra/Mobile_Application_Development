import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/yahtzee.dart';
import 'package:mp2/models/dice.dart';
import 'package:mp2/models/scorecard.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Dice(5)),
        ChangeNotifierProvider(create: (context) => ScoreCard()),
      ],
      child: const MaterialApp(
        title: 'Yahtzee',
        home: Scaffold(body: Yahtzee()),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}
