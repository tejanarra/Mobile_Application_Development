import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/models/dice.dart';

class DiceRollerScreen extends StatefulWidget {
  const DiceRollerScreen({Key? key}) : super(key: key);

  @override
  DiceRollerScreenState createState() => DiceRollerScreenState();
}

class DiceRollerScreenState extends State<DiceRollerScreen> {
  @override
  Widget build(BuildContext context) {
    var dice = context.watch<Dice>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Wrap(
          spacing: 15.0,
          runSpacing: 15.0,
          children: List.generate(dice.values.length, (index) {
            context.read<Dice>().roll();
            return GestureDetector(
              onTap: () => context.read<Dice>().toggleHold(index),
              child: Container(
                width: 40.0,
                height: 40.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: dice.isHeld(index)
                        ? const Color.fromARGB(255, 29, 137, 78)
                        : const Color.fromARGB(255, 57, 1, 1),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  (dice.values[index]) == 0
                      ? ''
                      : dice.values[index].toString(),
                  style: const TextStyle(fontSize: 30),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10.0),
        ElevatedButton(
            onPressed: dice.rollsLeft > 0
                ? () {
                    context.read<Dice>().roll();
                    context.read<Dice>().decrementRoll();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.teal,
            ),
            child: Text(
              'Roll Dice ${dice.rollsLeft}',
              style: const TextStyle(fontSize: 15),
            )),
      ],
    );
  }
}
