import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于'),
      ),
      body: Center(
        child: SizedBox(
          height: 64,
          child: Column(
            children: const <Widget>[
              Text(
                'gdscore v1.4',
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
