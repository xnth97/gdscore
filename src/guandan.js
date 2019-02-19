class GDScore {
  constructor() {
    this.leftScore = 2;
    this.rightScore = 2;
    this.winner = null;
    this.leftTimesOfA = 0;
    this.rightTimesOfA = 0;
    this.currentPlay = null;
    this.leftTotal = 0;
    this.rightTotal = 0;
  }

  leftScoreString() {
    return this.getString(this.leftScore);
  }

  rightScoreString() {
    return this.getString(this.rightScore);
  }

  getString(score) {
    if (score < 11 && score > 1) {
      return `${score}`;
    } else if (score === 11) {
      return 'J';
    } else if (score === 12) {
      return 'Q';
    } else if (score === 13) {
      return 'K';
    } else if (score === 1) {
      return 'A'
    }
  }

  updateScore(team, rank1, rank2) {
    var score = team === 'l' ? this.leftScore : this.rightScore;
    var updatedScore = 0;

    // pass
    if (score === 1 && rank1 === 1) {
      this.winner = team;
      this.currentPlay = null;
      this.updateTotalScore(team);
      return;
    }

    // 1, 2
    if (rank1 === 1 && rank2 === 2) {
      if (score < 11) {
        updatedScore = score + 3;
      } else {
        updatedScore = 1;
      }
    }

    // 1, 3
    if (rank1 === 1 && rank2 === 3) {
      if (score < 12) {
        updatedScore = score + 2;
      } else {
        updatedScore = 1;
      }
    }

    // 1, 4
    if (rank1 === 1 && rank2 === 4) {
      if (score < 13) {
        updatedScore = score + 1;
      } else {
        updatedScore = 1;
      }
    }

    this.assignScore(team, updatedScore);
    this.currentPlay = team;

    if (updatedScore === 1) {
      this.updateTimesOfA(team);
    }

    var anotherTeamScore = team === 'l' ? this.rightScore : this.leftScore;
    const anotherTeam = team === 'l' ? 'r' : 'l';
    if (anotherTeamScore === 1) {
      this.updateTimesOfA(anotherTeam);
      if (this.getTimesOfA(anotherTeam) === 3) {
        this.assignScore(anotherTeam, 2);
        this.resetTimesOfA(anotherTeam);
      }
    }
  }

  getTimesOfA(team) {
    return team === 'l' ? this.leftTimesOfA : this.rightTimesOfA;
  }

  assignScore(team, score) {
    if (team === 'l') {
      this.leftScore = score;
    } else {
      this.rightScore = score;
    }
  }

  resetTimesOfA(team) {
    if (team === 'l') {
      this.leftTimesOfA = 0;
    } else {
      this.rightTimesOfA = 0;
    }
  }

  updateTimesOfA(team) {
    if (team === 'l') {
      this.leftTimesOfA += 1;
    } else {
      this.rightTimesOfA += 1;
    }
  }

  updateTotalScore(team) {
    if (team === 'l') {
      this.leftTotal += 1;
    } else {
      this.rightTotal += 1;
    }
  }

  newGame() {
    this.leftScore = 2;
    this.rightScore = 2;
    this.winner = null;
    this.leftTimesOfA = 0;
    this.rightTimesOfA = 0;
    this.currentPlay = null;
  }

  reset() {
    this.newGame();
    this.leftTotal = 0;
    this.rightTotal = 0;
  }
}

export default GDScore;