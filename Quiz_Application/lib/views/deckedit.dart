import 'package:flutter/material.dart';
import 'package:mp3/models/data.dart';
import 'package:provider/provider.dart';

class DeckEditPage extends StatefulWidget {
  final Deck? deck;

  const DeckEditPage({Key? key, this.deck}) : super(key: key);

  @override
  DeckEditPageState createState() => DeckEditPageState();
}

class DeckEditPageState extends State<DeckEditPage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.deck?.name);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlashCardProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 2, 132, 130),
            title: const Text('Edit Deck')),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextField(
                          controller: _nameController,
                          decoration:
                              const InputDecoration(labelText: 'Deck Name')),
                      const SizedBox(height: 20),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () async {
                                  if (_nameController.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Deck name can't be empty!")));
                                    return;
                                  }
                                  if (widget.deck == null) {
                                    Deck newDeck =
                                        Deck(name: _nameController.text);
                                    await provider.createDeck(newDeck);
                                  } else {
                                    Deck editedDeck = Deck(
                                        id: widget.deck!.id,
                                        name: _nameController.text);
                                    await provider.updateDeck(editedDeck);
                                  }

                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                  }
                                },
                                style: TextButton.styleFrom(
                                    foregroundColor:
                                        const Color.fromARGB(255, 2, 132, 130)),
                                child: const Text('Save')),
                            if (widget.deck != null)
                              TextButton(
                                  onPressed: () async {
                                    await provider.deleteDeck(widget.deck!.id!);
                                    if (context.mounted) {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                      foregroundColor: const Color.fromARGB(
                                          255, 2, 132, 130)),
                                  child: const Text('Delete'))
                          ])
                    ]))));
  }
}
