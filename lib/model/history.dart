class HistoryModel {
  static final HistoryModel _singleton = HistoryModel._internal();

  final List<RoundHistory> _history = [];

  factory HistoryModel() {
    return _singleton;
  }

  HistoryModel._internal();

  void saveRound(String left, String right) {
    var round = RoundHistory(left, right);
    _history.insert(0, round);
  }

  List<RoundHistory> get history => _history;
}

class RoundHistory {
  String left;
  String right;

  RoundHistory(this.left, this.right);
}