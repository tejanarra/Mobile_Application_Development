import 'package:flutter/foundation.dart';
import 'package:mp3/utils/db_helper.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class FlashCardProvider with ChangeNotifier {
  final List<Deck> _decks = [];
  final List<FlashCard> _flashCards = [];

  List<Deck> get decks => _decks;
  List<FlashCard> get flashCards => _flashCards;

  final DBHelper _dbHelper = DBHelper();

  Future<void> loadInitialData() async {
    var decksData = await _dbHelper.query('decks');
    _decks.addAll(decksData.map((e) => Deck.fromMap(e)));

    var cardsData = await _dbHelper.query('flashcards');
    _flashCards.addAll(cardsData.map((e) => FlashCard.fromMap(e)));

    notifyListeners();
  }

  Future<List<dynamic>> loadFlashcardData() async {
    final jsonString = await rootBundle.loadString('assets/flashcards.json');
    return jsonDecode(jsonString);
  }

  Future<void> initializeDatabaseFromJson() async {
    List<dynamic> flashcardsData = await loadFlashcardData();

    for (var deckData in flashcardsData) {
      String deckTitle = deckData["title"];

      Deck newDeck = Deck(name: deckTitle);
      int deckId = await createDeck(newDeck);

      for (var cardData in deckData["flashcards"]) {
        String question = cardData["question"];
        String answer = cardData["answer"];

        FlashCard newCard = FlashCard(
          question: question,
          answer: answer,
          deckId: deckId,
        );
        await createFlashCard(newCard);
      }
    }
  }

  Future<int> createDeck(Deck deck) async {
    int id = await _dbHelper.insert('decks', deck.toMap());
    _decks.add(Deck(id: id, name: deck.name));
    notifyListeners();
    return id;
  }

  Future<void> deleteDeck(int id) async {
    await _dbHelper.deleteWhere('flashcards', 'deck_id', id);
    _flashCards.removeWhere((flashCard) => flashCard.deckId == id);
    await _dbHelper.delete('decks', id);
    _decks.removeWhere((deck) => deck.id == id);
    notifyListeners();
  }

  Future<void> updateDeck(Deck deck) async {
    await _dbHelper.update('decks', deck.toMap(), deck.id!);
    var index = _decks.indexWhere((d) => d.id == deck.id);
    if (index != -1) {
      _decks[index] = deck;
    }

    notifyListeners();
  }

  Future<void> createFlashCard(FlashCard flashCard) async {
    var id = await _dbHelper.insert('flashcards', flashCard.toMap());
    _flashCards.add(FlashCard(
        id: id,
        question: flashCard.question,
        answer: flashCard.answer,
        deckId: flashCard.deckId));

    notifyListeners();
  }

  Future<void> deleteFlashCard(int id) async {
    await _dbHelper.delete('flashcards', id);
    _flashCards.removeWhere((flashCard) => flashCard.id == id);

    notifyListeners();
  }

  Future<void> updateFlashCard(FlashCard flashCard) async {
    await _dbHelper.update('flashcards', flashCard.toMap(), flashCard.id!);
    var index = _flashCards.indexWhere((fc) => fc.id == flashCard.id);
    if (index != -1) {
      _flashCards[index] = flashCard;
    }

    notifyListeners();
  }
}

class Deck {
  final int? id;
  final String name;

  Deck({this.id, required this.name});
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Deck.fromMap(Map<String, dynamic> map) {
    return Deck(
      id: map['id'],
      name: map['name'],
    );
  }
}

class FlashCard {
  final int? id;
  final String question;
  final String answer;
  final int deckId;

  FlashCard(
      {this.id,
      required this.question,
      required this.answer,
      required this.deckId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'deck_id': deckId,
    };
  }

  factory FlashCard.fromMap(Map<String, dynamic> map) {
    return FlashCard(
      id: map['id'],
      question: map['question'],
      answer: map['answer'],
      deckId: map['deck_id'],
    );
  }
}
