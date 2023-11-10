import 'package:flutter/material.dart';
import 'package:mp3/models/data.dart';
import 'package:provider/provider.dart';
import 'views/decklist.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FlashCardProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DeckList(),
      ),
    ),
  );
}
