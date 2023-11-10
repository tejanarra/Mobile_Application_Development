import 'package:flutter/material.dart';
import 'package:mp3/models/data.dart';
import 'package:mp3/views/flashedit.dart';
import 'package:mp3/views/playquiz.dart';
import 'package:provider/provider.dart';

enum SortMode { byID, alphabetical }

class FlashCardsPage extends StatefulWidget {
  final Deck deck;

  const FlashCardsPage({Key? key, required this.deck}) : super(key: key);

  @override
  FlashCardsPageState createState() => FlashCardsPageState();
}

class FlashCardsPageState extends State<FlashCardsPage> {
  SortMode _currentSortMode = SortMode.byID;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const desiredItemWidth = 175.0;
    final size = (screenWidth / desiredItemWidth).floor();
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 2, 132, 130),
            title: Text(widget.deck.name),
            actions: [
              IconButton(
                  icon: _currentSortMode == SortMode.byID
                      ? const Icon(Icons.access_time)
                      : const Icon(Icons.sort_by_alpha),
                  onPressed: () {
                    setState(() {
                      _currentSortMode = _currentSortMode == SortMode.byID
                          ? SortMode.alphabetical
                          : SortMode.byID;
                    });
                  }),
              IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                QuizPlayPage(deck: widget.deck)));
                  })
            ]),
        body: Consumer<FlashCardProvider>(builder: (context, provider, child) {
          final flashcards = provider.flashCards
              .where((card) => card.deckId == widget.deck.id)
              .toList();

          if (_currentSortMode == SortMode.byID) {
            flashcards.sort((a, b) => a.id!.compareTo(b.id!));
          } else {
            flashcards.sort((a, b) => a.question.compareTo(b.question));
          }

          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: size,
                childAspectRatio: 1,
              ),
              itemCount: flashcards.length,
              itemBuilder: (context, index) {
                final flashcard = flashcards[index];
                return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              FlashCardEditPage(flashcard: flashcard)));
                    },
                    child: Card(
                        color: const Color.fromARGB(175, 239, 115, 81),
                        child: GridTile(
                            child: Center(
                                child: Expanded(
                                    child: AspectRatio(
                                        aspectRatio: 1.0,
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                flashcard.question,
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              )
                                            ])))))));
              });
        }),
        floatingActionButton: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 2, 132, 130),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      FlashCardEditPage(deckId: widget.deck.id)));
            },
            tooltip: 'Add New FlashCard',
            child: const Icon(Icons.add)));
  }
}
