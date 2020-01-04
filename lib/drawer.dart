import 'package:flutter/material.dart';
import 'about_page.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0.0),
        children: <Widget>[
          DrawerHeader(
            child: Center(
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
            decoration: BoxDecoration(
              color: themeData.primaryColor,
            ),
          ),
//          ListTile(
//            title: Text('历史'),
//            onTap: () {
//              Navigator.pop(context);
//            },
//          ),
//          Divider(),
          ListTile(
            title: Text('关于'),
            leading: Icon(Icons.help),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutPage()));
            },
          ),
        ],
      ),
    );
  }
}
