import 'package:flutter/material.dart';
import 'package:gdscore/view/history_page.dart';
import 'about_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);

    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0.0),
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: themeData.primaryColor,
            ),
            child: const Center(
              child: Text(
                'gdscore',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'monospace',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
         ListTile(
           title: const Text('历史'),
           leading: const Icon(Icons.history),
           onTap: () {
             Navigator.pop(context);
             Navigator.push(context, MaterialPageRoute(builder: (context) => const HistoryPage()));
           },
         ),
         const Divider(),
          ListTile(
            title: const Text('关于'),
            leading: const Icon(Icons.help),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutPage()));
            },
          ),
        ],
      ),
    );
  }
}
