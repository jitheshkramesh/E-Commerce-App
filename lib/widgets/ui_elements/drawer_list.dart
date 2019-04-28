import 'package:flutter/material.dart';
import './logout_list_tile.dart';
import './drawer_profile.dart';

import '../../scoped_model/main.dart';
import '../../components/cart.dart';

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
            leading: Icon(
              Icons.home,
              color: Colors.green,
            ),
            title: Text('Adv Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/advhome');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.green,
            ),
            title: Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.category,
              color: Colors.red,
            ),
            title: Text('Category'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/category');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.assignment,
              color: Colors.red,
            ),
            title: Text('Manage Categories'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/catadmin');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.list,
              color: Colors.red,
            ),
            title: Text('All Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.assignment,
              color: Colors.red,
            ),
            title: Text('Manage Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            title: Text('Wished List'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/wishedList');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.shopping_cart,
              color: Colors.red,
            ),
            title: Text('Shopping Cart'),
            onTap: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => new Cart(model)));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Colors.blue,
            ),
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
