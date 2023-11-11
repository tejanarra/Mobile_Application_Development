import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import 'dart:math';

class Dice with ChangeNotifier {
  final List<int?> _values;
  final List<bool> _held;
  int rolit = 3;

  final int maxRolls = 3;
  int rollsLeft = 3;

  void resetRolls() {
    rollsLeft = maxRolls;
    clear();
    notifyListeners();
  }

  void decrementRoll() {
    if (rollsLeft > 0) {
      rollsLeft--;
      notifyListeners();
    }
  }

  Dice(int numDice)
      : _values = List<int?>.filled(numDice, null),
        _held = List<bool>.filled(numDice, false);

  List<int> get values => List<int>.unmodifiable(_values.whereNotNull());

  int? operator [](int index) => _values[index];

  bool isHeld(int index) => _held[index];

  void clear() {
    for (var i = 0; i < _values.length; i++) {
      _values[i] = 0;
      _held[i] = false;
    }
    notifyListeners();
  }

  void roll() {
    for (var i = 0; i < _values.length; i++) {
      if (!_held[i]) {
        _values[i] = Random().nextInt(6) + 1;
      }
    }
    notifyListeners();
  }

  void toggleHold(int index) {
    _held[index] = !_held[index];
    notifyListeners();
  }
}
