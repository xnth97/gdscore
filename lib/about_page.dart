import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于'),
      ),
      body: Center(
        child: SizedBox(
          height: 64,
          child: Column(
            children: <Widget>[
              Text(
                'gdscore v1.3',
                style: TextStyle(
                  fontSize: 22.0,
                ),
              ),
              Spacer(),
              Text('一个自娱自乐的简易掼蛋记分工具'),
            ],
          ),
        ),
      ),
    );
  }
}
