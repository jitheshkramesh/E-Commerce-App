import 'package:flutter/material.dart';
import './logout_list_tile.dart';
import './drawer_profile.dart';

import '../../scoped_model/main.dart';

class DrawerList extends StatelessWidget {
  final MainModel model;
  DrawerList(this.model);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          // AppBar(
          //   automaticallyImplyLeading: false,
          //   title: Text((model.userRegister.firstName == null)
          //       ? model.user.email
          //       : model.userRegister.firstName),
          //   elevation:
          //       Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 6.0,
          // ),
          DrawerProfile(model),
          ListTile(
            leading: Icon(Icons.category),
            title: Text('Category'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/category');
            },
          ), Divider(),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Manage Categories'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/catadmin');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('All Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Wished List'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/wishedList');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Cart Items'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('User Accounts'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),

          Divider(),
          LogoutListTile()
        ],
      ),
    );
  }
}
