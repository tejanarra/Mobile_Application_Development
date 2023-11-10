import 'package:flutter/material.dart';
import 'package:mp3/models/data.dart';
import 'package:provider/provider.dart';

class QuizPlayPage extends StatefulWidget {
  final Deck deck;

  const QuizPlayPage({Key? key, required this.deck}) : super(key: key);

  @override
  QuizPlayPageState createState() => QuizPlayPageState();
}

class QuizPlayPageState extends State<QuizPlayPage> {
  bool showAnswer = false;
  int currentIndex = 0;
  int viewedCount = 0;
  int peekedCount = 0;
  Set<int> viewedCardsSet = {};
  Set<int> peekedCardsSet = {};
  List<FlashCard>? shuffledFlashcards;

  @override
  void initState() {
    super.initState();
    final flashcards = Provider.of<FlashCardProvider>(context, listen: false)
        .flashCards
        .where((card) => card.deckId == widget.deck.id)
        .toList();
    flashcards.shuffle();
    shuffledFlashcards = flashcards;
    viewedCardsSet.add(currentIndex);
    viewedCount = 1;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final cardHeight = screenHeight * 0.5;
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 2, 132, 130),
            title: Text(widget.deck.name)),
        body: shuffledFlashcards != null && shuffledFlashcards!.isNotEmpty
            ? Column(children: [
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                        height: cardHeight,
                        child: Card(
                            color: showAnswer
                                ? Colors.green[100]
                                : Colors.blue[100],
                            child: Center(
                                child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                        showAnswer
                                            ? shuffledFlashcards![currentIndex]
                                                .answer
                                            : shuffledFlashcards![currentIndex]
                                                .question,
                                        style: const TextStyle(fontSize: 18),
                                        textAlign: TextAlign.center)))))),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        setState(() {
                          if (currentIndex == 0) {
                            currentIndex = shuffledFlashcards!.length - 1;
                          } else {
                            currentIndex--;
                          }
                          showAnswer = false;
                          viewedCardsSet.add(currentIndex);
                          viewedCount = viewedCardsSet.length;
                        });
                      }),
                  IconButton(
                      icon: showAnswer
                          ? const Icon(Icons.flip_to_front)
                          : const Icon(Icons.flip_to_back),
                      onPressed: () {
                        setState(() {
                          showAnswer = !showAnswer;
                          if (showAnswer) {
                            peekedCardsSet.add(currentIndex);
                            peekedCount = peekedCardsSet.length;
                          }
                        });
                      }),
                  IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: () {
                        setState(() {
                          if (currentIndex == shuffledFlashcards!.length - 1) {
                            currentIndex = 0;
                          } else {
                            currentIndex++;
                          }
                          showAnswer = false;
                          viewedCardsSet.add(currentIndex);
                          viewedCount = viewedCardsSet.length;
                        });
                      })
                ]),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "Seen $viewedCount of ${shuffledFlashcards!.length} cards"),
                          const SizedBox(height: 15),
                          Text("Peeked at $peekedCount of $viewedCount answers")
                        ]))
              ])
            : const Center(child: Text('No cards in this deck.')));
  }
}
