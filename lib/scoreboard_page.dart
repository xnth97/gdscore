import 'package:flutter/material.dart';
import 'drawer.dart';
import 'guandan.dart';

class ScoreboardPage extends StatefulWidget {
  final _ScoreboardState state = _ScoreboardState();

  @override
  State<StatefulWidget> createState() {
    return state;
  }
}

class _ScoreboardState extends State<ScoreboardPage> {
  String _leftScore = '0';
  String _rightScore = '0';
  bool _hasWinner = false;
  final GlobalKey<_ScoreboardViewState> _leftScoreboardState =
      GlobalKey<_ScoreboardViewState>();
  final GlobalKey<_ScoreboardViewState> _rightScoreboardState =
      GlobalKey<_ScoreboardViewState>();

  void updateScore() {
    setState(() {
      _leftScore = GDGame().getTotalScore(GameSide.left);
      _rightScore = GDGame().getTotalScore(GameSide.right);
      _hasWinner = GDGame().hasWinner();
    });
    _leftScoreboardState.currentState._updateScoreboard();
    _rightScoreboardState.currentState._updateScoreboard();
  }

  @override
  void initState() {
    super.initState();
  }

  void showActionAlert(
      {context: BuildContext,
      title: String,
      content: String,
      actionTitle: String,
      action: Function}) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                textColor: Theme.of(context).primaryColor,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text(actionTitle),
                textColor: Colors.red,
                onPressed: () {
                  action();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var newGameTitle = _hasWinner ? '新开一局' : '重新开始本局';
    var themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('记分板'),
      ),
      drawer: AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: ScoreboardView(
                    key: _leftScoreboardState,
                    side: GameSide.left,
                    parent: this),
              ),
              Expanded(
                flex: 5,
                child: ScoreboardView(
                    key: _rightScoreboardState,
                    side: GameSide.right,
                    parent: this),
              ),
            ],
          ),
          SizedBox(height: 32),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text('总比分'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                _leftScore,
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                _rightScore,
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.0),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: FlatButton(
              child: Text(newGameTitle),
              textColor: themeData.primaryColor,
              onPressed: () {
                if (_hasWinner) {
                  GDGame().newGame();
                  updateScore();
                } else {
                  showActionAlert(
                      context: context,
                      title: newGameTitle,
                      content: '确定要$newGameTitle？',
                      actionTitle: '确定',
                      action: () {
                        GDGame().newGame();
                        updateScore();
                      });
                }
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: FlatButton(
              child: Text('重设总比分'),
              textColor: themeData.primaryColor,
              onPressed: () {
                showActionAlert(
                    context: context,
                    title: '重设总比分',
                    content: '确定要重设总比分？',
                    actionTitle: '确定',
                    action: () {
                      GDGame().reset();
                      updateScore();
                    });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ScoreboardView extends StatefulWidget {
  final GameSide side;
  final _ScoreboardState parent;
  final _ScoreboardViewState state = _ScoreboardViewState();

  ScoreboardView({Key key, this.side, this.parent}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return state;
  }
}

class _ScoreboardViewState extends State<ScoreboardView> {
  String _score = '2';
  bool _isLastWinner = false;

  void _updateScoreboard() {
    setState(() {
      _score = GDGame().getScore(widget.side);
      _isLastWinner = (GDGame().lastWinner == widget.side);
    });
  }

  void _winGame(GameWinType winType) {
    GDGame().winGame(widget.side, winType);
    widget.parent.updateScore();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 32.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 96.0,
            child: Center(
              child: Text(
                _score,
                style: TextStyle(
                  fontSize: 64.0,
                  fontWeight: FontWeight.w800,
                  color: _isLastWinner
                      ? Theme.of(context).primaryColor
                      : Colors.black,
                ),
              ),
            ),
          ),
          RaisedButton(
            child: Text('双上'),
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _winGame(GameWinType.oneTwo);
            },
          ),
          RaisedButton(
            child: Text('一三'),
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _winGame(GameWinType.oneThree);
            },
          ),
          RaisedButton(
            child: Text('一四'),
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _winGame(GameWinType.oneFour);
            },
          ),
        ],
      ),
    );
  }
}
