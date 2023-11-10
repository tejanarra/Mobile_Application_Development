import 'package:flutter/material.dart';
import 'package:mp3/models/data.dart';
import 'package:mp3/views/deckedit.dart';
import 'package:mp3/views/flashcards.dart';
import 'package:provider/provider.dart';

class DeckList extends StatefulWidget {
  const DeckList({Key? key}) : super(key: key);

  @override
  DeckListState createState() => DeckListState();
}

class DeckListState extends State<DeckList> {
  @override
  void initState() {
    super.initState();
    Provider.of<FlashCardProvider>(context, listen: false).loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const desiredItemWidth = 200.0;
    final size = (screenWidth / desiredItemWidth).floor();
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            title: const Text('Flashcard Decks'),
            backgroundColor: const Color.fromARGB(255, 2, 132, 130),
            actions: [
              IconButton(
                  icon: const Icon(Icons.download),
                  onPressed: () {
                    final provider =
                        Provider.of<FlashCardProvider>(context, listen: false);
                    provider.initializeDatabaseFromJson();
                  })
            ]),
        body: Consumer<FlashCardProvider>(builder: (context, provider, child) {
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: size),
              itemCount: provider.decks.length,
              itemBuilder: (context, index) {
                final deck = provider.decks[index];
                final flashcardCount = provider.flashCards
                    .where((card) => card.deckId == deck.id)
                    .length;
                return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => FlashCardsPage(deck: deck)));
                    },
                    child: Card(
                        color: const Color.fromARGB(175, 254, 195, 67),
                        child: GridTile(
                            header: Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Color.fromARGB(255, 2, 132, 130),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DeckEditPage(deck: deck)));
                                    })),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    deck.name,
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const SizedBox(height: 10),
                                  Text("($flashcardCount cards)")
                                ]))));
              });
        }),
        floatingActionButton: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 2, 132, 130),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const DeckEditPage()));
            },
            child: const Icon(Icons.add)));
  }
}
