import 'package:flutter/material.dart';
import 'package:mp3/models/data.dart';
import 'package:provider/provider.dart';

class FlashCardEditPage extends StatefulWidget {
  final FlashCard? flashcard;
  final int? deckId;

  const FlashCardEditPage({Key? key, this.flashcard, this.deckId})
      : super(key: key);

  @override
  FlashCardEditPageState createState() => FlashCardEditPageState();
}

class FlashCardEditPageState extends State<FlashCardEditPage> {
  late TextEditingController _questionController;
  late TextEditingController _answerController;

  @override
  void initState() {
    super.initState();
    _questionController =
        TextEditingController(text: widget.flashcard?.question);
    _answerController = TextEditingController(text: widget.flashcard?.answer);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FlashCardProvider>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 2, 132, 130),
            title: const Text('Edit Card')),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextField(
                  controller: _questionController,
                  decoration: const InputDecoration(labelText: 'Question')),
              TextField(
                  controller: _answerController,
                  decoration: const InputDecoration(labelText: 'Answer')),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                TextButton(
                    onPressed: () async {
                      if (_questionController.text.trim().isEmpty ||
                          _answerController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Fields can't be empty!")));
                        return;
                      }
                      if (widget.flashcard == null) {
                        FlashCard newFlashCard = FlashCard(
                            question: _questionController.text,
                            answer: _answerController.text,
                            deckId: widget.deckId!);
                        await provider.createFlashCard(newFlashCard);
                      } else {
                        FlashCard editedFlashCard = FlashCard(
                            id: widget.flashcard!.id,
                            question: _questionController.text,
                            answer: _answerController.text,
                            deckId: widget.flashcard!.deckId);
                        await provider.updateFlashCard(editedFlashCard);
                      }
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    child: const Text('Save',
                        style: TextStyle(
                            color: Color.fromARGB(255, 2, 132, 130)))),
                if (widget.flashcard != null)
                  TextButton(
                      onPressed: () async {
                        await provider.deleteFlashCard(widget.flashcard!.id!);
                        if (context.mounted) Navigator.of(context).pop();
                      },
                      child: const Text('Delete',
                          style: TextStyle(
                              color: Color.fromARGB(255, 2, 132, 130))))
              ])
            ])));
  }
}
