import 'package:flutter/material.dart';
import './cartlist_icon_counter.dart';
import './wishlist_icon_counter.dart';
import '../scoped_model/main.dart';

class AppBarPage extends StatelessWidget {
  final String addText;
  final MainModel model;
  AppBarPage(this.addText, this.model);

  @override
  Widget build(BuildContext context) {
    return new AppBar(
      title: Text('E-Commerce Home Page'),
      actions: <Widget>[
        // new IconButton(
        //   icon: Icon(Icons.favorite),
        //   onPressed: () {
        //     Navigator.pushReplacementNamed(context, '/wishedList');
        //   },
        // ),
        WishListIconCounter(model),
        CartListIconCounter(model),
        // new IconButton(
        //   icon: Icon(Icons.shopping_cart),
        //   onPressed: () {
        //     Navigator.push(
        //         context, MaterialPageRoute(builder: (context) => new Cart()));
        //   },
        // ),
      ],
    );
  }
}
