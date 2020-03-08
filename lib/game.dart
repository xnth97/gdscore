import 'dart:collection';

import 'package:flutter/foundation.dart';

enum GameSide {
  left,
  right,
}

enum GameWinType {
  oneTwo,
  oneThree,
  oneFour,
}

class GameModel extends ChangeNotifier {
  static final GameModel _singleton = GameModel._internal();

  factory GameModel() {
    return _singleton;
  }

  Map<GameSide, int> scoreMap;
  Map<GameSide, int> numOfA;
  Map<GameSide, int> totalScoreMap;
  GameSide lastWinner;

  static const scoreWin = 99;
  static const maxRoundOfA = 2;

  static LinkedHashMap<int, String> _scoreToStringMap;
  static LinkedHashMap<String, int> _stringToScoreMap;

  GameModel._internal() {
    GameModel._buildScoreToStringMaps();
    reset();
  }

  void reset() {
    totalScoreMap = {
      GameSide.left: 0,
      GameSide.right: 0,
    };
    newGame();
  }

  void newGame() {
    scoreMap = {
      GameSide.left: 2,
      GameSide.right: 2,
    };
    numOfA = {
      GameSide.left: 0,
      GameSide.right: 0,
    };
    lastWinner = null;
    notifyListeners();
  }

  void winGame(GameSide side, GameWinType winType) {
    // current game already has a winner, do not update scoreboard
    if (hasWinner()) {
      return;
    }

    lastWinner = side;
    if (scoreMap[side] == 1) {
      // win this round
      totalScoreMap[side]++;
      scoreMap[side] = scoreWin;
      notifyListeners();
      return;
    }

    switch (winType) {
      case GameWinType.oneTwo:
        scoreMap[side] = _updateScore(scoreMap[side], 3);
        break;

      case GameWinType.oneThree:
        scoreMap[side] = _updateScore(scoreMap[side], 2);
        break;

      case GameWinType.oneFour:
        scoreMap[side] = _updateScore(scoreMap[side], 1);
        break;
    }

    var otherSide = GameModel.getOtherSide(side);
    if (scoreMap[otherSide] == 1) {
      numOfA[otherSide]++;
      if (numOfA[otherSide] == maxRoundOfA) {
        scoreMap[otherSide] = 2;
        numOfA[otherSide] = 0;
      }
    }
    notifyListeners();
  }

  int _updateScore(int score, int add) {
    int total = score + add;
    if (total > 13) {
      return 1;
    } else {
      return total;
    }
  }

  void setScore(GameSide side, int score, {bool isTotalScore = false}) {
    if (isTotalScore) {
      if (scoreMap.keys.contains(side)) {
        scoreMap[side] = score;
      }
    } else {
      if (totalScoreMap.keys.contains(side)) {
        totalScoreMap[side] = score;
      }
    }
    notifyListeners();
  }

  void setScoreMap(
      {Map<GameSide, int> scoreMap, Map<GameSide, int> totalScoreMap}) {
    if (scoreMap != null) {
      this.scoreMap = scoreMap;
    }
    if (totalScoreMap != null) {
      this.totalScoreMap = totalScoreMap;
    }
    notifyListeners();
  }

  String getScore(GameSide side) {
    return GameModel.getScoreString(scoreMap[side]) ?? '2';
  }

  String getTotalScore(GameSide side) {
    return totalScoreMap[side].toString() ?? '0';
  }

  bool hasWinner() {
    return scoreMap.values.contains(scoreWin);
  }

  GameSide winnerSide() {
    for (GameSide side in scoreMap.keys) {
      if (scoreMap[side] == scoreWin) {
        return side;
      }
    }
    return null;
  }

  static void _buildScoreToStringMaps() {
    _scoreToStringMap = LinkedHashMap.of({
      1: 'A',
    });
    for (int i = 2; i < 11; i++) {
      _scoreToStringMap[i] = i.toString();
    }
    _scoreToStringMap.addAll({
      11: 'J',
      12: 'Q',
      13: 'K',
      scoreWin: '胜',
    });
    _stringToScoreMap = LinkedHashMap();
    for (var key in _scoreToStringMap.keys) {
      var val = _scoreToStringMap[key];
      _stringToScoreMap[val] = key;
    }
  }

  static String getScoreString(int score) {
    return _scoreToStringMap[score];
  }

  static int getScoreFromString(String str) {
    return _stringToScoreMap[str];
  }

  static List<int> getAllScores() {
    return _scoreToStringMap.keys.toList();
  }

  static List<String> getAllScoreStrings() {
    return _stringToScoreMap.keys.toList();
  }

  static GameSide getOtherSide(GameSide side) {
    if (side == GameSide.left) {
      return GameSide.right;
    } else {
      return GameSide.left;
    }
  }
}
