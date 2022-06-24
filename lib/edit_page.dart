import 'package:flutter/material.dart';
import 'game.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final Map<GameSide, int> _editedScore = Map.from(GameModel().scoreMap);
  final Map<GameSide, int> _editedTotalScore = Map.from(GameModel().totalScoreMap);

  void saveEdit() {
    GameModel().setScoreMap(
      scoreMap: _editedScore,
      totalScoreMap: _editedTotalScore,
    );
  }

  Widget _buildScoreButton(GameSide side) {
    return DropdownButton<String>(
      value: GameModel.getScoreString(_editedScore[side]!),
      items: GameModel.getAllScoreStrings().map<DropdownMenuItem<String>>(
          (String val) => DropdownMenuItem<String>(
                value: val,
                child: Text(val),
              )).toList(),
      onChanged: (String? val) {
        setState(() {
          _editedScore[side] = GameModel.getScoreFromString(val!);
        });
      },
    );
  }

  Widget _buildTotalScoreTextField(GameSide side) {
    return SizedBox(
      width: 96,
      child: TextFormField(
        initialValue: _editedTotalScore[side].toString(),
        keyboardType: const TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        textAlign: TextAlign.center,
        onChanged: (String text) {
          setState(() {
            _editedTotalScore[side] = int.parse(text);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('编辑比分'),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
            child: Text('本局比分'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildScoreButton(GameSide.left),
              _buildScoreButton(GameSide.right),
            ],
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
            child: Text('总比分'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildTotalScoreTextField(GameSide.left),
              _buildTotalScoreTextField(GameSide.right),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('取消'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('修改'),
          onPressed: () {
            saveEdit();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    // return  Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       mainAxisSize: MainAxisSize.min,
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       children: <Widget>[
    //         Padding(
    //           padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
    //           child: Text('本局比分'),
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           children: <Widget>[
    //             _buildScoreButton(GameSide.left),
    //             _buildScoreButton(GameSide.right),
    //           ],
    //         ),
    //         Padding(
    //           padding: EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
    //           child: Text('总比分'),
    //         ),
    //         Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: <Widget>[
    //             _buildTotalScoreTextField(GameSide.left),
    //             _buildTotalScoreTextField(GameSide.right),
    //           ],
    //         ),
    //       ],
    // );
  }
}
