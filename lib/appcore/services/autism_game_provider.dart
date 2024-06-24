import 'package:autism_test_drag_drop/domain/models/autism_game.dart';
import 'package:autism_test_drag_drop/domain/models/autism_word_game.dart';
import 'package:flutter/material.dart';

class AutismGameProvider with ChangeNotifier {
  List<AutismGame> words = [
    AutismGame(words: [
      AutismWordGame(word: 'Niña', imageUrl: 'assets/images/child/child.png'),
      AutismWordGame(word: "Va a su", imageUrl: 'assets/images/child/go.png'),
      AutismWordGame(
          word: "Casa de verano", imageUrl: 'assets/images/child/house.png')
    ], imageUrl: "assets/images/child/TestChild.png"),
  ];

  void changeWordCompleted(int sentences, int index) {
    words[sentences].words[index].completed = true;
    notifyListeners();
  }
}
