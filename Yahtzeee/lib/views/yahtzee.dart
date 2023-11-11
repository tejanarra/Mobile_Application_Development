import 'package:flutter/material.dart';
import 'package:mp2/views/diceview.dart';
import 'package:mp2/views/scoreview.dart';

class Yahtzee extends StatefulWidget {
  const Yahtzee({Key? key}) : super(key: key);

  @override
  YahtzeeState createState() => YahtzeeState();
}

class YahtzeeState extends State<Yahtzee> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 212, 216, 214),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 50, 146, 124),
        elevation: 10,
        title: const Text(
          'Yahtzee',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: const Column(
        children: [
          Flexible(
            flex: 1,
            child: DiceRollerScreen(),
          ),
          Flexible(
            flex: 3,
            child: ScoreCardView(),
          ),
        ],
      ),
    );
  }
}
