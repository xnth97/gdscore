enum GameSide {
  left,
  right,
}

enum GameWinType {
  oneTwo,
  oneThree,
  oneFour,
}

class GDGame {
  static final GDGame _singleton = GDGame._internal();

  factory GDGame() {
    return _singleton;
  }

  Map<GameSide, int> scoreMap;
  Map<GameSide, int> numOfA;
  Map<GameSide, int> totalScoreMap;
  GameSide lastWinner;

  static const scoreWin = 99;
  static const maxRoundOfA = 2;

  GDGame._internal() {
    reset();
  }

  void reset() {
    newGame();
    totalScoreMap = {
      GameSide.left: 0,
      GameSide.right: 0,
    };
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

    var otherSide = GDGame.getOtherSide(side);
    if (scoreMap[otherSide] == 1) {
      numOfA[otherSide]++;
      if (numOfA[otherSide] == maxRoundOfA) {
        scoreMap[otherSide] = 2;
        numOfA[otherSide] = 0;
      }
    }
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
  }

  String getScore(GameSide side) {
    return GDGame.getScoreString(scoreMap[side]) ?? '2';
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

  static String getScoreString(int score) {
    if (score == scoreWin) {
      return '胜';
    }
    if (score < 1 || score > 13) {
      return null;
    }
    if (score > 1 && score <= 10) {
      return score.toString();
    }
    const map = {
      11: 'J',
      12: 'Q',
      13: 'K',
      1: 'A',
    };
    return map[score];
  }

  static GameSide getOtherSide(GameSide side) {
    if (side == GameSide.left) {
      return GameSide.right;
    } else {
      return GameSide.left;
    }
  }
}
