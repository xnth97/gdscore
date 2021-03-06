import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'drawer.dart';
import 'game.dart';
import 'edit_page.dart';

class ScoreboardPage extends StatelessWidget {

  static const String _newGameButtonTitle = '新开局';
  static const String _restartGameButtonTitle = '重新开始';
  static const String _resetGameButtonTitle = '重设总比分';

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

  void showActionSheet(bool newGameEnabled, bool restartEnabled, {@required BuildContext context}) {
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
              enabled: newGameEnabled,
              onTap: () {
                Navigator.of(context).pop();
                _newGame();
              },
            ),
            ListTile(
              title: Text(_restartGameButtonTitle),
              leading: Icon(Icons.replay),
              enabled: restartEnabled,
              onTap: () {
                Navigator.of(context).pop();
                _restartThisGame(context: context);
              },
            ),
            ListTile(
              title: Text('编辑比分'),
              leading: Icon(Icons.edit),
              onTap: () {
                Navigator.of(context).pop();
                showEditPage(context: context);
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
                      GameModel().reset();
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

  void showEditPage({@required BuildContext context}) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => EditPage()));
  }

  void _restartThisGame({@required BuildContext context}) {
    showActionAlert(
        context: context,
        title: _restartGameButtonTitle,
        content: '确定要重新开始本局？',
        actionTitle: '确定',
        action: () {
          GameModel().newGame();
        });
  }

  void _newGame() {
    GameModel().newGame();
//    updateScore();
  }

  Widget _buildFAB(bool hasWinner, {@required BuildContext context}) {
    var newGameTitle =
        hasWinner ? _newGameButtonTitle : _restartGameButtonTitle;
    var fabIcon = hasWinner ? Icons.play_arrow : Icons.replay;

    return FloatingActionButton.extended(
      onPressed: () {
        if (hasWinner) {
          _newGame();
        } else {
          _restartThisGame(context: context);
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
          Consumer<GameModel>(
            builder: (context, model, child) {
              return IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  showActionSheet(model.hasWinner(), !model.hasWinner(), context: context);
                },
              );
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      floatingActionButton: Consumer<GameModel>(
        builder: (context, model, child) {
          return _buildFAB(model.hasWinner(), context: context);
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: ScoreboardView(side: GameSide.left),
                ),
                Expanded(
                  flex: 5,
                  child: ScoreboardView(side: GameSide.right),
                ),
              ],
            ),
            SizedBox(height: 32),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('总比分'),
            ),
            Consumer<GameModel>(
              builder: (context, model, child) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(
                      model.getTotalScore(GameSide.left),
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      model.getTotalScore(GameSide.right),
                      style: TextStyle(
                        fontSize: 36.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreboardView extends StatelessWidget {
  final GameSide side;

  ScoreboardView({Key key, this.side}) : super(key: key);

  void _winGame(GameWinType winType) {
    GameModel().winGame(side, winType);
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
              child: Consumer<GameModel>(
                builder: (context, model, child) {
                  return Text(
                    model.getScore(side),
                    style: TextStyle(
                      fontSize: 64.0,
                      fontWeight: FontWeight.w800,
                      color: model.lastWinner == side
                          ? Theme.of(context).primaryColor
                          : Colors.black,
                    ),
                  );
                },
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
