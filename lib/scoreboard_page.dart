import 'package:flutter/material.dart';
import 'drawer.dart';
import 'guandan.dart';
import 'edit_page.dart';

class ScoreboardPage extends StatefulWidget {
  final _ScoreboardState state = _ScoreboardState();

  @override
  State<StatefulWidget> createState() => state;
}

class _ScoreboardState extends State<ScoreboardPage> {
  String _leftScore = '0';
  String _rightScore = '0';
  bool _hasWinner = false;
  final GlobalKey<_ScoreboardViewState> _leftScoreboardState =
      GlobalKey<_ScoreboardViewState>();
  final GlobalKey<_ScoreboardViewState> _rightScoreboardState =
      GlobalKey<_ScoreboardViewState>();

  static const String _newGameButtonTitle = '新开局';
  static const String _restartGameButtonTitle = '重新开始';
  static const String _resetGameButtonTitle = '重设总比分';

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
      {@required BuildContext context,
      @required String title,
      String content,
      String actionTitle,
      void Function() action}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
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
            textColor: Theme.of(context).errorColor,
            onPressed: () {
              action();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void showActionSheet({@required BuildContext context}) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => BottomSheet(
        enableDrag: true,
        onClosing: () {},
        builder: (context) => ListView(
          children: <Widget>[
            ListTile(
              title: Text(_newGameButtonTitle),
              leading: Icon(Icons.play_arrow),
              enabled: _hasWinner,
              onTap: () {
                Navigator.of(context).pop();
                _newGame();
              },
            ),
            ListTile(
              title: Text(_restartGameButtonTitle),
              leading: Icon(Icons.replay),
              enabled: !_hasWinner,
              onTap: () {
                Navigator.of(context).pop();
                _restartThisGame();
              },
            ),
            ListTile(
              title: Text('编辑比分'),
              leading: Icon(Icons.edit),
              onTap: () {
                Navigator.of(context).pop();
                showEditPage();
              },
            ),
            ListTile(
              title: Text(
                _resetGameButtonTitle,
                style: TextStyle(color: Theme.of(context).errorColor),
              ),
              leading: Icon(Icons.restore, color: Theme.of(context).errorColor),
              onTap: () {
                Navigator.of(context).pop();
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
            Divider(),
            ListTile(
              title: Text('取消'),
              leading: Icon(Icons.close),
              onTap: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  void showEditPage() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => EditPage()))
        .then((_) => updateScore());
  }

  void _restartThisGame() {
    showActionAlert(
        context: context,
        title: _restartGameButtonTitle,
        content: '确定要重新开始本局？',
        actionTitle: '确定',
        action: () {
          GDGame().newGame();
          updateScore();
        });
  }

  void _newGame() {
    GDGame().newGame();
    updateScore();
  }

  Widget _buildFAB() {
    var newGameTitle =
        _hasWinner ? _newGameButtonTitle : _restartGameButtonTitle;
    var fabIcon = _hasWinner ? Icons.play_arrow : Icons.replay;

    return FloatingActionButton.extended(
      onPressed: () {
        if (_hasWinner) {
          _newGame();
        } else {
          _restartThisGame();
        }
      },
      label: Text(newGameTitle),
      icon: Icon(fabIcon),
      backgroundColor: Theme.of(context).accentColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('记分板'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {
              showActionSheet(context: context);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      floatingActionButton: _buildFAB(),
      body: SingleChildScrollView(
        child: Column(
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
          ],
        ),
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
  State<StatefulWidget> createState() => state;
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
            child: Text('一三名'),
            textColor: Colors.white,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _winGame(GameWinType.oneThree);
            },
          ),
          RaisedButton(
            child: Text('一四名'),
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
